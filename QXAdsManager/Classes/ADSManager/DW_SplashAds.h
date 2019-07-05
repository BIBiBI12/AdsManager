//
//  DW_SplashAdsView.h
//  AdsDemo
//
//  Created by 李若澜 on 2019/6/19.
//  Copyright © 2019 小众. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DW_SplashAdsProtocol.h"
#import "DW_ADSTypeDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface DW_SplashAds : UIView

/**
 广告id
 */
@property (nonatomic,copy) NSString *adsId;

/**
 代理
 */
@property (nonatomic, weak) id <DW_SplashAdsProtocol> delegate;

/**
 初始化横幅广告
 
 @param adsPlatformType 开屏广告平台类型
 @param adsId 广告id
 @return 开屏广告实列
 */
- (instancetype)initWithAdsPlatformType:(SplashADSPlatformType)adsPlatformType
                                  adsId:(NSString *)adsId
                                 window:(UIWindow *)window;


/**
 加载开屏广告 并展示

 @param window 需要展示广告的window
 */
- (void)loadAdAndShowInWindow:(UIWindow *)window;

@end

NS_ASSUME_NONNULL_END
