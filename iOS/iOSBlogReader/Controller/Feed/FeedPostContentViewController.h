//
//  FeedPostContentViewController.h
//  iOSBlogReader
//
//  Created by everettjf on 16/4/24.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedItemManager.h"
#import "EEViewController.h"

@interface FeedPostContentViewController : EEViewController

- (instancetype)initWithFeedPost:(FeedItemUIEntity*)post;

@end
