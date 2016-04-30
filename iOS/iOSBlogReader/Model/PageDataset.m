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
#import "DataManager.h"


@implementation PageItemEntity
- (NSUInteger)aspectID{
    NSNumber *number = (id)_data;
    return number.unsignedIntegerValue;
}
@end

@implementation PageDataset

+ (PageDataset *)dataset{
    static PageDataset *o;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        o = [[PageDataset alloc]init];
    });
    return o;
}

- (void)prepareFeed:(void (^)(NSArray<PageItemEntity *> *, BOOL))complete{
    NSMutableArray<PageItemEntity*> *pages = [NSMutableArray new];
    
    // Feed Posts
    PageItemEntity *feedEntity = [PageItemEntity new];
    feedEntity.type = PageItemType_FeedPost;
    feedEntity.title = @"文章";
    [pages addObject:feedEntity];
    
    // Feed Souce
    PageItemEntity *sourceEntity = [PageItemEntity new];
    sourceEntity.type = PageItemType_FeedSource;
    sourceEntity.title = @"源";
    [pages addObject:sourceEntity];
    
    complete(pages,YES);
}

- (void)prepareDiscover:(void (^)(NSArray<PageItemEntity *> *, BOOL))complete{
    NSMutableArray<PageItemEntity*> *pages = [NSMutableArray new];
    
    // First ,check core date
    NSArray<DomainModel*> *domains = [DomainModel mcd_findAll];
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
        complete(pages,YES);
        alreadyCallback = YES;
    }
    
    // Then , rest api
    [[RestApi api]queryDomainList:^(RestDomainListModel *model, NSError *error) {
        if(error){
            complete(nil,NO);
            return;
        }
        
        if(model.results.count == 0){
            complete(nil,NO);
            return;
        }
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            for (RestDomainModel *domain in model.results) {
                
                __block DomainModel *domainModel;
                [DomainModel mcd_findOrCreate:@"oid" value:@(domain.oid) callback:^(NSManagedObject *m) {
                    domainModel = (id)m;
                    domainModel.name = domain.name;
                }];
                
                for (RestAspectModel *aspect in domain.aspect_set) {
                    [AspectModel mcd_findOrCreate:@"oid" value:@(aspect.oid) callback:^(NSManagedObject *m) {
                        AspectModel *aspectModel = (id)m;
                        aspectModel.name = aspect.name;
                        aspectModel.domain = domainModel;
                    }];
                    
                    if(!alreadyCallback){
                        PageItemEntity *linkEntity = [PageItemEntity new];
                        linkEntity.type = PageItemType_Link;
                        linkEntity.title = aspect.name;
                        linkEntity.data = @(aspect.oid);
                        [pages addObject:linkEntity];
                    }
                }
            }
            
            if(!alreadyCallback){
                dispatch_async(dispatch_get_main_queue(), ^{
                    complete(pages,YES);
                });
            }
        });
    }];
}

@end
