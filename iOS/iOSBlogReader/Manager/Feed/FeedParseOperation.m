//
//  FeedParseOperation.m
//  iOSBlogReader
//
//  Created by everettjf on 16/4/10.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#import "FeedParseOperation.h"

@interface FeedParseOperation ()<MWFeedParserDelegate>
@property (assign,nonatomic,getter=isFinished) BOOL finished;
@property (assign,nonatomic,getter=isExecuting) BOOL executing;

@property (strong,nonatomic) MWFeedParser *parser;
@property (strong,nonatomic) NSMutableArray<MWFeedItem*> *feedItemsForAppend;
@end

@implementation FeedParseOperation

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

- (void)start{
    if(!_feedURLString || [_feedURLString isEqualToString:@""]){
        self.finished = YES;
        return;
    }
    
    if(self.isCancelled){
        self.finished = YES;
        return;
    }
    
    self.executing = YES;
    
    _feedItemsForAppend = [NSMutableArray new];
    
    _parser = [[MWFeedParser alloc]initWithFeedURL:[NSURL URLWithString:self.feedURLString]];
    _parser.delegate = self;
    if(![_parser parse]){
        NSLog(@"run parse failed");
        self.finished = YES;
        return;
    }
}

- (void)cancel{
    [_parser stopParsing];
    [super cancel];
}

- (void)feedParserDidStart:(MWFeedParser *)parser{
    NSLog(@"parse start : %@", _feedURLString);
}
- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info{
    NSLog(@"feed info : %@, %@, %@", info.title, info.link, info.url);
    
    _feedInfo = info;
}
- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item{
    NSLog(@"feed item : %@\n"
          @"            %@\n"
          @"            %@\n"
          @"            %@\n",
          item.identifier,
          item.title,
          item.link,
          item.date
          );
    
    [_feedItemsForAppend addObject:item];
}
- (void)feedParserDidFinish:(MWFeedParser *)parser{
    NSLog(@"feed finish : %@", _feedURLString);
    self.finished = YES;
    _feedItems = _feedItemsForAppend;
    _feedItemsForAppend = nil;
}
- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error{
    NSLog(@"feed error : %@", error);
    self.finished = YES;
    _feedItems = _feedItemsForAppend;
    _feedItemsForAppend = nil;
}

@end
