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


@interface FeedManager ()
@property (strong,nonatomic) NSOperationQueue *operationQueue;
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
    }
    return self;
}

- (void)_queryAllFeeds:(void (^)(NSMutableArray *feeds))completion{
    NSMutableArray *feeds = [NSMutableArray new];
    [self _queryAllFeeds:completion next:nil feeds:feeds];
    
}
- (void)_queryAllFeeds:(void (^)(NSMutableArray *feeds))completion next:(NSString*)next feeds:(NSMutableArray*)feeds{
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
    // Query
    [self _queryAllFeeds:^(NSMutableArray *feeds) {
        if(!feeds){
            [self _enumerateFeedsInCoreData];
            return;
        }
        NSLog(@"total feeds : %@",@(feeds.count));
        
        // Persist
        dispatch_async(kFeedQueue, ^{
            [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
                for (RestLinkModel *feed in feeds) {
                    FeedModel *feedModel = [FeedModel MR_findFirstOrCreateByAttribute:@"oid" withValue:@(feed.oid) inContext:localContext];
                    feedModel.oid = @(feed.oid);
                    feedModel.url = feed.feed_url;
                    feedModel.title = feed.name;
                    feedModel.link = feed.url;
                    feedModel.summary = @"";
                    feedModel.updated_at = feed.updated_at;
                }
            } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
                NSLog(@"context did save = %@ , error = %@", @(contextDidSave), error);
                
                [self _enumerateFeedsInCoreData];
            }];
            
        });
    }];
}

- (void)_enumerateFeedsInCoreData{
    dispatch_async(kFeedQueue, ^{
        NSArray<FeedModel*> *feeds = [FeedModel MR_findAllSortedBy:@"updated_at" ascending:NO];
        
        NSLog(@"feed count in coredata = %@", @(feeds.count));
        
        for (FeedModel *feed in feeds) {
            FeedParseOperation *operation = [[FeedParseOperation alloc]init];
            operation.feedURLString = feed.url;
            
            __weak FeedParseOperation *_operation = operation;
            operation.completionBlock = ^{
                NSArray<MWFeedItem*>* feedItems = _operation.feedItems;
                
                for (MWFeedItem* feedItem in feedItems) {
                    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull localContext) {
                        FeedItemModel *itemModel = [FeedItemModel MR_findFirstOrCreateByAttribute:@"identifier" withValue:feedItem.identifier inContext:localContext];
                        itemModel.identifier = feedItem.identifier;
                        itemModel.title = feedItem.title;
                        itemModel.link = feedItem.link;
                        itemModel.date = feedItem.date;
                        itemModel.updated = feedItem.updated;
                        itemModel.summary = feedItem.summary;
                        itemModel.content = feedItem.content;
                        itemModel.author = feedItem.author;
                        itemModel.feed_oid = feed.oid;
                    }];
                }
                
                [self _fetchFeedItemsInCoreData];
            };
            
            [_operationQueue addOperation:operation];
        }
    });
}

- (void)_fetchFeedItemsInCoreData{
    dispatch_async(kFeedQueue, ^{
        NSArray<FeedItemModel*> *feeds = [FeedItemModel MR_findAllSortedBy:@"date" ascending:NO];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(_delegate)[_delegate feedManagerDidLoadFeeds:feeds];
        });
    });
}

@end
