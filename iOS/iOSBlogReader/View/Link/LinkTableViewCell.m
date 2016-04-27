//
//  LinkTableViewCell.m
//  iOSBlogReader
//
//  Created by everettjf on 16/4/7.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#import "LinkTableViewCell.h"
#import <YYWebImage.h>

@interface LinkTableViewCell ()
{
    UIImageView *_faviconImageView;
    UILabel *_titleLabel;
    UILabel *_subTitleLabel;
}

@end

@implementation LinkTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self _setupView];
    }
    return self;
}

- (void)_setupView{
    UIView *rootView = self.contentView;
    
    _faviconImageView = [UIImageView new];
    [rootView addSubview:_faviconImageView];
    
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.numberOfLines = 2;
    [rootView addSubview:_titleLabel];
    
    _subTitleLabel = [UILabel new];
    _subTitleLabel.font = [UIFont systemFontOfSize:11];
    _subTitleLabel.numberOfLines = 1;
    [rootView addSubview:_subTitleLabel];
    
    [_faviconImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(rootView).offset(5);
        make.top.equalTo(rootView).offset(5);
        make.height.equalTo(@50);
        make.width.equalTo(@50);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(_faviconImageView.mas_right).offset(5);
        make.top.equalTo(_faviconImageView);
        make.right.equalTo(rootView).offset(-5);
    }];

    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_titleLabel.mas_bottom).offset(5);
        make.left.equalTo(_faviconImageView.mas_right).offset(5);
        make.right.equalTo(rootView).offset(-5);
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
    _titleLabel.text = @"";
    _subTitleLabel.text = @"";
}

@end
