//
//  FeedManager.h
//  iOSBlogReader
//
//  Created by everettjf on 16/4/10.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedModel.h"
#import "FeedSourceManager.h"


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

@property (assign,nonatomic) BOOL loadingFeeds;
@property (weak,nonatomic) id<FeedManagerDelegate> delegate;
@property (strong,nonatomic,readonly) FeedSourceUIEntity *bindedOneFeed;

- (void)bindOne:(FeedSourceUIEntity*)feed;
- (void)loadFeeds;

- (void)fetchLocalFeeds:(NSUInteger)offset limit:(NSUInteger)limit completion:(void(^)(NSArray<FeedItemUIEntity*> *feedItems, NSUInteger totalItemCount))completion;


@end
