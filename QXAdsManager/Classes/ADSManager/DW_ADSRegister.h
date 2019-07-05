//
//  DW_ADSRegister.h
//  DeleteWatermark
//
//  Created by 李若澜 on 2019/6/12.
//  Copyright © 2019 LengFeng9. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UnityAds/UnityAds.h>

NS_ASSUME_NONNULL_BEGIN

@interface DW_ADSRegister : NSObject

/**
 注册Inmobt广告 consentdict
 
 @param accountId 账号id
 */
- (void)setupInmobiWithAccountID:(NSString *)accountId;

/**
 注册谷歌广告
 ⚠️ 1、账号id在info.plist 中配置
        格式如下：
        key: GADApplicationIdentifier    value:xxxxxxxxxxxxxxxxxx
 ⚠️ 2、谷歌官方建议 提前加载激励视频，这里依个人情况而定

 @param beforLoad 是否提前加载激励视频
 @param rewardVideoId 激励视频id
 */
- (void)setupGoogleAdsAndBeforLoadVideo:(BOOL)beforLoad
                          rewardVideoId:(NSString *)rewardVideoId;

/**
 初始化Unity广告

 @param upid 平台id
 @param delegate 代理
 @param testMode 是否为测试模式
 */
- (void)setupUnityWithUpid:(NSString *)upid
                  delegate:(nullable id<UnityAdsDelegate>)delegate
                  testMode:(BOOL)testMode;



/**
 设置穿山甲AppId

 @param appId AppID
 */
- (void)setupBuAdsWithAppId:(NSString *)appId;

@end

NS_ASSUME_NONNULL_END
