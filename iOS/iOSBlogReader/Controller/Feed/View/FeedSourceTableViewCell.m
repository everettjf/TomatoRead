//
//  FeedSourceTableViewCell.m
//  iOSBlogReader
//
//  Created by everettjf on 16/4/19.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#import "FeedSourceTableViewCell.h"
#import <YYWebImage.h>

@interface FeedSourceTableViewCell ()
{
    UIImageView *_faviconImageView;
    UILabel *_titleLabel;
    UILabel *_subTitleLabel;
}


@end

@implementation FeedSourceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self _setupView];
    }
    return self;
}

- (void)_setupView{
    UIView *rootView = self.contentView;
    
    _faviconImageView = [UIImageView new];
    [rootView addSubview:_faviconImageView];
    
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont systemFontOfSize:16];
    _titleLabel.numberOfLines = 2;
    _titleLabel.textColor = [UIColor blackColor];
    [rootView addSubview:_titleLabel];
    
    _subTitleLabel = [UILabel new];
    _subTitleLabel.font = [UIFont systemFontOfSize:14];
    _subTitleLabel.numberOfLines = 1;
    _subTitleLabel.textColor = UIColorGraySubTitle;
    [rootView addSubview:_subTitleLabel];
    
    [_faviconImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(rootView).offset(12);
        make.centerY.equalTo(rootView);
        make.height.equalTo(@65);
        make.width.equalTo(@65);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(_faviconImageView.mas_right).offset(15);
        make.top.equalTo(rootView).offset(10);
        make.right.equalTo(rootView).offset(-20);
    }];

    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_titleLabel.mas_bottom).offset(8);
        make.left.equalTo(_titleLabel);
        make.right.equalTo(_titleLabel);
    }];
}

- (void)setFavicon:(NSString *)favicon{
    [_faviconImageView yy_setImageWithURL:[NSURL URLWithString:favicon] placeholder:[UIImage imageNamed:@"safari"]];
}

- (void)setTitle:(NSString *)title{
    _titleLabel.text = title;
}
- (void)setSubTitle:(NSString *)subTitle{
    _subTitleLabel.text = subTitle;
}

- (void)prepareForReuse{
    [super prepareForReuse];
    _faviconImageView.image = nil;
}


@end
