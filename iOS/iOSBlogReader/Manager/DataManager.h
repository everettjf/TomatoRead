//
//  DataStorage.h
//  iOSBlogReader
//
//  Created by everettjf on 16/4/9.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedModel.h"
#import "FeedItemModel.h"
#import "DomainModel.h"
#import "AspectModel.h"
#import "NSManagedObject+MatrixCoreData.h"

NS_ASSUME_NONNULL_BEGIN

@interface DataManager : NSObject

@property (strong) NSManagedObjectContext *managedObjectContext;
+ (DataManager*)manager;

// Feed
- (FeedModel*)findFeed:(NSUInteger)oid;
- (void)findOrCreateFeed:(NSUInteger)oid callback:(void(^)( FeedModel * _Nullable m))callback;
- (NSArray<FeedModel*>*)findAllFeed;
- (NSArray<FeedModel*>*)findAllFeed:(NSUInteger)offset limit:(NSUInteger)limit;
- (NSUInteger)countFeed;
- (void)rebuildFeeds:(NSSet<NSNumber*>*)oidset;

- (NSString*)getFeedVersion;
- (void)saveFeedVersion:(NSString*)version;

// FeedItem
- (void)findOrCreateFeedItem:(NSString*)identifier callback:(void(^)(FeedItemModel* _Nullable m))callback;
- (FeedItemModel*)findFeedItem:(NSString*)identifier;
- (NSArray<FeedItemModel*>*)findAllFeedItem:(NSUInteger)offset limit:(NSUInteger)limit filter:(nullable NSNumber*)filterFeedOid;
- (NSUInteger)countFeedItem:(nullable NSNumber*)filterFeedOid;



@end

NS_ASSUME_NONNULL_END