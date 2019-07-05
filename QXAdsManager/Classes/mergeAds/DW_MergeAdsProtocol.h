//
//  DW_MergeAdsProtocol.h
//  DeleteWatermark
//
//  Created by 李若澜 on 2019/6/27.
//  Copyright © 2019 LengFeng9. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DW_MergeAdsProtocol <NSObject>
/**
 广告加载完成
 */
-(void)adsDidFinishLoading;

/**
 加载广告失败
 */
-(void)didFailToLoadWithError:(NSError*)error;


/**
 看完激励广告 只在广告类型为激励广告时才会调用
 */
- (void)rewardBasedVideoAd;

@end

NS_ASSUME_NONNULL_END
