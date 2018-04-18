//
//  MainContext.h
//  iOSBlogReader
//
//  Created by everettjf on 16/4/10.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainContext : NSObject

+ (MainContext*)sharedContext;

@property (weak,nonatomic) UINavigationController *discoverNavigationController;

@end
