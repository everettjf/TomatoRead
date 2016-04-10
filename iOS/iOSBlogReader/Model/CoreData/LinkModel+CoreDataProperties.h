//
//  LinkModel+CoreDataProperties.h
//  iOSBlogReader
//
//  Created by everettjf on 16/4/11.
//  Copyright © 2016年 everettjf. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "LinkModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LinkModel (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *desc;
@property (nullable, nonatomic, retain) NSString *favicon;
@property (nullable, nonatomic, retain) NSString *feed_url;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *oid;
@property (nullable, nonatomic, retain) NSDate *updated_at;
@property (nullable, nonatomic, retain) NSString *url;
@property (nullable, nonatomic, retain) AspectModel *aspect;

@end

NS_ASSUME_NONNULL_END
