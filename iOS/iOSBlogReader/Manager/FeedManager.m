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
#import "FeedImageParser.h"

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
    }
    return self;
}

- (void)_onStartLoadFeeds{
    _loadingFeeds = YES;
    _feedCounter = 0;
    _feedTotalCount = 0;
    
    if(_delegate)[_delegate feedManagerLoadStart];
}

- (void)_increaseFeedCounter{
    [_feedCounterLock lock];
    ++_feedCounter;
    [_feedCounterLock unlock];
}

- (NSUInteger)_currentFeedCounter{
    NSUInteger c;
    [_feedCounterLock lock];
    c = _feedCounter;
    [_feedCounterLock unlock];
    return c;
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

- (NSString*)_computeFirstImage:(MWFeedInfo*)feedInfo feedItem:(MWFeedItem*)feedItem{
    NSString *baseUri = feedInfo.link;
    if(!baseUri)baseUri = [feedInfo.url URLByDeletingLastPathComponent].absoluteString;
    
    NSString *htmlContent = feedItem.content;
    if(!htmlContent) htmlContent = feedItem.summary;
    
    return [[FeedImageParser parser]parseFirstImage:htmlContent baseUri:baseUri];
}

- (void)_enumerateFeedsInCoreData:(NSArray<FeedModel*> *)feeds{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        _feedTotalCount = feeds.count;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(_delegate)[_delegate feedManagerLoadProgress:0 totalCount:_feedTotalCount];
        });
        
        NSOperation *endOperation = [[NSOperation alloc]init];
        endOperation.completionBlock = ^{
            [self _onStopLoadFeeds];
        };
        
        for (FeedModel *feed in feeds) {
            FeedParseOperation *operation = [[FeedParseOperation alloc]init];
            operation.feedURLString = feed.feed_url;
            
            operation.onParseFinished = ^(MWFeedInfo*feedInfo,NSArray<MWFeedItem*> *feedItems){
                
                for (MWFeedItem* feedItem in feedItems) {
                    NSString *firstImage = [self _computeFirstImage:feedInfo feedItem:feedItem];
                    
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
                        itemModel.image = firstImage;
                        
                        if(!feedItem.date && !itemModel.date){
                            itemModel.date = [NSDate date];
                        }else{
                            itemModel.date = feedItem.date;
                        }
                    }];
                }
                
                [self _increaseFeedCounter];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(_delegate){
                        NSUInteger counter = [self feedCounter];
                        [_delegate feedManagerLoadProgress:counter totalCount:_feedTotalCount];
                    }
                });
            };
            
            [endOperation addDependency:endOperation];
            [_operationQueue addOperation:operation];
        }
        
        [_operationQueue addOperation:endOperation];
    });
}

- (void)fetchLocalFeeds:(NSUInteger)offset limit:(NSUInteger)limit completion:(void (^)(NSArray<FeedItemUIEntity *> *, NSUInteger))completion{
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
        
        NSPredicate *predicate;
        if(_bindedOneFeed){
            predicate = [NSPredicate predicateWithFormat:@"%K = %@", @"feed_oid", @(_bindedOneFeed.oid)];
        }
        NSUInteger totalItemCount = [FeedItemModel MR_countOfEntitiesWithPredicate:predicate inContext:context];
        
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
            entity.image = item.image;
            
            [entities addObject:entity];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(entities, totalItemCount);
        });
    });
    
}


@end
