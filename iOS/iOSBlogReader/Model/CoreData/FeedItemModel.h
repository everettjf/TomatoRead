//
//  FeedItemModel.h
//  iOSBlogReader
//
//  Created by everettjf on 16/4/11.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@class FeedModel;
typedef NS_OPTIONS(NSUInteger, FeedItemModelType) {
    FeedItemModelType_Feed = 0,
    FeedItemModelType_Link = 1,
};

@interface FeedItemModel : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "FeedItemModel+CoreDataProperties.h"
