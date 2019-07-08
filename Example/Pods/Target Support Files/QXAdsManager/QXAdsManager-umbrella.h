#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "DW_ADS.h"
#import "DW_ADSManager.h"
#import "DW_AdsPlatformsInfo.h"
#import "DW_ADSRegister.h"
#import "DW_ADSTypeDefine.h"
#import "DW_BannerAdsProtocol.h"
#import "DW_BannerView.h"
#import "DW_FullScreenAdsProtocol.h"
#import "DW_Interstitial.h"
#import "DW_RewardedVideoAds.h"
#import "DW_RewardedVideoProtocol.h"
#import "DW_Singleton.h"
#import "DW_SplashAds.h"
#import "DW_SplashAdsProtocol.h"
#import "NativeAdsView.h"
#import "DW_NativeInterstitialAds.h"
#import "DW_NativeInterstitialViewController.h"
#import "DW_NativeProtocol.h"
#import "SplashPlaceholderView.h"
#import "GDTHybridAd.h"
#import "GDTLogoView.h"
#import "GDTMediaView.h"
#import "GDTMobBannerView.h"
#import "GDTMobInterstitial.h"
#import "GDTNativeAd.h"
#import "GDTNativeExpressAd.h"
#import "GDTNativeExpressAdView.h"
#import "GDTRewardVideoAd.h"
#import "GDTSDKConfig.h"
#import "GDTSDKDefines.h"
#import "GDTSplashAd.h"
#import "GDTUnifiedBannerView.h"
#import "GDTUnifiedInterstitialAd.h"
#import "GDTUnifiedNativeAd.h"
#import "GDTUnifiedNativeAdDataObject.h"
#import "GDTUnifiedNativeAdView.h"
#import "DW_MergeAdsProtocol.h"
#import "MergeAds.h"

FOUNDATION_EXPORT double QXAdsManagerVersionNumber;
FOUNDATION_EXPORT const unsigned char QXAdsManagerVersionString[];

