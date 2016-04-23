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
#import <MagicalRecord/MagicalRecord.h>
#import "FeedModel.h"

@implementation FeedSourceUIEntity
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


- (void)_queryAllFeeds:(void (^)(NSMutableArray<RestLinkModel*> *feeds))completion{
    NSMutableArray<RestLinkModel*> *feeds = [NSMutableArray new];
    [self _queryAllFeeds:completion next:nil feeds:feeds];
    
}
- (void)_queryAllFeeds:(void (^)(NSMutableArray<RestLinkModel*> *feeds))completion next:(NSString*)next feeds:(NSMutableArray*)feeds{
    [[RestApi api]queryFeedList:^(RestLinkListModel *model, NSError *error) {
        if(error){
            completion(nil);
            return;
        }
        
        [feeds addObjectsFromArray:model.results];
        
        if(model.next){
            // call
            [self _queryAllFeeds:completion next:model.next feeds:feeds];
        }else{
            completion(feeds);
        }
    } url:next];
}
- (void)loadFeedSources:(void (^)(BOOL))completion{
    [self _queryAllFeeds:^(NSMutableArray<RestLinkModel *> *feeds) {
        if(!feeds){
            completion(NO);
            return;
        }
        
        // Persist
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
                for (RestLinkModel *feed in feeds) {
                    FeedModel *feedModel = [FeedModel MR_findFirstOrCreateByAttribute:@"oid" withValue:@(feed.oid) inContext:localContext];
                    feedModel.oid = @(feed.oid);
                    feedModel.feed_url = feed.feed_url;
                    feedModel.name = feed.name;
                    feedModel.url = feed.url;
                    feedModel.desc = feed.desc;
                    feedModel.updated_at = feed.updated_at;
                    feedModel.favicon = feed.favicon;
                }
            }];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(YES);
            });
        });
    }];
}

- (void)fetchFeedSources:(NSUInteger)offset limit:(NSUInteger)limit completion:(void (^)(NSArray<FeedSourceUIEntity *> *, NSUInteger))completion{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        NSManagedObjectContext *context = [NSManagedObjectContext MR_contextForCurrentThread];
#pragma clang diagnostic pop
        NSFetchRequest *request = [FeedModel MR_requestAllSortedBy:@"updated_at" ascending:NO inContext:context];
        [request setFetchOffset:offset];
        [request setFetchLimit:limit];

        NSArray<FeedModel*> *feedSources = [FeedModel MR_executeFetchRequest:request inContext:context];
        NSUInteger totalCount = [FeedModel MR_countOfEntitiesWithContext:context];
        
        NSMutableArray<FeedSourceUIEntity*> *entities = [NSMutableArray new];
        for (FeedModel *model in feedSources) {
            FeedSourceUIEntity *entity = [FeedSourceUIEntity new];
            entity.oid = model.oid.unsignedIntegerValue;
            entity.name = model.name;
            entity.url = model.url;
            entity.feed_url = model.feed_url;
            entity.favicon = model.favicon;
            entity.desc = model.desc;
            entity.updated_at = model.updated_at;
            [entities addObject:entity];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(entities, totalCount);
        });
    });
}
@end
