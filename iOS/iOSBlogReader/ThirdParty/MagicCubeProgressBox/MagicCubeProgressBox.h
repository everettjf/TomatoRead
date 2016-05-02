//
//  MagicCubeProgressBox.h
//  iOSBlogReader
//
//  Created by everettjf on 16/5/2.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MagicCubeProgressBox : UIView

+ (void)show;
+ (void)show:(UIView*)parentView;
+ (void)hide;

+ (void)setText:(NSString*)text;
+ (void)moveTo:(CGRect*)rect;

@end
