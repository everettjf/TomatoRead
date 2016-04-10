//
//  FeedParseOperation.h
//  iOSBlogReader
//
//  Created by everettjf on 16/4/10.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MWFeedParser.h>

@interface FeedParseOperation : NSOperation
@property (strong,nonatomic) NSString *feedURLString;

@property (strong,nonatomic) MWFeedInfo *feedInfo;
@property (strong,nonatomic,readonly) NSArray<MWFeedItem*> *feedItems;
@end
