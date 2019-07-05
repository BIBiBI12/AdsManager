//
//  DW_BannerAdsProtocol.h
//  DeleteWatermark
//
//  Created by 李若澜 on 2019/6/18.
//  Copyright © 2019 LengFeng9. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DW_ADSTypeDefine.h"
//#import "DW_BannerView.h"
@class DW_BannerView;
NS_ASSUME_NONNULL_BEGIN

@protocol DW_BannerAdsProtocol <NSObject>

@optional

/**
 横幅广告加载完成

 @param platformType 广告平台
 */
- (void)bannerDidFinishLoad:(ADSPlatformType)platformType;


/**
 加载横幅广告失败

 @param banner 横幅广告
 @param error 错误原因
 */
-(void)banner:(DW_BannerView *)banner didFailToLoadWithError:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
