//
//  NSManagedObject+MatrixCoreData.h
//  iOSBlogReader
//
//  Created by everettjf on 16/4/30.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface NSManagedObject(MatrixCoreData)

+ (NSManagedObjectContext*)mcd_init:(NSString*)modelFileName storePath:(NSURL*)storePath;

+ (NSUInteger)mcd_countAll;
+ (NSUInteger)mcd_count:(NSPredicate*)predicate;

+ (NSArray<__kindof NSManagedObject*>*)mcd_findAll;

+ (NSArray<__kindof NSManagedObject*>*)mcd_findAll:(NSDictionary<NSString*,NSNumber*>*)sort;
+ (NSArray<__kindof NSManagedObject*>*)mcd_findAll:(NSDictionary<NSString*,NSNumber*>*)sort predicate:(NSPredicate*)predicate;

+ (NSArray<__kindof NSManagedObject*>*)mcd_findAll:(NSUInteger)offset limit:(NSUInteger)limit sort:(NSDictionary<NSString*,NSNumber*>*)sort;
+ (NSArray<__kindof NSManagedObject*>*)mcd_findAll:(NSUInteger)offset limit:(NSUInteger)limit sort:(NSDictionary<NSString*,NSNumber*>*)sort predicate:(NSPredicate*)predicate;

+ (void)mcd_findOrCreate:(NSString*)key value:(id)value callback:(void (^)(NSManagedObject*m))callback;
+ (NSManagedObject*)mcd_find:(NSString*)key value:(id)value;
+ (void)mcd_update:(NSString*)key value:(id)value callback:(void (^)(NSManagedObject*m))callback;
+ (void)mcd_delete:(NSString*)key value:(id)value;

@end
