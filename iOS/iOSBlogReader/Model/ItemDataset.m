//
//  BlogDataset.m
//  iOSBlogReader
//
//  Created by everettjf on 16/4/6.
//  Copyright © 2016年 everettjf. All rights reserved.
//


#import "ItemDataset.h"


@implementation ItemEntity

+ (ItemEntity *)entity:(ItemType)type title:(NSString *)title indexID:(NSNumber *)indexID{
    ItemEntity *one = [ItemEntity new];
    one.type = type;
    one.title = title;
    one.indexID = indexID;
    return one;
}

@end

@implementation ItemDataset

+ (ItemDataset *)sharedDataset{
    static ItemDataset *inst;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        inst = [ItemDataset new];
    });
    return inst;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _items = @[
                   [ItemEntity entity:ItemType_Feed title:@"订阅" indexID:@0],
                   [ItemEntity entity:ItemType_Link title:@"博客" indexID:@1],
                   [ItemEntity entity:ItemType_Link title:@"文章" indexID:@2],
                   [ItemEntity entity:ItemType_Link title:@"教程" indexID:@3],
                   [ItemEntity entity:ItemType_Link title:@"社区" indexID:@4],
                   [ItemEntity entity:ItemType_Link title:@"源码" indexID:@5],
                   [ItemEntity entity:ItemType_Link title:@"工具" indexID:@6],
                   [ItemEntity entity:ItemType_Link title:@"大牛堂" indexID:@7],
                   ];
    }
    return self;
}

@end
