//
//  DW_NativeInterstitialViewController.h
//  DeleteWatermark
//
//  Created by 李若澜 on 2019/6/24.
//  Copyright © 2019 LengFeng9. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BUAdSDK/BUNativeAd.h>
#import <BaiduMobAdSDK/BaiduMobAdNativeAdObject.h>
#import "GDTNativeAd.h"
#import <InMobiSDK/InMobiSDK.h>
#import "DW_ADSTypeDefine.h"


NS_ASSUME_NONNULL_BEGIN

@protocol DW_NativeViewControllerProtocol <NSObject>

@optional

/**
 广告变为可见
 */
- (void)nativeAdDidBecomeVisibleWithControlller:(UIViewController *)controller;

/**
 点击控件
 */
- (void)nativeAdDidClickWithView:(UIView *_Nullable)view platformType:(NativeAdsPlatformType)platformType;

@end

@interface DW_NativeInterstitialViewController : UIViewController

@property (nonatomic, strong) BUNativeAd *nativeAd;

@property (nonatomic, weak) id <DW_NativeViewControllerProtocol> delegate;

- (void)setVlaueWithBuNativeAd:(BUNativeAd *)nativeAd;

- (void)setValueWithBaiduNativeAd:(BaiduMobAdNativeAdObject *)nativeAd;

- (void)setValueWithGdtNativeAd:(GDTNativeAdData *)nativeAd;

- (void)setVlaueWithInmobiNativeAd:(IMNative *)nativeAd;

@end

NS_ASSUME_NONNULL_END
