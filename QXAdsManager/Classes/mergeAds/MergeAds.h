//
//  MergeAds.h
//  DeleteWatermark
//
//  Created by 李若澜 on 2019/6/27.
//  Copyright © 2019 LengFeng9. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DW_ADSTypeDefine.h"
#import "DW_MergeAdsProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MergeAds : NSObject

@property (nonatomic, weak) id <DW_MergeAdsProtocol> delegate;


/**
 初始化

 @param adsPlatformType 平台类型
 @param adsType 广告类型
 @param adsId 广告id
 @param rootController 根试图
 @param delegate 代理
 @return 实例
 */
- (instancetype)initWithAdsPlatformType:(ADSPlatformType)adsPlatformType
                                AdsType:(DWAdsType)adsType
                                  adsId:(NSString *)adsId
                         rootController:(UIViewController *)rootController
                               delegate:(id<DW_MergeAdsProtocol>)delegate;


/**
 加载广告
 */
- (void)loadAds;


/**
 展示广告

 @param controller 根视图
 */
- (void)showInterstitialAdsFromController:(UIViewController *)controller;

@end

NS_ASSUME_NONNULL_END
