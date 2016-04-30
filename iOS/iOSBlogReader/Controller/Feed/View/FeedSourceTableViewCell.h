//
//  FeedSourceTableViewCell.h
//  iOSBlogReader
//
//  Created by everettjf on 16/4/19.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedSourceTableViewCell : UITableViewCell
@property (strong,nonatomic) NSString *favicon;
@property (strong,nonatomic) NSString *title;
@property (strong,nonatomic) NSString *subTitle;

@end
