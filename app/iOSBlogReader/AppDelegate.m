//
//  AppDelegate.m
//  iOSBlogReader
//
//  Created by everettjf on 16/2/25.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#import "AppDelegate.h"
#import "FeedPostsViewController.h"
#import "FeedSourceViewController.h"
#import "DiscoverViewController.h"
#import "EENavigationController.h"
#import "EETabBarController.h"
#import "DataManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // CoreData
    [self _dataEngine];
    
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    // Window
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    FeedPostsViewController *feedPostsViewController = [[FeedPostsViewController alloc]init];
    EENavigationController *feedPostsNavigationController = [[EENavigationController alloc]initWithRootViewController:feedPostsViewController];
    feedPostsNavigationController.tabBarItem.title = @"博文";
    feedPostsNavigationController.tabBarItem.image = [UIImage imageNamed:@"tab_article"];
    feedPostsNavigationController.tabBarItem.selectedImage = [UIImage imageNamed:@"tab_article_selected"];
    
    FeedSourceViewController *feedSourceViewController = [[FeedSourceViewController alloc]init];
    EENavigationController *feedSourceNavigationController = [[EENavigationController alloc]initWithRootViewController:feedSourceViewController];
    feedSourceNavigationController.tabBarItem.title = @"订阅";
    feedSourceNavigationController.tabBarItem.image = [UIImage imageNamed:@"tab_rss"];
    feedSourceNavigationController.tabBarItem.selectedImage = [UIImage imageNamed:@"tab_rss_selected"];
    
    DiscoverViewController *discoverViewController = [[DiscoverViewController alloc]init];
    EENavigationController *discoverNavigationController = [[EENavigationController alloc]initWithRootViewController:discoverViewController];
    discoverNavigationController.tabBarItem.title = @"发现";
    discoverNavigationController.tabBarItem.image = [UIImage imageNamed:@"tab_discover"];
    discoverNavigationController.tabBarItem.selectedImage = [UIImage imageNamed:@"tab_discover_selected"];
    
    EETabBarController *tabBarController = [[EETabBarController alloc]init];
    tabBarController.viewControllers = @[feedPostsNavigationController,
                                         feedSourceNavigationController,
                                         discoverNavigationController,
                                         ];

    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    
}

- (void)_dataEngine{
    [DataManager manager];
}


- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    completionHandler(UIBackgroundFetchResultNewData);
}


@end
