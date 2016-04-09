//
//  RestLinkListModel.m
//  iOSBlogReader
//
//  Created by everettjf on 16/4/8.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#import "RestLinkListModel.h"

@implementation RestLinkModel
+ (NSDictionary*)modelCustomPropertyMapper{
    return @{@"oid":@"id",
             @"aspect_id":@"aspect.id",
             @"domain_id":@"domain.id"
             };
}
@end

@implementation RestLinkListModel
+ (NSDictionary*)modelContainerPropertyGenericClass{
    return @{ @"results":RestLinkModel.class };
}
@end
