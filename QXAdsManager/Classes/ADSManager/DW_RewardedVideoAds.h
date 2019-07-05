//
//  DW_RewardedVideoAds.h
//  DeleteWatermark
//
//  Created by 李若澜 on 2019/6/12.
//  Copyright © 2019 LengFeng9. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DW_ADSTypeDefine.h"
#import "DW_RewardedVideoProtocol.h"
#import <InMobiSDK/InMobiSDK.h>
#import <GoogleMobileAds/GoogleMobileAds.h>
#import <UnityAds/UnityAds.h>
NS_ASSUME_NONNULL_BEGIN

@interface DW_RewardedVideoAds : NSObject

typedef void(^FinishWatchVideoBlock)(void);

@property (nonatomic, copy) FinishWatchVideoBlock finishWatchVideoBlock;

/**
 代理
 */
@property (nonatomic, weak) id <DW_RewardedVideoProtocol> delegate;

/**
 初始化激励式广告
 
 @param adsPlatformType 平台类型
 @param adsId 广告id
 @param rootController 即将离开的Controller
 @param delegate 代理
 @return 实列对象
 */
- (instancetype)initWithAdsPlatformType:(ADSPlatformType)adsPlatformType
                                  adsId:(NSString *)adsId
                         rootController:(UIViewController *)rootController delegate:(id<DW_RewardedVideoProtocol>)delegate
                  finishWatchVideoBlock:(void (^)(void))finishWatchVideoBlock;

/**
 加载广告
 */
- (void)loadAds;

/**
 展示激励式广告
 */
- (void)showRewardedVideoAdsFromController:(UIViewController *)controller;

@end

NS_ASSUME_NONNULL_END
