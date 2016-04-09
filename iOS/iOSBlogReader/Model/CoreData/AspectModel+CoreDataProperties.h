//
//  AspectModel+CoreDataProperties.h
//  iOSBlogReader
//
//  Created by everettjf on 16/4/9.
//  Copyright © 2016年 everettjf. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "AspectModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AspectModel (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *oid;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSManagedObject *domain;
@property (nullable, nonatomic, retain) NSSet<LinkModel *> *links;

@end

@interface AspectModel (CoreDataGeneratedAccessors)

- (void)addLinksObject:(LinkModel *)value;
- (void)removeLinksObject:(LinkModel *)value;
- (void)addLinks:(NSSet<LinkModel *> *)values;
- (void)removeLinks:(NSSet<LinkModel *> *)values;

@end

NS_ASSUME_NONNULL_END
