//
//  FeedModel+CoreDataProperties.h
//  iOSBlogReader
//
//  Created by everettjf on 16/5/14.
//  Copyright © 2016年 everettjf. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "FeedModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FeedModel (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *favicon;
@property (nullable, nonatomic, retain) NSString *feed_url;
@property (nullable, nonatomic, retain) NSDate *last_parse_date;
@property (nullable, nonatomic, retain) NSNumber *last_parse_timeinterval;
@property (nullable, nonatomic, retain) NSDate *latest_post_date;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *oid;
@property (nullable, nonatomic, retain) NSString *spider;
@property (nullable, nonatomic, retain) NSString *url;
@property (nullable, nonatomic, retain) NSNumber *zindex;
@property (nullable, nonatomic, retain) NSSet<FeedItemModel *> *items;

@end

@interface FeedModel (CoreDataGeneratedAccessors)

- (void)addItemsObject:(FeedItemModel *)value;
- (void)removeItemsObject:(FeedItemModel *)value;
- (void)addItems:(NSSet<FeedItemModel *> *)values;
- (void)removeItems:(NSSet<FeedItemModel *> *)values;

@end

NS_ASSUME_NONNULL_END
