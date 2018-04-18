//
//  FeedImageParser.h
//  iOSBlogReader
//
//  Created by everettjf on 16/4/27.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedImageParser : NSObject

+ (FeedImageParser*)parser;

- (NSString*)parseFirstImage:(NSString*)htmlContent baseUri:(NSString*)baseUri;

@end
