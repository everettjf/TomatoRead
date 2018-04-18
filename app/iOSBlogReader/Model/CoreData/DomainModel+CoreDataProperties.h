//
//  DomainModel+CoreDataProperties.h
//  iOSBlogReader
//
//  Created by everettjf on 16/5/14.
//  Copyright © 2016年 everettjf. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DomainModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DomainModel (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *oid;
@property (nullable, nonatomic, retain) NSNumber *zindex;
@property (nullable, nonatomic, retain) NSSet<AspectModel *> *aspects;

@end

@interface DomainModel (CoreDataGeneratedAccessors)

- (void)addAspectsObject:(AspectModel *)value;
- (void)removeAspectsObject:(AspectModel *)value;
- (void)addAspects:(NSSet<AspectModel *> *)values;
- (void)removeAspects:(NSSet<AspectModel *> *)values;

@end

NS_ASSUME_NONNULL_END
