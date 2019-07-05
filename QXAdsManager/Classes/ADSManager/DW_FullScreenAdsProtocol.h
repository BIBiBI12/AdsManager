//
//  DW_FullScreenAdsProtocol.h
//  DeleteWatermark
//
//  Created by 李若澜 on 2019/6/12.
//  Copyright © 2019 LengFeng9. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DW_FullScreenAdsProtocol <NSObject>

@optional
/**
 广告加载完成
 */
-(void)adsDidFinishLoading;

/**
 加载广告失败
 */
-(void)didFailToLoadWithError:(NSError*)error;

@end

NS_ASSUME_NONNULL_END
