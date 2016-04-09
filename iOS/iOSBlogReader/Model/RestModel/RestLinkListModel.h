//
//  RestLinkListModel.h
//  iOSBlogReader
//
//  Created by everettjf on 16/4/8.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RestLinkModel : NSObject
@property (assign,nonatomic) NSUInteger oid;
@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *url;
@property (strong,nonatomic) NSString *feed_url;
@property (strong,nonatomic) NSString *favicon;
@property (strong,nonatomic) NSString *desc;
@property (strong,nonatomic) NSDate *updated_at;

@property (assign,nonatomic) NSUInteger domain_oid;
@property (assign,nonatomic) NSUInteger aspect_oid;
@end

@interface RestLinkListModel : NSObject
@property (assign,nonatomic) NSUInteger count;
@property (strong,nonatomic) NSString *next;
@property (strong,nonatomic) NSString *previous;
@property (strong,nonatomic) NSArray<RestLinkModel*> *results;
@end
