//
//  FeedPostContentViewController.h
//  iOSBlogReader
//
//  Created by everettjf on 16/4/24.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedManager.h"

@interface FeedPostContentViewController : UIViewController

- (instancetype)initWithFeedPost:(FeedItemUIEntity*)post;

@end
