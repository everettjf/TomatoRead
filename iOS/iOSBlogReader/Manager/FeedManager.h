//
//  FeedManager.h
//  iOSBlogReader
//
//  Created by everettjf on 16/4/10.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedItemModel.h"


@protocol FeedManagerDelegate <NSObject>
- (void)feedManagerDidLoadFeeds:(NSArray<FeedItemModel*>*)feeds;
@end

@interface FeedManager : NSObject
@property (weak,nonatomic) id<FeedManagerDelegate> delegate;

+ (FeedManager*)manager;
- (void)loadFeeds;

@end
