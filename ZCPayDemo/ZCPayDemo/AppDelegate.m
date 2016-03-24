//
//  AppDelegate.m
//  ZCPayDemo
//
//  Created by zhangcheng on 16/3/23.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import "AppDelegate.h"
#import "ZCPaySDK.h"
@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
  return  [[ZCPaySDK shareManager]handleOpenURL:url];
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    //支付宝
    
    return [[ZCPaySDK shareManager]handleOpenURL:url];
    
}
//防止用户跳转支付宝,双击返回应用后,UI卡死情况
- (void)applicationDidBecomeActive:(UIApplication *)application {
        //取消回调,避免UI冲突
        [[ZCPaySDK shareManager]cancalAliPayBlock];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
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



- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
