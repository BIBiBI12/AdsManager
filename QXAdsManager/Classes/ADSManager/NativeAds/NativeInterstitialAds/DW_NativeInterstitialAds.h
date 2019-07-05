//
//  DW_NativeAds.h
//  DeleteWatermark
//
//  Created by 李若澜 on 2019/6/24.
//  Copyright © 2019 LengFeng9. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DW_ADSTypeDefine.h"
#import "DW_NativeProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface DW_NativeInterstitialAds : NSObject

/**
 代理
 */
@property (nonatomic, weak) id <DW_NativeProtocol> delegate;

/**
 初始化原生广告

 @param platformType 支持原生广告的平台类型
 @param adsId 广告id
 @param rootController  根视图
 @return 原生实列
 */
- (instancetype)initWithNativePlatform:(NativeAdsPlatformType)platformType
                                 adsId:(NSString *)adsId
                        rootController:(UIViewController *)rootController;

/**
 展示原生广告
 
 @param controller 根视图
 */
- (void)showNativeAdsFromController:(UIViewController *)controller;

/**
 加载广告
 */
- (void)loadAds;

@end

NS_ASSUME_NONNULL_END
