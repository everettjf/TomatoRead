//
//  FeedPostModel+CoreDataProperties.h
//  iOSBlogReader
//
//  Created by everettjf on 16/4/9.
//  Copyright © 2016年 everettjf. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "FeedPostModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FeedPostModel (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSDate *post_at;
@property (nullable, nonatomic, retain) NSString *content;
@property (nullable, nonatomic, retain) NSString *url;
@property (nullable, nonatomic, retain) NSDate *created_at;
@property (nullable, nonatomic, retain) NSString *author;
@property (nullable, nonatomic, retain) FeedModel *feed;

@end

NS_ASSUME_NONNULL_END
