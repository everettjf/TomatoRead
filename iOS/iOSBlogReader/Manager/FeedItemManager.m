//
//  FeedManager.m
//  iOSBlogReader
//
//  Created by everettjf on 16/4/10.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#import "FeedItemManager.h"
#import "RestApi.h"
#import "DataManager.h"
#import "FeedModel.h"
#import "FeedParseOperation.h"
#import "FeedItemModel.h"
#import "FeedSourceManager.h"
#import "DataManager.h"
#import "FeedImageParser.h"
#import "SpiderParseOperation.h"

@implementation FeedItemUIEntity
@end


@interface FeedItemManager ()
@property (strong,nonatomic) NSOperationQueue *operationQueue;
@property (assign,nonatomic) NSUInteger feedTotalCount;
@property (assign,nonatomic) NSUInteger feedCounter;
@property (strong,nonatomic) NSRecursiveLock *feedCounterLock;
@end

@implementation FeedItemManager

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
    
    if(_delegate){
        dispatch_async(dispatch_get_main_queue(), ^{
            [_delegate feedManagerLoadStart];
        });
    }
}

- (void)_onErrorLoadFeeds{
    _loadingFeeds = YES;
    
    if(_delegate){
        dispatch_async(dispatch_get_main_queue(), ^{
            [_delegate feedManagerLoadError];
        });
    }
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
    
    if(_delegate){
        dispatch_async(dispatch_get_main_queue(), ^{
            [_delegate feedManagerLoadFinish];
        });
    }
}

- (void)bindOne:(FeedSourceUIEntity *)feed{
    _bindedOneFeed = feed;
}

- (void)loadFeeds{
    if(_loadingFeeds)return;
    [self _onStartLoadFeeds];
    
    if(_bindedOneFeed){
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            FeedModel *model = [[DataManager manager]findFeed:_bindedOneFeed.link.oid];
            if(!model){
                [self _onErrorLoadFeeds];
                return;
            }
            
            [self _enumerateFeedsInCoreData:@[model]];
        });
    }else{
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [[FeedSourceManager manager]requestFeedSources:^(BOOL succeed) {
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    NSArray<FeedModel*> *feeds = [FeedModel mcd_findAll:@{
                                                                          @"latest_post_date" : @NO,
                                                                          @"zindex": @NO
                                                                          }];
                    if(!feeds || feeds.count == 0){
                        [self _onErrorLoadFeeds];
                        return;
                    }
                    
                    [self _enumerateFeedsInCoreData:feeds];
                });
            }];
        });
    }
}

- (NSString*)_computeFirstImage:(FeedModel*)feedInfo feedItem:(ParseFeedItem*)feedItem{
    NSString *baseUri = feedInfo.url;
    // todo
//    if(!baseUri)baseUri = [feedInfo.url URLByDeletingLastPathComponent].absoluteString;
    
    return [[FeedImageParser parser]parseFirstImage:feedItem.content baseUri:baseUri];
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
            ParseOperationBase *operation;
            if(feed.feed_url && ![feed.feed_url isEqualToString:@""]){
                operation = [[FeedParseOperation alloc]init];
            }else if(feed.spider && ![feed.spider isEqualToString:@""]){
                operation = [[SpiderParseOperation alloc]init];
            }else{
                [self _increaseFeedCounter];
                continue;
            }
            
            operation.feed = feed;
            operation.onParseFinished = ^(FeedModel* feedInfo,NSArray<ParseFeedItem*> *feedItems){
                
                __block NSDate *latest_post_date;
                for (ParseFeedItem* feedItem in feedItems) {
                    
                    NSString *firstImage = feedItem.image;
                    if(!firstImage) firstImage = [self _computeFirstImage:feedInfo feedItem:feedItem];
                    
                    [[DataManager manager]findOrCreateFeedItem:feedItem.identifier callback:^(FeedItemModel *m) {
                        m.type = @(feedItem.type);
                        m.title = feedItem.title;
                        m.link = feedItem.link;
                        m.content = feedItem.content;
                        m.image = firstImage;
                        
                        m.feed = feed;
                        
                        if(!feedItem.date && !m.date){
                            m.date = [NSDate date];
                        }else{
                            m.date = feedItem.date;
                        }
                        
                        if(!latest_post_date){
                            latest_post_date = m.date;
                        }else{
                            if([m.date timeIntervalSinceDate:latest_post_date]> 0){
                                latest_post_date = m.date;
                            }
                        }
                    }];
                }
                
                [FeedModel mcd_update:@"oid" value:feed.oid callback:^(NSManagedObject *m) {
                    FeedModel *model = (id)m;
                    model.latest_post_date = latest_post_date;
                    model.last_parse_date = [NSDate date];
                }];
                
                [self _increaseFeedCounter];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(_delegate){
                        NSUInteger counter = [self feedCounter];
                        [_delegate feedManagerLoadProgress:counter totalCount:_feedTotalCount];
                    }
                });
            };
            
            [endOperation addDependency:operation];
            [_operationQueue addOperation:operation];
        }
        
        [_operationQueue addOperation:endOperation];
    });
}

- (void)fetchItems:(NSUInteger)offset limit:(NSUInteger)limit completion:(void (^)(NSArray<FeedItemUIEntity *> *, NSUInteger))completion{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSNumber *filterFeedOid;
        if(_bindedOneFeed){
            filterFeedOid = @(_bindedOneFeed.link.oid);
        }
        
        NSArray<FeedItemModel*> *feedItems = [[DataManager manager]findAllFeedItem:offset limit:limit filter:filterFeedOid];
        
        NSUInteger totalItemCount = [[DataManager manager]countFeedItem:filterFeedOid];
        
        NSMutableArray<FeedItemUIEntity*> *entities = [NSMutableArray new];
        for (FeedItemModel *item in feedItems) {
            FeedItemUIEntity *entity = [FeedItemUIEntity new];
            entity.identifier = item.identifier;
            entity.type = (ParseItemType)item.type.unsignedIntegerValue;
            entity.title = item.title;
            entity.link = item.link;
            entity.date = item.date;
            entity.content = item.content;
            entity.feed_oid = item.feed.oid;
            entity.image = item.image;
            entity.feed_name = item.feed.name;
            
            [entities addObject:entity];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(entities, totalItemCount);
        });
    });
    
}


@end
