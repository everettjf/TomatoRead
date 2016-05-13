//
//  FeedItemModel+CoreDataProperties.h
//  iOSBlogReader
//
//  Created by everettjf on 16/5/14.
//  Copyright © 2016年 everettjf. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "FeedItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FeedItemModel (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *author;
@property (nullable, nonatomic, retain) NSString *content;
@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSString *identifier;
@property (nullable, nonatomic, retain) NSString *image;
@property (nullable, nonatomic, retain) NSString *link;
@property (nullable, nonatomic, retain) NSString *summary;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSNumber *type;
@property (nullable, nonatomic, retain) NSDate *updated;
@property (nullable, nonatomic, retain) FeedModel *feed;

@end

NS_ASSUME_NONNULL_END
