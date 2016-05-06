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

- (void)_saveFeedVersion:(NSString*)version{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:version forKey:@"1_feed.version"];
    [def synchronize];
}

- (NSString*)_getFeedVersion{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *ver = [def objectForKey:@"1_feed.version"];
    if(!ver) ver = @"";
    return ver;
}

- (void)_queryFeedVersion:(void(^)(NSString* version))complete{
    [[AFHTTPSessionManager manager]GET:[self _service:@"1_feeds.version"]
                            parameters:nil
                              progress:nil
                               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                   NSLog(@"%@",responseObject);
                                   NSString *version = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                                   NSLog(@"version = %@",version);
                                   
                                   complete(version);
                               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                   complete(nil);
                               }];
}


- (void)queryFeedList:(void (^)(RestFeedListModel *, NSError *))complete{
    
    
    [[AFHTTPSessionManager manager]GET:[self _service:@"1_feeds.json"]
                            parameters:nil
                              progress:nil
                               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                   RestFeedListModel *model = [RestFeedListModel yy_modelWithDictionary:responseObject];
                                   complete(model,nil);
                               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                   complete(nil,error);
                               }];
    
}

- (void)queryLinkList:(NSUInteger)aspectID page:(NSUInteger)page complete:(void (^)(RestLinkListModel *, NSError *))complete{
    NSString *url = [NSString stringWithFormat:@"%@_link%@.json",@(aspectID),@(page)];
    [[AFHTTPSessionManager manager]GET:[self _service:url]
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
