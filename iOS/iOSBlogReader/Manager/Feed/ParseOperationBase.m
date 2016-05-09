//
//  ParseOperationBase.m
//  iOSBlogReader
//
//  Created by everettjf on 16/5/9.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#import "ParseOperationBase.h"

@implementation ParseFeedItem
@end

@interface ParseOperationBase ()

@end

@implementation ParseOperationBase


@synthesize finished = _finished;
@synthesize executing = _executing;

- (void)setFinished:(BOOL)finished{
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)setExecuting:(BOOL)executing{
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (BOOL)isAsynchronous{
    return YES;
}

@end
