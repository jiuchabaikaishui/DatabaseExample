//
//  AppDelegate.m
//  DatabaseExample
//
//  Created by apple on 17/2/6.
//  Copyright © 2017年 QSP. All rights reserved.
//

#import "AppDelegate.h"
#import "DatabaseViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:MainScreen_Bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    UIColor *normolColor = [UIColor grayColor];
    UIColor *selectedColor = [UIColor blackColor];
    DatabaseViewController *sqliteCtr = [[DatabaseViewController alloc] init];
    sqliteCtr.title = @"Sqlite";
    [sqliteCtr.tabBarItem setImage:[[ConFunc imageFromColor:Color_Random andSize:CGSizeMake(30, 30)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [sqliteCtr.tabBarItem setSelectedImage:[[ConFunc imageFromColor:Color_Random andSize:CGSizeMake(30, 30)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [sqliteCtr.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: normolColor} forState:UIControlStateNormal];
    [sqliteCtr.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: selectedColor} forState:UIControlStateSelected];
    UINavigationController *sqliteNavCtr = [[UINavigationController alloc] initWithRootViewController:sqliteCtr];
    
//    DatabaseViewController *fmdbCtr = [[DatabaseViewController alloc] init];
//    fmdbCtr.title = @"FMDB";
//    [fmdbCtr.tabBarItem setImage:[[ConFunc imageFromColor:Color_Random andSize:CGSizeMake(30, 30)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    [fmdbCtr.tabBarItem setSelectedImage:[[ConFunc imageFromColor:Color_Random andSize:CGSizeMake(30, 30)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    [fmdbCtr.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: normolColor} forState:UIControlStateNormal];
//    [fmdbCtr.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: selectedColor} forState:UIControlStateSelected];
//    UINavigationController *fmdbNavCtr = [[UINavigationController alloc] initWithRootViewController:fmdbCtr];
//    
//    DatabaseViewController *fmdbQureCtr = [[DatabaseViewController alloc] init];
//    fmdbQureCtr.title = @"FMDBQure";
//    [fmdbQureCtr.tabBarItem setImage:[[ConFunc imageFromColor:Color_Random andSize:CGSizeMake(30, 30)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    [fmdbQureCtr.tabBarItem setSelectedImage:[[ConFunc imageFromColor:Color_Random andSize:CGSizeMake(30, 30)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    [fmdbQureCtr.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: normolColor} forState:UIControlStateNormal];
//    [fmdbQureCtr.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: selectedColor} forState:UIControlStateSelected];
//    UINavigationController *fmdbQureNavCtr = [[UINavigationController alloc] initWithRootViewController:fmdbQureCtr];
    
    UITabBarController *tabBarCtr = [[UITabBarController alloc] init];
    tabBarCtr.viewControllers = @[sqliteNavCtr];//, fmdbNavCtr, fmdbQureNavCtr
    
    self.window.rootViewController = tabBarCtr;
    
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
}

@end
