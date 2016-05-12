//
//  JSPatch.h
//  JSPatch SDK version 1.4
//
//  Created by bang on 15/7/28.
//  Copyright (c) 2015 bang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JPCallbackType){
    JPCallbackTypeUnknow        = 0,
    JPCallbackTypeRunScript     = 1,    //执行脚本
    JPCallbackTypeUpdate        = 2,    //脚本有更新
    JPCallbackTypeUpdateDone    = 3,    //已拉取新脚本
    JPCallbackTypeCondition     = 4,    //条件下发
    JPCallbackTypeGray          = 5,    //灰度下发
};

@interface JSPatch : NSObject

/*
 传入在平台申请的 appKey。会自动执行已下载到本地的 patch 脚本。
 建议在 -application:didFinishLaunchingWithOptions: 开头处调用
 */
+ (void)startWithAppKey:(NSString *)aAppKey;

/*
 与 JSPatch 平台后台同步，询问是否有 patch 更新，如果有更新会自动下载并执行
 */
+ (void)sync;

/*
 用于发布前测试脚本，调用后，会在当前项目的 bundle 里寻找 main.js 文件执行
 不能与 `+startWithAppKey:` 一起调用，测试完成后需要删除。
 */
+ (void)testScriptInBundle;

/*
 自定义log，使用方法：
 [JSPatch setLogger:^(NSString *msg) {
    //msg 是 JSPatch log 字符串，用你自定义的logger打出
 }];
 在 `+startWithAppKey:` 之前调用
 */
+ (void)setupLogger:(void (^)(NSString *))logger;

/*
 定义用户属性
 用于条件下发，例如: 
    [JSPatch setupUserData:@{@"userId": @"100867", @"location": @"guangdong"}];
 详见在线文档
 在 `+sync:` 之前调用
 */
+ (void)setupUserData:(NSDictionary *)userData;


/*
 事件回调
   type: 事件类型，详见 JPCallbackType 定义
   data: 回调数据
   error: 事件错误
 在 `+startWithAppKey:` 之前调用
 */
+ (void)setupCallback:(void (^)(JPCallbackType type, NSDictionary *data, NSError *error))callback;

/*
 自定义RSA key
 publicKey: 平台上传脚本时 privateKey 对应的 publicKey
 在 `+sync:` 之前调用，详见 JSPatch 平台文档
 */
+ (void)setupRSAPublicKey:(NSString *)publicKey;


/*
 进入开发模式
 平台下发补丁时选择开发预览模式，会只对调用了这个方法的客户端生效。
 在 `+sync:` 之前调用，建议在 #ifdef DEBUG 里调。
 */
+ (void)setupDevelopment;
@end