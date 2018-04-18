//
//  ParseOperationBase.h
//  iOSBlogReader
//
//  Created by everettjf on 16/5/9.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedModel.h"

typedef NS_OPTIONS(NSUInteger, ParseItemType) {
    ParseItemType_Feed = 0,
    ParseItemType_Link = 1,
};

@interface ParseFeedItem : NSObject
@property (assign,nonatomic) ParseItemType type;
@property (strong,nonatomic) NSString *identifier; // Item identifier
@property (strong,nonatomic) NSString *title; // Item title
@property (strong,nonatomic) NSString *link; // Item URL
@property (strong,nonatomic) NSDate *date; // Date the item was published
@property (strong,nonatomic) NSString *content; // Can be empty
@property (strong,nonatomic) NSString *image; // Can be empty
@end

@interface ParseOperationBase : NSOperation
@property (assign,nonatomic,getter=isFinished) BOOL finished;
@property (assign,nonatomic,getter=isExecuting) BOOL executing;

@property (strong,nonatomic) FeedModel *feed;
@property (copy,nonatomic) void(^onParseFinished)(FeedModel* feedModel,NSArray<ParseFeedItem*> *feedItems);

@end
