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
@property (strong,nonatomic) NSString *spider;
@property (strong,nonatomic) NSDate *created_at;
@property (assign,nonatomic) NSUInteger zindex;

@property (assign,nonatomic) NSUInteger domain_id;
@property (assign,nonatomic) NSUInteger aspect_id;
@end

@interface RestFeedListModel : NSObject
@property (strong,nonatomic) NSArray<RestLinkModel*> *feeds;
@end

@interface RestLinkListModel : NSObject
@property (assign,nonatomic) NSUInteger count;
@property (assign,nonatomic) NSUInteger cur_page;
@property (assign,nonatomic) NSUInteger num_pages;
@property (strong,nonatomic) NSArray<RestLinkModel*> *links;

@property (assign,nonatomic,readonly) NSUInteger next_page;
@property (assign,nonatomic,readonly) BOOL is_end_page;
@end


