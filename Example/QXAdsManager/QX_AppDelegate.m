//
//  QX_AppDelegate.m
//  QXAdsManager
//
//  Created by me_zqx on 07/04/2019.
//  Copyright (c) 2019 me_zqx. All rights reserved.
//

#import "QX_AppDelegate.h"
#import "SplashPlaceholderView.h"


@interface QX_AppDelegate()<DW_SplashAdsProtocol>

@end

@implementation QX_AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self regAd];
    
    [self showSplashAds];
    
    return YES;
}

- (void)regAd{
     DW_AdsPlatformsInfo *platformInfo = [[DW_AdsPlatformsInfo alloc] initWithGdtAppId:@"1105344611" unityAppId:@"3183624" googleAppId:@"" inMobiAppId:@"9e2be5cb53e84caf861ce7528d7b8092" baiduAppId:@"ccb60059" BuAppId:@"5020701"];
    [platformInfo registerAds];
}

/**
 展示开屏广告
 广点通 测试id  9040714184494018
 穿山甲 测试id  820701707
 百度   测试id  2058492
 */
- (void)showSplashAds{
    SplashPlaceholderView *placeholderView = [[SplashPlaceholderView alloc] initWithLogoImage:[UIImage imageNamed:@"logo"] logoSize:CGSizeMake(50, 50)];
    placeholderView.backgroundColor = [UIColor whiteColor];
    
    self.splashAds = [[DW_SplashAds alloc] initWithAdsPlatformType:DWSplashPlatformBu adsId:@"820701707" window:self.window placeholder:placeholderView];
    self.splashAds.delegate = self;
    [self.splashAds loadAdAndShowInWindow:self.window];
}

#pragma mark -- DW_SplashAdsProtocol
- (void)splashAdDidLoad{
    NSLog(@"加载完成");
}

- (void)splashAdDidFailWithError:(NSError *)error{
    NSLog(@"加载穿山甲失败 原因: %@",error);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
