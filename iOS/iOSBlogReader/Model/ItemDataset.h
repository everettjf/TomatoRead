//
//  BlogDataset.h
//  iOSBlogReader
//
//  Created by everettjf on 16/4/6.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, ItemType) {
    ItemType_Feed,
    ItemType_Link,
};

@interface ItemEntity : NSObject
@property (assign,nonatomic) ItemType type;
@property (strong,nonatomic) NSString *title;
@property (strong,nonatomic) NSNumber *indexID;

+ (ItemEntity*)entity:(ItemType)type title:(NSString*)title indexID:(NSNumber*)indexID;
@end

@interface ItemDataset : NSObject

+ (ItemDataset*)sharedDataset;

@property (strong,nonatomic) NSArray<ItemEntity*> *items;

@end
