//
//  SpiderParseOperation.m
//  iOSBlogReader
//
//  Created by everettjf on 16/5/9.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#import "SpiderParseOperation.h"
#import "RestApi.h"

@implementation SpiderParseOperation

- (void)start{
    if(self.isCancelled){
        self.finished = YES;
        return;
    }
    
    self.executing = YES;
    
    [[RestApi api] querySpiderPostList:self.feed.spider
                                feedID:self.feed.oid.unsignedIntegerValue
                              complete:^(RestSpiderPostListModel *model, NSError *error) {
                                  if(error){
                                      self.finished = YES;
                                      return;
                                  }
                                  
                                  NSMutableArray<ParseFeedItem*>* items = [NSMutableArray new];
                                  for (RestSpiderPostModel *post in model.posts) {
                                      ParseFeedItem *feedItem = [ParseFeedItem new];
                                      feedItem.identifier = post.link;
                                      feedItem.type = ParseItemType_Link;
                                      
                                      feedItem.title = post.title;
                                      feedItem.link = post.link;
                                      feedItem.date = post.createtime;
                                      feedItem.image = post.image;
                                      
                                      [items addObject:feedItem];
                                  }
                                  
                                  self.onParseFinished(self.feed,items);
                                  self.finished = YES;
                              }];
}

- (void)cancel{
    [super cancel];
}

@end
