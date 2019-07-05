//
//  DW_RewardedVideoProtocol.h
//  DeleteWatermark
//
//  Created by 李若澜 on 2019/6/12.
//  Copyright © 2019 LengFeng9. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DW_RewardedVideoAds;

NS_ASSUME_NONNULL_BEGIN

@protocol DW_RewardedVideoProtocol <NSObject>

@optional

/**
 看完了奖励视频
 
 TODO: 添加参数 将后台配置的奖励回传出去 
 */
- (void)finishWatchVideo:(DW_RewardedVideoAds *)rewardVideo;


/**
 广告加载完成
 */
-(void)adsDidFinishLoading;

/**
 加载广告失败
 */
-(void)didFailToLoadWithError:(NSError*)error;


/**
 关闭广告

 @param rewardVideo 实列
 */
- (void)rewardVideoAdDidClose:(DW_RewardedVideoAds *)rewardVideo;
@end

NS_ASSUME_NONNULL_END
