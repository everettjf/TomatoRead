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
@property (assign,nonatomic) NSUInteger zindex;
@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *url;
@property (strong,nonatomic) NSString *feed_url;
@property (strong,nonatomic) NSString *favicon;
@property (strong,nonatomic) NSString *spider;
@property (strong,nonatomic) NSDate *updated_at;

@property (assign,nonatomic) NSUInteger domain_oid;
@property (assign,nonatomic) NSUInteger aspect_oid;
@end

@interface RestLinkListModel : NSObject
@property (strong,nonatomic) NSArray<RestLinkModel*> *feeds;
@end
