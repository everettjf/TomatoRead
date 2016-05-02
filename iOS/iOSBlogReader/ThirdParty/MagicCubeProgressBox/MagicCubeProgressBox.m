//
//  MagicCubeProgressBox.m
//  iOSBlogReader
//
//  Created by everettjf on 16/5/2.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#import "MagicCubeProgressBox.h"
#import <POP.h>

NSString * const MagicCubeProgressBoxEventTapped= @"MagicCubeProgressBoxEventTapped";


@interface MagicCubeProgressBox ()
@property (weak,nonatomic) UIView *parentView;

@end

@implementation MagicCubeProgressBox{
    UIView *_cubeView;
    NSMutableArray<UIView*> *_squareViews;
    NSArray<UIColor*> *_squareColors;
    NSArray<UIColor*> *_squareColors2;
    UILabel *_textLabel;
    
    NSUInteger _animatingIndex;
    NSUInteger _animatingTargetColorGroup;
    BOOL _animateStop;
    
    BOOL _isMovedToBottomRight;
}

+ (instancetype)boxWithParentView:(UIView *)parentView{
    if(!parentView)return nil;
    
    CGSize size = CGSizeMake(120, 150);
    CGRect rect = CGRectMake(parentView.frame.size.width/2 - size.width/2,
                             parentView.frame.size.height/2 - size.height/2,
                             size.width,
                             size.height);
    
    MagicCubeProgressBox *box = [[MagicCubeProgressBox alloc]initWithFrame:rect];
    box.parentView = parentView;
    [parentView addSubview:box];
    return box;
}

- (void)hide{
    [UIView animateWithDuration:1 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
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
        
        _cubeView = [UIView new];
        [self addSubview:_cubeView];
        
        [self _setupCube];
        [self _setupLabel];
        [self _startAnimate];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(_viewTapped:)];
        [_cubeView addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)_layoutCubeContainer{
    CGSize cubeSize = self.frame.size;
    _cubeView.frame = CGRectMake(0,
                                 0,
                                 cubeSize.width,
                                 cubeSize.width);
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
    animation.duration = 1;
    if(_animatingTargetColorGroup == 0)
        animation.toValue = [_squareColors2 objectAtIndex:_animatingIndex];
    else
        animation.toValue = [_squareColors objectAtIndex:_animatingIndex];
        
    animation.delegate = self;
    animation.name = @"cubeSquareAnimation";
    
    UIView *oneView = [_squareViews objectAtIndex:_animatingIndex];
    [oneView pop_addAnimation:animation forKey:@"cubeAnimation"];
}

- (void)pop_animationDidStop:(POPAnimation *)anim finished:(BOOL)finished{
    if([anim.name isEqualToString:@"cubeSquareAnimation"]){
        if(_animatingIndex == 8){
            _animatingIndex = 0;
            _animatingTargetColorGroup = ++_animatingTargetColorGroup%2;
        }else{
            ++_animatingIndex;
        }
        
        if(!_animateStop){
            [self _startAnimate];
        }
    }
}

- (void)_setupLabel{
    _textLabel = [UILabel new];
    _textLabel.hidden = YES;
    _textLabel.font = [UIFont systemFontOfSize:14];
    _textLabel.textColor = [UIColor blackColor];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_textLabel];
}
- (void)_layoutLabel{
    _textLabel.frame = CGRectMake(_cubeView.frame.origin.x,
                                  _cubeView.frame.origin.y + _cubeView.frame.size.height + 3,
                                  _cubeView.frame.size.width,
                                  20);
}
- (void)setText:(NSString*)text{
    _textLabel.hidden = NO;
    _textLabel.text = text;
}

- (void)stop{
    _animateStop = YES;
}

- (void)_viewTapped:(id)gesture{
    [[NSNotificationCenter defaultCenter]postNotificationName:MagicCubeProgressBoxEventTapped object:nil];
}

- (void)moveToBottomRight{
    if(_isMovedToBottomRight)return;
    
    CGSize size = CGSizeMake(60, 80);
    CGRect rect = CGRectMake(_parentView.frame.size.width - size.width - 5,
                             _parentView.frame.size.height - size.height - 60,
                             size.width,
                             size.height);
    
    POPBasicAnimation *animation = [POPBasicAnimation animation];
    animation.property = [POPAnimatableProperty propertyWithName:kPOPViewFrame];
    animation.toValue = [NSValue valueWithCGRect:rect];
    
    animation.delegate = self;
    animation.name = @"moveAnimation";
    
    [self pop_addAnimation:animation forKey:@"moveToBottomRightAnimation"];
    
    _isMovedToBottomRight = YES;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self _layoutCubeContainer];
    [self _layoutCube];
    [self _layoutLabel];
}

@end
