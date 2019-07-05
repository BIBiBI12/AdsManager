//
//  DW_ADSType.h
//  DeleteWatermark
//
//  Created by 李若澜 on 2019/6/12.
//  Copyright © 2019 LengFeng9. All rights reserved.
//

#ifndef DW_ADSType_h
#define DW_ADSType_h

/**
 * 平台类型
 */
typedef NS_ENUM(NSUInteger, ADSPlatformType) {
    /**
     * 未知
     */
    DWPlatformTypeUnknown          = 0,
    /**
     * 腾讯广点通
     */
    DWPlatformTypeGDT              = 1,
    /**
     * 百度
     */
    DWPlatformBaidu                = 2,
    /**
     * 穿山甲 （字节跳动）
     */
    DWPlatformBu                   = 3,
    /**
     * inMobi
     */
    DWPlatformTypeInMobi           = 4,
    /**
     * 谷歌
     */
    DWPlatformTypeGoogle           = 5,
    /**
     * unity
     */
    DWPlatformTypeUnity            = 6,
    
};


/**
 * 支持开屏广告 平台类型
 */
typedef NS_ENUM(NSUInteger, SplashADSPlatformType) {
    /**
     * 未知
     */
    DWSplashPlatformTypeUnknown          = 0,
    /**
     * 腾讯广点通
     */
    DWSplashPlatformTypeGDT              = 1,
    /**
     * 百度
     */
    DWSplashPlatformBaidu                = 2,
    /**
     * 穿山甲 （字节跳动）
     */
    DWSplashPlatformBu                  = 3,
};


/**
 支持原生广告 平台类型
 */
typedef NS_ENUM(NSUInteger, NativeAdsPlatformType) {
    /**
     * 未知
     */
    DWNativePlatformTypeUnknown          = 0,
    /**
     * 腾讯广点通
     */
    DWNativePlatformTypeGDT              = 1,
    /**
     * 百度
     */
    DWNativePlatformBaidu                = 2,
    /**
     * 穿山甲 （字节跳动）
     */
    DWNativePlatformBu                   = 3,
    /**
     * inMobi
     */
    DWNativePlatformInMobi               = 4,
};


/**
 * 所有广告类型
 */
typedef NS_ENUM(NSUInteger, DWAdsType) {
    /**
     * 未知
     */
    DWUnknownAdsType           = 0,
    /**
     * 横幅类型
     */
    DWBannerAdsype             = 1,
    /**
     * 插播类型
     */
    DWInterstitialAdsype       = 2,
    /**
     * 激励视频类型
     */
    DWRewardedAdsype           = 3,
    /**
     * 开屏广告类型
     */
    DWSplashAdsype             = 4,
    /**
     * 原生类型
     */
    DWNativeAdsype             = 5,
};


#endif /* DW_ADSType_h */
