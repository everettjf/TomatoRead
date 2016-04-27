//
//  FeedImageParser.m
//  iOSBlogReader
//
//  Created by everettjf on 16/4/27.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#import "FeedImageParser.h"

@implementation FeedImageParser{
    NSRegularExpression *_expression;
}

+ (FeedImageParser *)parser{
    static FeedImageParser *o;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        o = [FeedImageParser new];
    });
    return o;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSError *error = nil;
        NSString *pattern = @"<img[\\s]+src[\\s]*=[\\s]*['\"]*([^ '\"]+)['\"]*";
        _expression = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                options:0
                                                                  error:&error];
    }
    return self;
}

- (NSString *)parseFirstImage:(NSString *)htmlContent baseUri:(NSString *)baseUri{
    if(!_expression)return @"";
    
    NSTextCheckingResult *result = [_expression firstMatchInString:htmlContent
                                                           options:0
                                                             range:NSMakeRange(0, htmlContent.length)];
    NSUInteger count = [result numberOfRanges];
    if(count < 2)return @"";
    
    NSString *val = [htmlContent substringWithRange:[result rangeAtIndex:1]];
    if(!val) return @"";
    
    return val;
}

@end
