//
//  FeedModel+CoreDataProperties.h
//  iOSBlogReader
//
//  Created by everettjf on 16/4/9.
//  Copyright © 2016年 everettjf. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "FeedModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FeedModel (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *oid;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *feed_url;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *posts;

@end

@interface FeedModel (CoreDataGeneratedAccessors)

- (void)addPostsObject:(NSManagedObject *)value;
- (void)removePostsObject:(NSManagedObject *)value;
- (void)addPosts:(NSSet<NSManagedObject *> *)values;
- (void)removePosts:(NSSet<NSManagedObject *> *)values;

@end

NS_ASSUME_NONNULL_END
