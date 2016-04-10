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

- (void)loadFeeds{
    // Query
    [[RestApi api]queryFeedList:^(RestLinkListModel *model, NSError *error) {
        if(error){
            [self _enumerateFeedsInCoreData];
            return;
        }
        
        // Persist
        dispatch_async(kFeedQueue, ^{
            [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
                for (RestLinkModel *link in model.results) {
                    FeedModel *feed = [FeedModel MR_findFirstOrCreateByAttribute:@"oid" withValue:@(link.oid) inContext:localContext];
                    feed.oid = @(link.oid);
                    feed.url = link.feed_url;
                    feed.title = link.name;
                    feed.link = link.url;
                    feed.summary = @"";
                    feed.updated_at = link.updated_at;
                }
            } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
                NSLog(@"context did save = %@ , error = %@", @(contextDidSave), error);
                
                [self _enumerateFeedsInCoreData];
            }];
            
        });
    } url:nil];
}

- (void)_enumerateFeedsInCoreData{
    dispatch_async(kFeedQueue, ^{
        NSArray<FeedModel*> *feeds = [FeedModel MR_findAllSortedBy:@"updated_at" ascending:NO];
        
        NSLog(@"feed count = %@", @(feeds.count));
        
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
