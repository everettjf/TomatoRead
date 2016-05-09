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
    if(!htmlContent)return @"";
    
    NSArray<NSTextCheckingResult*> *results = [_expression matchesInString:htmlContent
                                                        options:0
                                                          range:NSMakeRange(0, htmlContent.length)];
    if(results.count == 0)
        return @"";
    
    // jpg ,gif , png
    NSString *imageURL;
    for (NSTextCheckingResult *result in results) {
        NSUInteger count = [result numberOfRanges];
        if(count < 2)
            continue;
        
        NSString *src = [htmlContent substringWithRange:[result rangeAtIndex:1]];
        if(!src)
            continue;
        if(src.length < 4)
            continue;
        NSString *ext = [[src pathExtension] lowercaseString];
        if(!ext)
            continue;
        if([ext isEqualToString:@""])
            continue;
        
        if([ext isEqualToString:@"jpg"]
           || [ext isEqualToString:@"png"]
           || [ext isEqualToString:@"gif"] ){
            imageURL = src;
            break;
        }
    }
    
    NSRange httpRange = [imageURL rangeOfString:@"http://"];
    NSRange httpsRange = [imageURL rangeOfString:@"https://"];
    if(httpRange.location == NSNotFound && httpsRange.location == NSNotFound){
        // add prefix
        if(baseUri.length > 0 && [baseUri characterAtIndex:baseUri.length - 1] == '/'){
            baseUri = [baseUri substringToIndex:baseUri.length - 1];
        }
        if(imageURL.length > 0 && [imageURL characterAtIndex:0] == '/'){
            imageURL = [imageURL substringWithRange:NSMakeRange(1, imageURL.length - 1)];
        }
        
        imageURL = [NSString stringWithFormat:@"%@/%@",baseUri,imageURL];
    }
    
    return imageURL;
}

@end
