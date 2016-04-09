//
//  MainContext.m
//  iOSBlogReader
//
//  Created by everettjf on 16/4/10.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#import "MainContext.h"

@implementation MainContext

+ (MainContext *)sharedContext{
    static MainContext *o;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        o = [MainContext new];
    });
    return o;
}

@end
