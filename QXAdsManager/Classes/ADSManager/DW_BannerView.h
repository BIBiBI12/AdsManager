//
//  DW_BannerView.h
//  DeleteWatermark
//
//  Created by 李若澜 on 2019/6/12.
//  Copyright © 2019 LengFeng9. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DW_ADSTypeDefine.h"
//#import "DW_BannerProtocol.h"
#import <InMobiSDK/InMobiSDK.h>
#import <GoogleMobileAds/GoogleMobileAds.h>
#import <UnityAds/UnityAds.h>
#import "DW_BannerAdsProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface DW_BannerView : UIView

/**
 广告id
 */
@property (nonatomic,copy) NSString *adsId;

/**
 代理
 */
@property (nonatomic, weak) id <DW_BannerAdsProtocol> delegate;

#pragma MethodList
/**
 初始化横幅广告

 @param adsPlatformType 广告平台类型
 @param adsId 广告id
 @param rootController 展示的Controller
 @return 横幅广告实列
 */
- (instancetype)initWithAdsPlatformType:(ADSPlatformType)adsPlatformType
                                  adsId:(NSString *)adsId
                         rootController:(UIViewController *)rootController;


/**
 加载广告
 */
- (void)loadAds;

@end

NS_ASSUME_NONNULL_END
