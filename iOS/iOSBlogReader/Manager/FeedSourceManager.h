//
//  FeedSourceManager.h
//  iOSBlogReader
//
//  Created by everettjf on 16/4/24.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestLinkListModel.h"

@interface FeedSourceUIEntity : NSObject
@property (strong,nonatomic) RestLinkModel *link;
@property (strong,nonatomic) NSDate *latest_post_date;
@property (assign,nonatomic) NSUInteger post_count;
@end

@interface FeedSourceManager : NSObject

+ (FeedSourceManager *)manager;

- (void)requestFeedSources:(void (^)(BOOL succeed))completion;
- (void)queryFeedSources:(NSUInteger)offset limit:(NSUInteger)limit completion:(void(^)(NSArray<FeedSourceUIEntity*> *feedItems, NSUInteger totalCount))completion;
@end
