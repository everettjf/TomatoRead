////
////  iOSBlogReaderTests.m
////  iOSBlogReaderTests
////
////  Created by everettjf on 16/4/7.
////  Copyright © 2016年 everettjf. All rights reserved.
////
//
//#import <XCTest/XCTest.h>
//#import "RestApi.h"
//
//@interface RestApiTests : XCTestCase
//
//@end
//
//@implementation RestApiTests
//
//- (void)setUp {
//    [super setUp];
//    // Put setup code here. This method is called before the invocation of each test method in the class.
//}
//
//- (void)tearDown {
//    // Put teardown code here. This method is called after the invocation of each test method in the class.
//    [super tearDown];
//}
//
//- (void)testQueryDomainList {
//    // This is an example of a functional test case.
//    // Use XCTAssert and related functions to verify your tests produce the correct results.
//    XCTestExpectation *expectation = [self expectationWithDescription:@"query domain list"];
//    
//    [[RestApi api]queryDomainList:^(RestDomainListModel *model, NSError *error) {
//        XCTAssert(!error);
//        XCTAssert(model.results.count > 0);
//        
//        NSLog(@">>>>>>>>>>>> model results count = %@", @(model.results.count));
//        for (RestDomainModel *domain in model.results) {
//            NSLog(@"domain (%@): %@",@(domain.oid), domain.name);
//            NSLog(@"    aspect count  = %@", @(domain.aspect_set.count));
//            
//            for (RestAspectModel *aspect in domain.aspect_set) {
//                NSLog(@"+++ aspect (%@): %@",@(aspect.oid), aspect.name);
//            }
//        }
//        
//        [expectation fulfill];
//    }];
//    
//    [self waitForExpectationsWithTimeout:10 handler:nil];
//}
//
//- (void)testQueryFeedList{
//    XCTestExpectation *expectation = [self expectationWithDescription:@"query feed list"];
//    
//    [[RestApi api]queryFeedList:^(RestLinkListModel *model, NSError *error) {
//        XCTAssert(!error);
//        XCTAssert(model.results.count > 0);
//        NSLog(@">>>>>>>>>>>>> feed results = %@",@(model.results.count));
//        NSLog(@"next=%@", model.next);
//        NSLog(@"previous=%@", model.previous);
//        
//        for (RestLinkModel *link in model.results) {
//            XCTAssert(link.feed_url && ![link.feed_url isEqualToString:@""]);
//            NSLog(@"+++ link : %@ ,feed= %@", link.name, link.feed_url);
//        }
//        
//        [expectation fulfill];
//    } url:nil];
//    [self waitForExpectationsWithTimeout:10 handler:nil];
//}
//
//- (void)testQueryLinkList{
//    XCTestExpectation *expectation = [self expectationWithDescription:@"query link list"];
//    
//    [[RestApi api]queryLinkList:1 complete:^(RestLinkListModel *model, NSError *error) {
//        XCTAssert(!error);
//        XCTAssert(model.results.count > 0);
//        NSLog(@">>>>>>>>>>>>> link results = %@",@(model.results.count));
//        NSLog(@"next=%@", model.next);
//        NSLog(@"previous=%@", model.previous);
//        
//        for (RestLinkModel *link in model.results) {
//            XCTAssert(link.url && ![link.url isEqualToString:@""]);
//            NSLog(@"+++ link : %@ ,url= %@", link.name, link.url);
//        }
//        
//        if(model.next){
//            [[RestApi api]queryLinkList:1 complete:^(RestLinkListModel *model, NSError *error) {
//                NSLog(@">>>>>>>>>>>>> next link results = %@",@(model.results.count));
//                NSLog(@"next=%@", model.next);
//                NSLog(@"previous=%@", model.previous);
//                
//                for (RestLinkModel *link in model.results) {
//                    XCTAssert(link.url && ![link.url isEqualToString:@""]);
//                    NSLog(@"+++ link : %@ ,url= %@", link.name, link.url);
//                }
//                
//                [expectation fulfill];
//            } url:model.next];
//        }else{
//            [expectation fulfill];
//        }
//    } url:nil];
//    [self waitForExpectationsWithTimeout:10 handler:nil];
//}
//
//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}
//
//@end
