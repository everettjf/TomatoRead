//
//  FeedManager.h
//  iOSBlogReader
//
//  Created by everettjf on 16/4/10.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedItemModel.h"
#import "FeedModel.h"

@interface FeedSourceUIEntity : NSObject
@property (assign,nonatomic) NSUInteger oid;
@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *url;
@property (strong,nonatomic) NSString *feed_url;
@property (strong,nonatomic) NSString *favicon;
@property (strong,nonatomic) NSString *desc;
@property (strong,nonatomic) NSDate *updated_at;
@end

@interface FeedItemUIEntity : NSObject
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSDate *updated;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSNumber *feed_oid;
@end


@protocol FeedManagerDelegate <NSObject>
- (void)feedManagerLoadStart;
- (void)feedManagerLoadProgress:(NSUInteger)loadCount totalCount:(NSUInteger)totalCount;
- (void)feedManagerLoadFinish;
@end

@interface FeedManager : NSObject

+ (FeedManager*)manager;

@property (weak,nonatomic) id<FeedManagerDelegate> delegate;
- (void)loadFeeds;
- (void)fetchLocalFeeds:(NSUInteger)offset limit:(NSUInteger)limit completion:(void(^)(NSArray<FeedItemUIEntity*> *feedItems, NSUInteger totalItemCount, NSUInteger totalFeedCount))completion;


- (void)loadFeedSources:(void (^)(BOOL succeed))completion;
- (void)fetchFeedSources:(NSUInteger)offset limit:(NSUInteger)limit completion:(void(^)(NSArray<FeedSourceUIEntity*> *feedItems, NSUInteger totalCount))completion;

- (NSString*)formatDate:(NSDate*)date;
@end
