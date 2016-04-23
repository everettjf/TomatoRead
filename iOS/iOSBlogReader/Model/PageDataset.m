//
//  BlogDataset.m
//  iOSBlogReader
//
//  Created by everettjf on 16/4/6.
//  Copyright © 2016年 everettjf. All rights reserved.
//


#import "PageDataset.h"
#import "RestApi.h"
#import "DomainModel.h"
#import "AspectModel.h"


@implementation PageItemEntity
- (NSUInteger)aspectID{
    NSNumber *number = (id)_data;
    return number.unsignedIntegerValue;
}
@end

@implementation PageDataset

+ (PageDataset *)sharedDataset{
    static PageDataset *inst;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        inst = [PageDataset new];
    });
    return inst;
}

- (void)prepare:(void (^)(BOOL succeed))complete{
    NSMutableArray<PageItemEntity*> *pages = [NSMutableArray new];
    
    // Feed Posts
    PageItemEntity *feedEntity = [PageItemEntity new];
    feedEntity.type = PageItemType_FeedPost;
    feedEntity.title = @"订阅";
    [pages addObject:feedEntity];
    
    // Feed Souce
    PageItemEntity *sourceEntity = [PageItemEntity new];
    sourceEntity.type = PageItemType_FeedSource;
    sourceEntity.title = @"源";
    [pages addObject:sourceEntity];
    
    // Links
    // First ,check core date
    NSArray<DomainModel*> *domains = [DomainModel MR_findAll];
    for (DomainModel *domain in domains) {
        if(![domain.name isEqualToString:@"iOS"])
            continue;
        // iOS
        NSArray *arrayAspects = [domain.aspects sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"oid" ascending:YES]]];
        for (AspectModel *aspect in arrayAspects) {
            PageItemEntity *linkEntity = [PageItemEntity new];
            linkEntity.type = PageItemType_Link;
            linkEntity.title = aspect.name;
            linkEntity.data = aspect.oid;
            [pages addObject:linkEntity];
        }
    }
    
    BOOL alreadyCallback = NO;
    if(domains.count > 0){
        _items = pages;
        complete(YES);
        alreadyCallback = YES;
    }
    
    // Then , rest api
    [[RestApi api]queryDomainList:^(RestDomainListModel *model, NSError *error) {
        if(error){
            complete(NO);
            return;
        }
        
        if(model.results.count == 0){
            complete(NO);
            return;
        }
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            for (RestDomainModel *domain in model.results) {
                [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
                    DomainModel *model = [DomainModel MR_findFirstOrCreateByAttribute:@"oid" withValue:@(domain.oid) inContext:localContext];
                    model.name = domain.name;
                    
                    for (RestAspectModel *aspect in domain.aspect_set) {
                        AspectModel *aspectModel = [AspectModel MR_findFirstOrCreateByAttribute:@"oid" withValue:@(aspect.oid) inContext:localContext];
                        aspectModel.name = aspect.name;
                        aspectModel.domain = model;
                        
                        if(!alreadyCallback){
                            PageItemEntity *linkEntity = [PageItemEntity new];
                            linkEntity.type = PageItemType_Link;
                            linkEntity.title = aspect.name;
                            linkEntity.data = @(aspect.oid);
                            [pages addObject:linkEntity];
                        }
                    }
                }];
            }
            
            if(!alreadyCallback){
                _items = pages;
                dispatch_async(dispatch_get_main_queue(), ^{
                    complete(YES);
                });
            }
        });
    }];
}

@end
