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
             };
}
@end

@implementation RestFeedListModel
+ (NSDictionary*)modelContainerPropertyGenericClass{
    return @{ @"feeds":RestLinkModel.class };
}
@end

@implementation RestLinkListModel
+ (NSDictionary*)modelContainerPropertyGenericClass{
    return @{ @"links":RestLinkModel.class };
}

- (NSUInteger)next_page{
    if(_cur_page >= _num_pages) return _cur_page;
    return _cur_page + 1;
}

- (BOOL)is_end_page{
    return _cur_page == _num_pages;
}
@end