//
//  PrefixHeader.h
//  iOSBlogReader
//
//  Created by everettjf on 16/4/7.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#ifndef PrefixHeader_h
#define PrefixHeader_h

#import <Masonry.h>
#import <YYModel.h>
#import <AFNetworking.h>

#define UIColorFromRGBA(rgbValue,a)        [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0f green:((float)((rgbValue & 0xFF00) >> 8))/255.0f blue:((float)(rgbValue & 0xFF))/255.0f alpha:a]
#define UIColorGraySubTitle [UIColor colorWithRed:0.498 green:0.498 blue:0.498 alpha:1.0];


#endif /* PrefixHeader_h */
