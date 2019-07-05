//
//  NativeAdsView.h
//  DeleteWatermark
//
//  Created by 李若澜 on 2019/7/2.
//  Copyright © 2019 LengFeng9. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DW_NativeProtocol.h"
#import "DW_ADSTypeDefine.h"
NS_ASSUME_NONNULL_BEGIN

@interface NativeAdsView : UIView

/**
 代理
 */
@property (nonatomic, weak) id <DW_NativeProtocol> delegate;


/**
 初始化原生广告

 @param platformType 广告平台
 @param adsId 广告id
 @return 原生广告实列
 */
- (instancetype)initWithNativePlatform:(NativeAdsPlatformType)platformType
                                 adsId:(NSString *)adsId
                        rootController:(UIViewController *)rootController;

/**
 加载广告
 */
- (void)loadAds;
@end

NS_ASSUME_NONNULL_END
