//
//  NSManagedObject+MatrixCoreData.m
//  iOSBlogReader
//
//  Created by everettjf on 16/4/30.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#import "NSManagedObject+MatrixCoreData.h"

static NSManagedObjectContext *s_context;

@implementation NSManagedObject(MatrixCoreData)

+ (NSManagedObjectContext *)mcd_context{
    return s_context;
}

+ (NSManagedObjectContext*)mcd_init:(NSString*)modelFileName storePath:(NSURL*)storePath{
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:modelFileName withExtension:@"momd"];
    NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSAssert(mom != nil, @"Error initializing Managed Object Model");
    
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [moc setPersistentStoreCoordinator:psc];
    
    NSDictionary *options = @{
                              NSMigratePersistentStoresAutomaticallyOption : @(YES),
                              NSInferMappingModelAutomaticallyOption : @(YES)
                              };
    NSError *error = nil;
    NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storePath options:options error:&error];
    NSAssert(store != nil, @"Error initializing PSC: %@\n%@", [error localizedDescription], [error userInfo]);
    
    s_context = moc;
    
    return moc;
}

+ (void)mcd_save{
    [[[self class]mcd_context]save:nil];
}

+ (NSUInteger)mcd_countAll{
    return [[self class]mcd_count:nil];
}

+ (NSUInteger)mcd_count:(NSPredicate *)predicate{
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([self class])];
    if(predicate){
        req.predicate = predicate;
    }
    __block NSUInteger count;
    [[[self class]mcd_context] performBlockAndWait:^{
        NSError *error;
        count = [[[self class]mcd_context] countForFetchRequest:req error:&error];
    }];
    return count;
}

+ (NSArray<NSManagedObject *> *)mcd_findAll{
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([self class])];
    __block NSArray *results;
    [[[self class]mcd_context] performBlockAndWait:^{
        NSError *error;
        results = [[[self class]mcd_context] executeFetchRequest:req error:&error];
    }];
    return results;
}

+ (NSArray<NSManagedObject *> *)mcd_findAll:(NSDictionary<NSString *,NSNumber *> *)sort{
    return [[self class]mcd_findAll:sort predicate:nil];
}
+ (NSArray<NSManagedObject *> *)mcd_findAll:(NSDictionary<NSString *,NSNumber *> *)sort predicate:(NSPredicate *)predicate{
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([self class])];
    
    if(sort){
        NSMutableArray *sortDescriptors = [NSMutableArray new];
        for (NSString *sortKey in sort) {
            [sortDescriptors addObject:[NSSortDescriptor sortDescriptorWithKey:sortKey ascending:[sort objectForKey:sortKey].boolValue]];
        }
        req.sortDescriptors = sortDescriptors;
    }
    
    if(predicate){
        req.predicate = predicate;
    }
    
    __block NSArray *results;
    [[[self class]mcd_context] performBlockAndWait:^{
        NSError *error;
        results = [[[self class] mcd_context] executeFetchRequest:req error:&error];
    }];
    return results;
}

+ (NSArray<NSManagedObject *> *)mcd_findAll:(NSUInteger)offset limit:(NSUInteger)limit sort:(NSDictionary<NSString *,NSNumber *> *)sort{
    return [[self class]mcd_findAll:offset limit:limit sort:sort predicate:nil];
}

+ (NSArray<NSManagedObject *> *)mcd_findAll:(NSUInteger)offset limit:(NSUInteger)limit sort:(NSDictionary<NSString *,NSNumber *> *)sort predicate:(NSPredicate *)predicate{
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([self class])];
    req.fetchOffset = offset;
    req.fetchLimit = limit;
    
    if(sort){
        NSMutableArray *sortDescriptors = [NSMutableArray new];
        for (NSString *sortKey in sort) {
            [sortDescriptors addObject:[NSSortDescriptor sortDescriptorWithKey:sortKey ascending:[sort objectForKey:sortKey].boolValue]];
        }
        req.sortDescriptors = sortDescriptors;
    }
    
    if(predicate){
        req.predicate = predicate;
    }
    
    __block NSArray *results;
    [[[self class]mcd_context] performBlockAndWait:^{
        NSError *error;
        results = [[[self class] mcd_context] executeFetchRequest:req error:&error];
    }];
    return results;
}

+ (void)mcd_findOrCreate:(NSString*)key value:(id)value callback:(void (^)(NSManagedObject*m))callback{
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([self class])];
    req.predicate = [NSPredicate predicateWithFormat:@"%K == %@",key,value];
    
    [[[self class]mcd_context] performBlockAndWait:^{
        NSError *error = nil;
        NSArray *results = [[[self class]mcd_context] executeFetchRequest:req error:&error];
        if(error || !results){
            callback(nil);
            return;
        }
        
        NSManagedObject *model;
        if(results.count > 0){
            model = results.firstObject;
        }else{
            model = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class]) inManagedObjectContext:[[self class]mcd_context]];
            [model setValue:value forKey:key];
        }
        
        callback(model);
        
        [[self class] mcd_save];
    }];
}

+ (NSManagedObject *)mcd_find:(NSString *)key value:(id)value{
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([self class])];
    req.predicate = [NSPredicate predicateWithFormat:@"%K == %@",key,value];
    
    __block NSManagedObject *model;
    [[[self class]mcd_context] performBlockAndWait:^{
        NSError *error = nil;
        NSArray *results = [[[self class]mcd_context] executeFetchRequest:req error:&error];
        if(error || !results){
            return;
        }
        
        if(results.count > 0){
            model = results.firstObject;
        }
    }];
    return model;
}

+ (void)mcd_delete:(NSString *)key value:(id)value{
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([self class])];
    req.predicate = [NSPredicate predicateWithFormat:@"%K == %@",key,value];
    
    [[[self class]mcd_context] performBlockAndWait:^{
        NSError *error = nil;
        NSArray *results = [[[self class]mcd_context] executeFetchRequest:req error:&error];
        if(error || !results){
            return;
        }
        
        for (NSManagedObject *obj in results) {
            [[[self class]mcd_context]deleteObject:obj];
        }
    }];
}

+ (void)mcd_update:(NSString *)key value:(id)value callback:(void (^)(NSManagedObject *))callback{
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([self class])];
    req.predicate = [NSPredicate predicateWithFormat:@"%K == %@",key,value];
    
    [[[self class]mcd_context] performBlockAndWait:^{
        NSError *error = nil;
        NSArray *results = [[[self class]mcd_context] executeFetchRequest:req error:&error];
        if(error || !results){
            callback(nil);
            return;
        }
        
        NSManagedObject *model;
        if(results.count == 0){
            callback(nil);
            return;
        }
        
        model = results.firstObject;
        callback(model);
        
        [[self class] mcd_save];
    }];
    
}


@end
