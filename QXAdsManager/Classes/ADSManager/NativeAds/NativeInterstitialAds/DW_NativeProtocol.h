//
//  DW_NativeInterstitialProtocol.h
//  DeleteWatermark
//
//  Created by 李若澜 on 2019/6/24.
//  Copyright © 2019 LengFeng9. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DW_NativeProtocol <NSObject>

@optional
/**
 加载完成
 */
- (void)nativeAdDidLoad;

/**
 加载是失败

 @param error 失败原因
 */
- (void)nativeAdDidFailWithError:(NSError *_Nullable)error;

/**
 广告变为可见
 */
- (void)nativeAdDidBecomeVisible;

/**
 点击控件
 */
- (void)nativeAdDidClickWithView:(UIView *_Nullable)view;

@end

NS_ASSUME_NONNULL_END
