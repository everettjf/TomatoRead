//
//  MagicCubeProgressBox.h
//  iOSBlogReader
//
//  Created by everettjf on 16/5/2.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const MagicCubeProgressBoxEventTapped;

@interface MagicCubeProgressBox : UIView

+ (instancetype)boxWithParentView:(UIView *)parentView;
- (void)hide;
- (void)stop;

- (void)setText:(NSString*)text;
- (void)moveToBottomRight;

@end
