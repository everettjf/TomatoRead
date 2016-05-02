//
//  MagicCubeProgressBox.m
//  iOSBlogReader
//
//  Created by everettjf on 16/5/2.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#import "MagicCubeProgressBox.h"
#import <POP.h>

static MagicCubeProgressBox *s_box;

@implementation MagicCubeProgressBox{
    UIView *_cubeView;
    NSMutableArray<UIView*> *_squareViews;
    NSArray<UIColor*> *_squareColors;
    NSArray<UIColor*> *_squareColors2;
    UILabel *_textLabel;
    
    NSUInteger _animatingIndex;
    NSUInteger _animatingTargetColorGroup;
}

#pragma mark Static Methods
+ (void)show{
    [[self class]show:[UIApplication sharedApplication].delegate.window];
}

+ (void)show:(UIView *)parentView{
    if(!parentView)return;
    if(s_box)return;
    s_box = [[MagicCubeProgressBox alloc]initWithFrame:parentView.frame];
    [parentView addSubview:s_box];
}

+ (void)hide{
    [s_box removeFromSuperview];
    s_box = nil;
}

+ (void)setText:(NSString *)text{
    
}

+ (void)moveTo:(CGRect *)rect{
    
}

#pragma mark Member Methods
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _squareColors = @[
                          UIColorFromRGBA(0xcd0000, 0.15),
                          UIColorFromRGBA(0x000000, 0.15),
                          UIColorFromRGBA(0xff6f00, 0.15),
                          UIColorFromRGBA(0x00008e, 0.15),
                          UIColorFromRGBA(0x009f0f, 0.15),
                          UIColorFromRGBA(0xffcf00, 0.15),
                          UIColorFromRGBA(0xffcf00, 0.15),
                          UIColorFromRGBA(0xff6f00, 0.15),
                          UIColorFromRGBA(0xcd0000, 0.15),
                          ];
        
        _squareColors2 = @[
                          UIColorFromRGBA(0xcd0000, 1.0),
                          UIColorFromRGBA(0x000000, 1.0),
                          UIColorFromRGBA(0xff6f00, 1.0),
                          UIColorFromRGBA(0x00008e, 1.0),
                          UIColorFromRGBA(0x009f0f, 1.0),
                          UIColorFromRGBA(0xffcf00, 1.0),
                          UIColorFromRGBA(0xffcf00, 1.0),
                          UIColorFromRGBA(0xff6f00, 1.0),
                          UIColorFromRGBA(0xcd0000, 1.0),
                          ];
        
        CGSize cubeSize = CGSizeMake(120, 120);
        _cubeView = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width/2-cubeSize.width/2,
                                                           frame.size.height/2-cubeSize.height/2,
                                                           cubeSize.width,
                                                           cubeSize.height)];
        
        [self addSubview:_cubeView];
        
        [self _setupCube];
        [self _layoutCube];
        [self _startAnimate];
    }
    return self;
}

- (void)_setupCube{
    _squareViews = [NSMutableArray new];
    for(NSUInteger idx = 0; idx < 9; ++idx){
        UIView *oneView = [UIView new];
        oneView.backgroundColor = [_squareColors objectAtIndex:idx];
        oneView.layer.cornerRadius = 5;
        oneView.layer.masksToBounds = YES;
        [_cubeView addSubview:oneView];
        [_squareViews addObject:oneView];
    }
}

- (void)_layoutCube{
    CGSize oneSize = CGSizeMake(_cubeView.frame.size.width/3, _cubeView.frame.size.height/3);
    for(NSUInteger idx = 0; idx < 9; ++idx){
        UIView *oneView = [_squareViews objectAtIndex:idx];
        oneView.frame = CGRectMake(idx%3*oneSize.width, idx/3*oneSize.height, oneSize.width, oneSize.height);
    }
}

- (void)_startAnimate{
    POPBasicAnimation *animation = [POPBasicAnimation animation];
    animation.property = [POPAnimatableProperty propertyWithName:kPOPViewBackgroundColor];
    if(_animatingTargetColorGroup == 0)
        animation.toValue = [_squareColors2 objectAtIndex:_animatingIndex];
    else
        animation.toValue = [_squareColors objectAtIndex:_animatingIndex];
        
    animation.delegate = self;
    animation.name = [NSString stringWithFormat:@"cubeAnimation-%@-%@",@(_animatingIndex),@(_animatingTargetColorGroup)];
    
    UIView *oneView = [_squareViews objectAtIndex:_animatingIndex];
    [oneView pop_addAnimation:animation forKey:@"cubeAnimation"];
}

- (void)pop_animationDidStop:(POPAnimation *)anim finished:(BOOL)finished{
    if(_animatingIndex == 8){
        _animatingIndex = 0;
        _animatingTargetColorGroup = ++_animatingTargetColorGroup%2;
    }else{
        ++_animatingIndex;
    }
    
    [self _startAnimate];
}


@end
