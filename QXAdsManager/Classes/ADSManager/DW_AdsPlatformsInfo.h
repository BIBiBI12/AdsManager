//
//  DW_IdConfig.h
//  DeleteWatermark
//
//  Created by 李若澜 on 2019/6/14.
//  Copyright © 2019 LengFeng9. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DW_Singleton.h"

NS_ASSUME_NONNULL_BEGIN

@interface DW_AdsPlatformsInfo : NSObject
//<NSCoding, NSCopying>

DW_SingLetonH(Info)


/**
 广点通AppId
 */
@property (nonatomic,copy) NSString *gdtAppId;

/**
 UnityAppId
 */
@property (nonatomic,copy) NSString *unityAppId;

/**
 谷歌AppId
 */
@property (nonatomic,copy) NSString *googleAppId;

/**
 谷歌奖励视频广告id
 */
@property (nonatomic,copy) NSString *googleRewardVideoAdsId;

/**
 inMobiAppId
 */
@property (nonatomic,copy) NSString *inMobiAppId;

/**
 百度AppId
 */
@property (nonatomic,copy) NSString *baiduAppId;

/**
 穿山甲AppId （字节跳动）
 */
@property (nonatomic,copy) NSString *buAppId;

/**
 便利初始化各广告平台

 @param gdtAppid 广点通Id
 @param unityAppId unityAppId
 @param googleAppId 谷歌 AppId
 @param inMobiAppId inMobiAppId
 @param baiduAppId 百度AppId
 @param buAppId 百度AppId


 @return 实列对象
 */
- (instancetype)initWithGdtAppId:(NSString *)gdtAppid
                      unityAppId:(NSString *)unityAppId
                     googleAppId:(NSString *)googleAppId
                     inMobiAppId:(NSString *)inMobiAppId
                      baiduAppId:(NSString *)baiduAppId
                         BuAppId:(NSString *)buAppId;

/**
 注册各平台广告
 */
- (void)registerAds;


@end

NS_ASSUME_NONNULL_END
