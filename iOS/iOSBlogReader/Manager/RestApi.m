//
//  RestApi.m
//  iOSBlogReader
//
//  Created by everettjf on 16/4/7.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#import "RestApi.h"

static NSString * const kRestServer = @"https://everettjf.github.io/app/blogreader/";

@implementation RestApi

+ (RestApi *)api{
    static RestApi *o;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        o = [RestApi new];
    });
    return o;
}

- (NSString*)_service:(NSString*)serviceName{
    return [kRestServer stringByAppendingString:serviceName];
}

- (void)queryDomainList:(void (^)(RestDomainListModel *, NSError *))complete{
    
    [[AFHTTPSessionManager manager]GET:[self _service:@"domains.json"]
                            parameters:nil
                              progress:nil
                               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                   RestDomainListModel *model = [RestDomainListModel yy_modelWithDictionary:responseObject];
                                   complete(model,nil);
                              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                  complete(nil,error);
                              }];
    
}

- (void)queryFeedList:(void (^)(RestLinkListModel * , NSError * ))complete url:(NSString *)url{
    NSString *requestUrl = url;
    if(!requestUrl)requestUrl=[self _service:@"1_feeds.json"];
    
    [[AFHTTPSessionManager manager]GET:requestUrl
                            parameters:nil
                              progress:nil
                               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                   RestLinkListModel *model = [RestLinkListModel yy_modelWithDictionary:responseObject];
                                   complete(model,nil);
                               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                   complete(nil,error);
                               }];
    
}

-(void)queryLinkList:(NSUInteger)aspectID complete:(void (^)(RestLinkListModel *, NSError *))complete url:(NSString *)url{
    NSString *requestUrl = url;
    if(!requestUrl) requestUrl=[NSString stringWithFormat:@"%@/%@", [self _service:@"bookmarks_in_aspect"],@(aspectID)];
    
    [[AFHTTPSessionManager manager]GET:requestUrl
                            parameters:nil
                              progress:nil
                               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                   RestLinkListModel *model = [RestLinkListModel yy_modelWithDictionary:responseObject];
                                   complete(model,nil);
                               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                   complete(nil,error);
                               }];
    
}
@end
