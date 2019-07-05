//
//  DW_SplashAdsProtocol.h
//  AdsDemo
//
//  Created by 李若澜 on 2019/6/19.
//  Copyright © 2019 小众. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DW_SplashAdsProtocol <NSObject>

/**
 开屏广告加载完成
 
 */
- (void)splashAdDidLoad;

/**
 开屏加载失败

 @param error 失败原因
 */
- (void)splashAdDidFailWithError:(NSError *)error;

/**
  开屏广告点击关闭
 */
- (void)splashAdDidClose;



@end

NS_ASSUME_NONNULL_END
