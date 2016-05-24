//
//  FeedSourceManager.m
//  iOSBlogReader
//
//  Created by everettjf on 16/4/24.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#import "FeedSourceManager.h"
#import "RestApi.h"
#import "DataManager.h"
#import "FeedModel.h"

@implementation FeedSourceUIEntity
- (instancetype)init
{
    self = [super init];
    if (self) {
        _link = [RestLinkModel new];
    }
    return self;
}
@end

@implementation FeedSourceManager

+ (FeedSourceManager *)manager{
    static FeedSourceManager *o;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        o = [FeedSourceManager new];
    });
    return o;
}


- (void)requestFeedSources:(void (^)(BOOL))completion{
    [[RestApi api]queryFeedVersion:^(NSString *version) {
        if(!version){
            completion(NO);
            return;
        }
        
        BOOL needRequest = NO;
        NSString *localVersion = [[DataManager manager]getFeedVersion];
        if(localVersion){
            needRequest = ![localVersion isEqualToString:version];
        }else{
            needRequest = YES;
        }
        
        if(!needRequest){
            NSLog(@"Feed list version is already latest : %@", version);
            completion(YES);
            return;
        }
        
        
        [[RestApi api]queryFeedList:^(RestFeedListModel *model, NSError *error) {
            if(!model){
                completion(NO);
                return;
            }
            
            // Persist
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSMutableSet<NSNumber*> *oidset = [[NSMutableSet alloc]initWithCapacity:model.feeds.count];
                for (RestLinkModel *feed in model.feeds) {
                    [oidset addObject:@(feed.oid)];
                    
                    [[DataManager manager]findOrCreateFeed:feed.oid callback:^(FeedModel * _Nullable m) {
                        m.favicon = feed.favicon;
                        m.feed_url = feed.feed_url;
                        m.name = feed.name;
                        m.oid = @(feed.oid);
                        m.url = feed.url;
                        m.spider = feed.spider;
                        m.zindex = @(feed.zindex);
                    }];
                }
                
                [[DataManager manager]rebuildFeeds:oidset];
                
                [[DataManager manager]saveFeedVersion:version];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(YES);
                });
            });
        }];
    }];
}

- (void)queryFeedSources:(NSUInteger)offset limit:(NSUInteger)limit completion:(void (^)(NSArray<FeedSourceUIEntity *> *, NSUInteger))completion{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray<FeedModel*> *feedSources = [[DataManager manager]findAllFeed:offset limit:limit];
        NSUInteger totalCount = [[DataManager manager]countFeed];
        
        NSMutableArray<FeedSourceUIEntity*> *entities = [NSMutableArray new];
        for (FeedModel *model in feedSources) {
            FeedSourceUIEntity *entity = [FeedSourceUIEntity new];
            entity.link.favicon = model.favicon;
            entity.link.feed_url = model.feed_url;
            entity.link.name = model.name;
            entity.link.oid = model.oid.unsignedIntegerValue;
            entity.link.url = model.url;
            entity.link.spider = model.spider;
            entity.link.zindex = model.zindex.unsignedIntegerValue;
            
            entity.post_count = model.items.count;
            entity.latest_post_date = model.latest_post_date;
            
            [entities addObject:entity];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(entities, totalCount);
        });
    });
}
@end
