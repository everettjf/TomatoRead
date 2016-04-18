//
//  DataStorage.m
//  iOSBlogReader
//
//  Created by everettjf on 16/4/9.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#import "DataManager.h"
#import "AppUtil.h"
#import "DomainModel.h"
#import "AspectModel.h"
#import "FeedModel.h"
#import "FeedItemModel.h"

@implementation DataManager

+ (DataManager *)manager{
    static DataManager *o;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        o = [DataManager new];
    });
    return o;
}

- (NSURL*)_dataPath{
    return [[AppUtil documentsDirectory] URLByAppendingPathComponent:@"blogdata.db"];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSLog(@"data path = %@", [self _dataPath]);
        [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreAtURL:[self _dataPath]];
        
#ifdef DEBUG
        [DomainModel MR_truncateAll];
        [AspectModel MR_truncateAll];
        [FeedModel MR_truncateAll];
        [FeedItemModel MR_truncateAll];
#endif
    
    }
    return self;
}

@end
