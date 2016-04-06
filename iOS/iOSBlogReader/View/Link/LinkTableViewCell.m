//
//  LinkTableViewCell.m
//  iOSBlogReader
//
//  Created by everettjf on 16/4/7.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#import "LinkTableViewCell.h"
#import <Masonry.h>

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
    
}

- (void)prepareForReuse{
    [super prepareForReuse];
    
}

@end
