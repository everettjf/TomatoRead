//
//  FeedViewController.h
//  iOSBlogReader
//
//  Created by everettjf on 16/4/6.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedSourceManager.h"
#import "EEViewController.h"

typedef NS_OPTIONS(NSUInteger, FeedPostsViewControllerMode) {
    FeedPostsViewControllerModeAll = 0,
    FeedPostsViewControllerModeOne = 1,
};

@interface FeedPostsViewController : EEViewController

@property (assign,nonatomic,readonly) FeedPostsViewControllerMode mode;

- (instancetype)init;
- (instancetype)initWithOne:(FeedSourceUIEntity*)feed;

@end
