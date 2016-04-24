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
#import "FeedItemModel.h"
#import "FeedSourceManager.h"

#define kFeedQueue dispatch_get_global_queue(0, 0)

@implementation FeedItemUIEntity
@end


@interface FeedManager ()
@property (strong,nonatomic) NSOperationQueue *operationQueue;
@property (assign,nonatomic) NSUInteger feedTotalCount;
@property (assign,nonatomic) NSUInteger feedCounter;
@property (strong,nonatomic) NSRecursiveLock *feedCounterLock;
@end

@implementation FeedManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _operationQueue = [[NSOperationQueue alloc]init];
        _operationQueue.maxConcurrentOperationCount = 1;
        _feedCounterLock = [NSRecursiveLock new];
        _feedCounter = 0;
        _feedTotalCount = 0;
    }
    return self;
}

- (void)_onStartLoadFeeds{
    _loadingFeeds = YES;
    
    if(_delegate)[_delegate feedManagerLoadStart];
}

- (void)_onStopLoadFeeds{
    _loadingFeeds = NO;
    
    if(_delegate)[_delegate feedManagerLoadFinish];
}

- (void)bindOne:(FeedSourceUIEntity *)feed{
    _bindedOneFeed = feed;
}

- (void)loadFeeds{
    if(_loadingFeeds)return;
    [self _onStartLoadFeeds];
    
    if(_bindedOneFeed){
        FeedModel *model = [FeedModel MR_findFirstByAttribute:@"oid" withValue:@(_bindedOneFeed.oid)];
        if(!model)return;
        
        [self _enumerateFeedsInCoreData:@[model]];
    }else{
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [[FeedSourceManager manager]loadFeedSources:^(BOOL succeed) {
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    NSArray<FeedModel*> *feeds = [FeedModel MR_findAll];
                    if(!feeds)return;
                    
                    [self _enumerateFeedsInCoreData:feeds];
                });
            }];
        });
    }
}

- (void)_enumerateFeedsInCoreData:(NSArray<FeedModel*> *)feeds{
    dispatch_async(kFeedQueue, ^{
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
                        itemModel.summary = feedItem.summary;
                        itemModel.content = feedItem.content;
                        itemModel.author = feedItem.author;
                        itemModel.updated = feedItem.updated;
                        itemModel.feed_oid = feed.oid;
                        
                        if(!feedItem.date && !itemModel.date){
                            itemModel.date = [NSDate date];
                        }else{
                            itemModel.date = feedItem.date;
                        }
                    }];
                }
                
                [_feedCounterLock lock];
                ++_feedCounter;
                [_feedCounterLock unlock];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(_delegate){
                        [_delegate feedManagerLoadProgress:_feedCounter totalCount:_feedTotalCount];
                        
                        if(_feedCounter == _feedTotalCount) {
                            [self _onStopLoadFeeds];
                        }
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
        
        if(_bindedOneFeed){
            request.predicate = [NSPredicate predicateWithFormat:@"%K = %@", @"feed_oid", @(_bindedOneFeed.oid)];
        }

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


@end
