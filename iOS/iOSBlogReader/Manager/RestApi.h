//
//  RestApi.h
//  iOSBlogReader
//
//  Created by everettjf on 16/4/7.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestDomainListModel.h"
#import "RestLinkListModel.h"
#import "RestSpiderPostListModel.h"

@interface RestApi : NSObject

+ (RestApi*)api;

- (void)queryDomainList:(void(^)(RestDomainListModel* model, NSError *error))complete;

- (void)queryFeedVersion:(void(^)(NSString* version))complete;
- (void)queryFeedList:(void(^)(RestFeedListModel * model, NSError *error))complete;

- (void)queryLinkList:(NSUInteger)aspectID page:(NSUInteger)page complete:(void(^)(RestLinkListModel* model, NSError *error))complete;

- (void)querySpiderPostList:(NSString *)spider feedID:(NSUInteger)feedID complete:(void(^)(RestSpiderPostListModel *model, NSError *error))complete;

@end
