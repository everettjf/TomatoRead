//
//  FeedPostTableViewCell.h
//  iOSBlogReader
//
//  Created by everettjf on 16/4/30.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedPostTableViewCell : UITableViewCell

@property (strong,nonatomic) NSString *title;
@property (strong,nonatomic) NSDate *date;
@property (strong,nonatomic) NSString *author;
@end
