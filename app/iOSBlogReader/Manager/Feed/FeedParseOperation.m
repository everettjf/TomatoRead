//
//  FeedParseOperation.m
//  iOSBlogReader
//
//  Created by everettjf on 16/4/10.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#import "FeedParseOperation.h"
#import "MWFeedParser.h"

@interface FeedParseOperation ()<MWFeedParserDelegate>

@property (strong,nonatomic) MWFeedParser *parser;
@property (strong,nonatomic) NSMutableArray<ParseFeedItem*> *feedItemsForAppend;
@property (strong,nonatomic) MWFeedInfo *feedInfo;

@end

@implementation FeedParseOperation

- (void)start{
    if(!self.feed || [self.feed.feed_url isEqualToString:@""]){
        self.finished = YES;
        return;
    }
    
    if(self.isCancelled){
        self.finished = YES;
        return;
    }
    
    self.executing = YES;
    
    _parser = [[MWFeedParser alloc]initWithFeedURL:[NSURL URLWithString:self.feed.feed_url]];
    _parser.delegate = self;
    if(![_parser parse]){
        NSLog(@"run parse failed : %@", self.feed.feed_url);
        self.finished = YES;
        return;
    }
}

- (void)cancel{
    [_parser stopParsing];
    [super cancel];
}

- (void)feedParserDidStart:(MWFeedParser *)parser{
    _feedItemsForAppend = [NSMutableArray new];
}
- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info{
    _feedInfo = info;
}
- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item{
    ParseFeedItem *feedItem = [ParseFeedItem new];
    feedItem.type = ParseItemType_Feed;
    feedItem.identifier = item.identifier;
    feedItem.title = item.title;
    feedItem.link = item.link;
    feedItem.date = item.date;
    
    feedItem.content = item.content;
    if(!feedItem.content)feedItem.content = item.summary;
    
    if(!feedItem.link) feedItem.link = feedItem.identifier;
    
    [_feedItemsForAppend addObject:feedItem];
}
- (void)feedParserDidFinish:(MWFeedParser *)parser{
    self.onParseFinished(self.feed,_feedItemsForAppend);
    self.finished = YES;
}
- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error{
    self.onParseFinished(self.feed,_feedItemsForAppend);
    self.finished = YES;
}

@end
