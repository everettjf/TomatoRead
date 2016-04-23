//
//  FeedTableViewCell.m
//  iOSBlogReader
//
//  Created by everettjf on 16/4/11.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#import "FeedPostTableViewCell.h"
#import "FeedManager.h"
#import "AppUtil.h"


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
        [self _setupView];
    }
    return self;
}

- (void)_setupView{
    UIView *root = self.contentView;
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.numberOfLines = 1;
    [root addSubview:_titleLabel];
    
    _dateLabel = [UILabel new];
    _dateLabel.font = [UIFont systemFontOfSize:11];
    [root addSubview:_dateLabel];
    
    _authorLabel = [UILabel new];
    _authorLabel.font = [UIFont systemFontOfSize:11];
    _authorLabel.textAlignment = NSTextAlignmentRight;
    [root addSubview:_authorLabel];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(root).offset(10);
        make.top.equalTo(root).offset(10);
        make.right.equalTo(root).offset(-10);
    }];
    
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(root).offset(10);
        make.bottom.equalTo(root).offset(-10);
    }];
    
    [_authorLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(root).offset(-10);
        make.bottom.equalTo(root).offset(-10);
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
