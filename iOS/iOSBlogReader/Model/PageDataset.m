//
//  BlogDataset.m
//  iOSBlogReader
//
//  Created by everettjf on 16/4/6.
//  Copyright © 2016年 everettjf. All rights reserved.
//


#import "PageDataset.h"
#import "RestApi.h"


@implementation PageItemEntity
- (NSString *)feedData{ return _data;}
- (RestAspectModel *)linkData{ return _data;}
- (NSString *)title{ return _type == PageItemType_Feed ? self.feedData : self.linkData.name; }
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
    
    // Feed
    PageItemEntity *feedEntity = [PageItemEntity new];
    feedEntity.type = PageItemType_Feed;
    feedEntity.data = @"订阅";
    [pages addObject:feedEntity];
    
    // Links
    [[RestApi api]queryDomainList:^(RestDomainListModel *model, NSError *error) {
        if(error){
            complete(NO);
            return;
        }
        
        if(model.results.count == 0){
            complete(NO);
            return;
        }
        
        RestDomainModel *domainModel;
        if(model.results.count == 1){
            domainModel = model.results.firstObject;
        }else{
            for (RestDomainModel *domain in model.results) {
                if([domain.name isEqualToString:@"iOS"]){
                    domainModel = domain;
                    break;
                }
            }
            if(!domainModel) domainModel = model.results.firstObject;
        }
        for (RestAspectModel *aspect in domainModel.aspect_set) {
            PageItemEntity *linkEntity = [PageItemEntity new];
            linkEntity.type = PageItemType_Link;
            linkEntity.data = aspect;
            [pages addObject:linkEntity];
        }
        
        _items = pages;
        complete(YES);
    }];
}

@end
