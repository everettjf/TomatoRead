//
//  FeedTableViewCell.h
//  iOSBlogReader
//
//  Created by everettjf on 16/4/11.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedPostOneImageTableViewCell : UITableViewCell

@property (strong,nonatomic) NSString *title;
@property (strong,nonatomic) NSDate *date;
@property (strong,nonatomic) NSString *author;
@property (strong,nonatomic) NSString *imageURL;

@end
