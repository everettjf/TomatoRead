//
//  FeedPostTableViewCell.m
//  iOSBlogReader
//
//  Created by everettjf on 16/4/30.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#import "FeedPostTableViewCell.h"
#import "FeedItemManager.h"
#import "AppUtil.h"
#import <YYWebImage.h>

@interface FeedPostTableViewCell ()
{
    UILabel *_titleLabel;
    UILabel *_dateLabel;
    UILabel *_authorLabel;
}

@end

@implementation FeedPostTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self _setupView];
    }
    return self;
}

- (void)_setupView{
    UIView *root = self.contentView;
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont systemFontOfSize:18];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.numberOfLines = 2;
    [root addSubview:_titleLabel];
    
    _dateLabel = [UILabel new];
    _dateLabel.font = [UIFont systemFontOfSize:14];
    _dateLabel.textColor = UIColorGraySubTitle;
    [root addSubview:_dateLabel];
    
    _authorLabel = [UILabel new];
    _authorLabel.font = [UIFont systemFontOfSize:14];
    _authorLabel.textColor = UIColorGraySubTitle;
    [root addSubview:_authorLabel];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(root).offset(38/2);
        make.top.equalTo(root).offset(34/2);
        make.right.equalTo(root).offset(-38/2);
    }];
    
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(_titleLabel);
        make.top.equalTo(_titleLabel.mas_bottom).offset(8);
    }];
    
    [_authorLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(_dateLabel.mas_right).offset(8);
        make.right.lessThanOrEqualTo(root).offset(-38/2);
        make.centerY.equalTo(_dateLabel.mas_centerY);
    }];
}

- (void)prepareForReuse{
    [super prepareForReuse];
}

- (void)setTitle:(NSString *)title{
    _titleLabel.text = title?title:@"";
}

- (void)setDate:(NSDate *)date{
    _dateLabel.text = [[AppUtil util] formatDate:date];
}

- (void)setAuthor:(NSString *)author{
    _authorLabel.text = author;
}

@end
