//
//  FeedSourceManager.h
//  iOSBlogReader
//
//  Created by everettjf on 16/4/24.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedSourceUIEntity : NSObject
@property (assign,nonatomic) NSUInteger oid;
@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *url;
@property (strong,nonatomic) NSString *feed_url;
@property (strong,nonatomic) NSString *favicon;
@property (strong,nonatomic) NSString *desc;
@property (strong,nonatomic) NSDate *updated_at;
@end

@interface FeedSourceManager : NSObject

+ (FeedSourceManager *)manager;

- (void)loadFeedSources:(void (^)(BOOL succeed))completion;
- (void)fetchFeedSources:(NSUInteger)offset limit:(NSUInteger)limit completion:(void(^)(NSArray<FeedSourceUIEntity*> *feedItems, NSUInteger totalCount))completion;
@end
