//
//  DW_Interstitial.h
//  DeleteWatermark
//
//  Created by 李若澜 on 2019/6/12.
//  Copyright © 2019 LengFeng9. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DW_ADSTypeDefine.h"
#import "DW_FullScreenAdsProtocol.h"
#import <InMobiSDK/InMobiSDK.h>
#import <GoogleMobileAds/GoogleMobileAds.h>
#import <UnityAds/UnityAds.h>
NS_ASSUME_NONNULL_BEGIN

@interface DW_Interstitial : NSObject

/**
 代理
 */
@property (nonatomic, weak) id <DW_FullScreenAdsProtocol> delegate;

/**
 初始化插页式广告

 @param adsPlatformType 平台类型
 @param adsId 广告id
 @param rootController 即将离开的Controller
 @param delegate 代理
 @return 实列对象
 */
- (instancetype)initWithAdsPlatformType:(ADSPlatformType)adsPlatformType
                                  adsId:(NSString *)adsId
                         rootController:(UIViewController *)rootController delegate:(id<DW_FullScreenAdsProtocol>)delegate;

/**
 加载广告
 */
- (void)loadAds;

/**
 展示插页式广告
 */
- (void)showInterstitialAdsFromController:(UIViewController *)controller;



@end

NS_ASSUME_NONNULL_END
