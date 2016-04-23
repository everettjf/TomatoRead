//
//  AppUtil.h
//  iOSBlogReader
//
//  Created by everettjf on 16/4/6.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AppUtil : NSObject

+ (NSURL *)documentsDirectory;

+ (AppUtil*)util;
- (NSString *)formatDate:(NSDate *)date;


@end
