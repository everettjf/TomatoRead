//
//  DataStorage.m
//  iOSBlogReader
//
//  Created by everettjf on 16/4/9.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#import "DataStorage.h"
#import "AppUtil.h"

@implementation DataStorage

+ (DataStorage *)sharedStorage{
    static DataStorage *o;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        o = [DataStorage new];
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
    }
    return self;
}

@end
