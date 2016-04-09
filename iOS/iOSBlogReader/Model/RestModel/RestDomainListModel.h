//
//  RestDomainListModel.h
//  iOSBlogReader
//
//  Created by everettjf on 16/4/8.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RestAspectModel : NSObject
@property (assign,nonatomic) NSUInteger oid;
@property (strong,nonatomic) NSString *name;
@end

@interface RestDomainModel : NSObject
@property (assign,nonatomic) NSUInteger oid;
@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSArray<RestAspectModel*> *aspect_set;
@end

@interface RestDomainListModel : NSObject
@property (assign,nonatomic) NSUInteger count;
@property (strong,nonatomic) NSString *next;
@property (strong,nonatomic) NSString *previous;
@property (strong,nonatomic) NSArray<RestDomainModel*> *results;
@end
