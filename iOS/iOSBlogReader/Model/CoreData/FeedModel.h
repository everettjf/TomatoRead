//
//  FeedModel.h
//  iOSBlogReader
//
//  Created by everettjf on 16/4/9.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSUInteger, FeedModelType) {
    FeedModelType_Feed = 0,
    FeedModelType_Link = 1,
};

@class FeedItemModel;
@interface FeedModel : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "FeedModel+CoreDataProperties.h"
