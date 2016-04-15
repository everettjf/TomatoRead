//
//  BlogDataset.h
//  iOSBlogReader
//
//  Created by everettjf on 16/4/6.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestModel/RestDomainListModel.h"

typedef NS_OPTIONS(NSUInteger, PageItemType) {
    PageItemType_Feed, // data type : NSString*
    PageItemType_Link, // data type : RestAspectModel*
};

@interface PageItemEntity : NSObject
@property (assign,nonatomic) PageItemType type;
@property (strong,nonatomic) NSString* title;
@property (strong,nonatomic) id data;

@property (assign,nonatomic,readonly) NSUInteger aspectID;
@end

@interface PageDataset : NSObject
@property (strong,nonatomic,readonly) NSArray<PageItemEntity*> *items;

+ (PageDataset*)sharedDataset;
- (void)prepare:(void(^)(BOOL succeed))complete;

@end
