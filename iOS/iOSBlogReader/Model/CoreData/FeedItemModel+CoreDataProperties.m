//
//  FeedItemModel+CoreDataProperties.m
//  iOSBlogReader
//
//  Created by everettjf on 16/4/11.
//  Copyright © 2016年 everettjf. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "FeedItemModel+CoreDataProperties.h"

@implementation FeedItemModel (CoreDataProperties)

@dynamic identifier;
@dynamic title;
@dynamic link;
@dynamic date;
@dynamic updated;
@dynamic summary;
@dynamic content;
@dynamic author;
@dynamic feed_oid;

@end
