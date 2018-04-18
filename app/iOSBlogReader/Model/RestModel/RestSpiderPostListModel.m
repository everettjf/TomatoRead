//
//  RestSpiderPostListModel.m
//  iOSBlogReader
//
//  Created by everettjf on 16/5/9.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#import "RestSpiderPostListModel.h"

@implementation RestSpiderPostModel
@end

@implementation RestSpiderPostListModel
+ (NSDictionary*)modelContainerPropertyGenericClass{
    return @{ @"posts":RestSpiderPostModel.class };
}

@end
