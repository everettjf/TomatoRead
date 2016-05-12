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
}

@end

@implementation LinkTableViewCell

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
    
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont systemFontOfSize:16];
    _titleLabel.numberOfLines = 2;
    [rootView addSubview:_titleLabel];
    
    _faviconImageView = [UIImageView new];
    [rootView addSubview:_faviconImageView];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(rootView).offset(10);
        make.centerY.equalTo(rootView);
    }];
    [_faviconImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(rootView).offset(-10);
        make.centerY.equalTo(rootView);
        make.height.equalTo(@40);
        make.width.equalTo(@40);
        make.left.equalTo(_titleLabel.mas_right).offset(25);
    }];
    
}

- (void)setFavicon:(NSString *)favicon{
    [_faviconImageView yy_setImageWithURL:[NSURL URLWithString:favicon] placeholder:[UIImage imageNamed:@"safari"]];
}

- (void)setTitle:(NSString *)title{
    _titleLabel.text = title;
}

- (void)prepareForReuse{
    [super prepareForReuse];
    
    _faviconImageView.image = nil;
    _titleLabel.text = @"";
}

@end
