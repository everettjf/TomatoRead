//
//  FeedParseTest.m
//  iOSBlogReader
//
//  Created by everettjf on 16/4/28.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface FeedImageParseTests : XCTestCase

@end

@implementation FeedImageParseTests

- (void)setUp{
    [super setUp];
    
}

- (void)tearDown{
    [super tearDown];
}


- (void)testParseImg{
    NSString *string = @"p><img src=\"https://everettjf.github.io/stuff/image/darkicon.PNG\" alt=\"\" /></p> "
    @"<p>下图是<code class=\"highlighter-rouge\">正常</code>的图标：</p>"
    @"<p><img src=\"https://everettjf.github.io/stuff/image/darkicon0.PNG\" alt=\"\" /></p> <";
    
//    NSString *string = @"<img src=image/ad1.gif width=\"128\" height=\"36\"/><img src='image/ad2.gif' width=\"128\" height=\"36\" />";
    
//    NSString *string = @"<img src='image/ad2.gif' width=\"128\" height=\"36\" />";
    
    NSError *error = nil;
    NSString *pattern = @"<img[\\s]+src[\\s]*=[\\s]*['\"]*([^ '\"]+)['\"]*";
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                                options:0
                                                                                  error:&error];
    NSTextCheckingResult *result = [expression firstMatchInString:string
                                                          options:0
                                                            range:NSMakeRange(0, string.length)];
    NSUInteger count = [result numberOfRanges];
    NSLog(@"count = %@",@(count));
    if(count >= 2){
        NSString *val = [string substringWithRange:[result rangeAtIndex:1]];
        NSLog(@"val = %@",val);
    }
//    for(NSUInteger idx = 0; idx < count; idx++){
//        NSString *val = [string substringWithRange:[result rangeAtIndex:idx]];
//        NSLog(@"val = %@",val);
//    }
}




@end