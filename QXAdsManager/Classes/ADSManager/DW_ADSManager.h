//
//  DW_ADSTool.h
//  DeleteWatermark
//
//  Created by 李若澜 on 2019/6/11.
//  Copyright © 2019 LengFeng9. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "DW_ADSAccountsInfo.h"
#import "DW_ADSRegister.h"

NS_ASSUME_NONNULL_BEGIN

@interface DW_ADSManager : NSObject

/**
 DWADS 平台注册方法
 
 eg:
 
 [DW_ADSManager registPlatforms:^(DW_ADSRegister * _Nonnull platformsRegister) {
 //注册inMobi广告
 [platformsRegister setupInmobiWithAccountID:InMobiAccountId];
 //注册谷歌广告 官方建议提前 预加载视频广告
 [platformsRegister setupGoogleAdsAndBeforLoadVideo:NO rewardVideoId:@"ca-app-pub-3940256099942544/171248531"];
 //注册unity广告
 [platformsRegister setupUnityWithUpid:@"3183624" delegate:nil testMode:YES];
 }];
 
 @param importHandler 用于设置各平台注册信息
 */
+ (void)registPlatforms:(void(^)(DW_ADSRegister *platformsRegister))importHandler;

/**
 关闭广告
 */
+ (void)closeAds;

/**
 打开广告
 */
+ (void)openAds;

/**
 获取广告状态

 @return 广告状态
 */
+ (BOOL)getAdsStatus;

@end

NS_ASSUME_NONNULL_END
