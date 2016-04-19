//
//  FeedManager.m
//  iOSBlogReader
//
//  Created by everettjf on 16/4/10.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#import "FeedManager.h"
#import "RestApi.h"
#import "DataManager.h"
#import <MagicalRecord/MagicalRecord.h>
#import "FeedModel.h"
#import "FeedParseOperation.h"

#define kFeedQueue dispatch_get_global_queue(0, 0)

@implementation FeedSourceUIEntity
@end
@implementation FeedItemUIEntity
@end


@interface FeedManager ()
@property (strong,nonatomic) NSOperationQueue *operationQueue;
@property (assign,nonatomic) NSUInteger feedTotalCount;
@property (assign,nonatomic) NSUInteger feedCounter;
@property (strong,nonatomic) NSRecursiveLock *feedCounterLock;
@end

@implementation FeedManager

+ (FeedManager *)manager{
    static FeedManager *o;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        o = [FeedManager new];
    });
    return o;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _operationQueue = [[NSOperationQueue alloc]init];
        _operationQueue.maxConcurrentOperationCount = 5;
        _feedCounterLock = [NSRecursiveLock new];
        _feedCounter = 0;
        _feedTotalCount = 0;
    }
    return self;
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

- (void)loadFeeds{
    if(_delegate)[_delegate feedManagerLoadStart];
    
    // Query
    [self _queryAllFeeds:^(NSMutableArray *feeds) {
        if(!feeds){
            [self _enumerateFeedsInCoreData];
            return;
        }
        
        // Persist
        dispatch_async(kFeedQueue, ^{
            [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
                for (RestLinkModel *feed in feeds) {
                    FeedModel *feedModel = [FeedModel MR_findFirstOrCreateByAttribute:@"oid" withValue:@(feed.oid) inContext:localContext];
                    feedModel.oid = @(feed.oid);
                    feedModel.feed_url = feed.feed_url;
                    feedModel.name = feed.name;
                    feedModel.url = feed.url;
                    feedModel.desc = feed.desc;
                    feedModel.updated_at = feed.updated_at;
                }
            }];
            
            [self _enumerateFeedsInCoreData];
        });
    }];
}

- (void)_enumerateFeedsInCoreData{
    dispatch_async(kFeedQueue, ^{
        NSArray<FeedModel*> *feeds = [FeedModel MR_findAllSortedBy:@"updated_at" ascending:NO];
        _feedTotalCount = feeds.count;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(_delegate)[_delegate feedManagerLoadProgress:0 totalCount:_feedTotalCount];
        });
        
        for (FeedModel *feed in feeds) {
            FeedParseOperation *operation = [[FeedParseOperation alloc]init];
            operation.feedURLString = feed.feed_url;
            
            __weak FeedParseOperation *_operation = operation;
            operation.completionBlock = ^{
                NSArray<MWFeedItem*>* feedItems = _operation.feedItems;
                
                for (MWFeedItem* feedItem in feedItems) {
                    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
                        FeedItemModel *itemModel = [FeedItemModel MR_findFirstOrCreateByAttribute:@"identifier" withValue:feedItem.identifier inContext:localContext];
                        itemModel.identifier = feedItem.identifier;
                        itemModel.title = feedItem.title;
                        itemModel.link = feedItem.link;
                        itemModel.updated = feedItem.updated;
                        itemModel.summary = feedItem.summary;
                        itemModel.content = feedItem.content;
                        itemModel.author = feedItem.author;
                        itemModel.feed_oid = feed.oid;
                        
                        if(!feedItem.date && !itemModel.date){
                            itemModel.date = [NSDate date];
                        }
                    }];
                }
                
                [_feedCounterLock lock];
                ++_feedCounter;
                [_feedCounterLock unlock];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(_delegate){
                        [_delegate feedManagerLoadProgress:_feedCounter totalCount:_feedTotalCount];
                        if(_feedCounter == _feedTotalCount) [_delegate feedManagerLoadFinish];
                    }
                });
            };
            
            [_operationQueue addOperation:operation];
        }
    });
}

- (void)fetchLocalFeeds:(NSUInteger)offset limit:(NSUInteger)limit completion:(void (^)(NSArray<FeedItemUIEntity *> *, NSUInteger, NSUInteger))completion{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        NSManagedObjectContext *context = [NSManagedObjectContext MR_contextForCurrentThread];
#pragma clang diagnostic pop
        NSFetchRequest *request = [FeedItemModel MR_requestAllSortedBy:@"date" ascending:NO inContext:context];
        [request setFetchOffset:offset];
        [request setFetchLimit:limit];

        NSArray<FeedItemModel*> *feedItems = [FeedItemModel MR_executeFetchRequest:request inContext:context];
        
        NSUInteger totalItemCount = [FeedItemModel MR_countOfEntitiesWithContext:context];
        NSUInteger totalFeedCount = [FeedModel MR_countOfEntitiesWithContext:context];
        
        NSMutableArray<FeedItemUIEntity*> *entities = [NSMutableArray new];
        for (FeedItemModel *item in feedItems) {
            FeedItemUIEntity *entity = [FeedItemUIEntity new];
            entity.identifier = item.identifier;
            entity.title = item.title;
            entity.link = item.link;
            entity.date = item.date;
            entity.updated = item.updated;
            entity.summary = item.summary;
            entity.content = item.content;
            entity.author = item.author;
            entity.feed_oid = item.feed_oid;
            
            [entities addObject:entity];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(entities, totalItemCount,totalFeedCount);
        });
    });
    
}

- (void)loadFeedSources:(void (^)(BOOL))completion{
    [self _queryAllFeeds:^(NSMutableArray<RestLinkModel *> *feeds) {
        if(!feeds){
            completion(NO);
            return;
        }
        
        // Persist
        dispatch_async(kFeedQueue, ^{
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
