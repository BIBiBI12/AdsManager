//
//  DW_IdConfig.m
//  DeleteWatermark
//
//  Created by 李若澜 on 2019/6/14.
//  Copyright © 2019 LengFeng9. All rights reserved.
//

#import "DW_AdsPlatformsInfo.h"
#import "DW_ADSManager.h"

@implementation DW_AdsPlatformsInfo

DW_SingLetonM(Info)

- (instancetype)initWithGdtAppId:(NSString *)gdtAppid
                      unityAppId:(NSString *)unityAppId
                     googleAppId:(NSString *)googleAppId
                     inMobiAppId:(NSString *)inMobiAppId
                      baiduAppId:(NSString *)baiduAppId
                         BuAppId:(NSString *)buAppId{
    self = [self init];
    if (self) {
        _gdtAppId = gdtAppid;
        _unityAppId = unityAppId;
        _googleAppId = googleAppId;
        _inMobiAppId = inMobiAppId;
        _baiduAppId = baiduAppId;
        _buAppId = buAppId;
    }
    return self;
}

- (void)registerAds{
    [DW_ADSManager registPlatforms:^(DW_ADSRegister * _Nonnull platformsRegister) {
        //注册inMobi广告
        [platformsRegister setupInmobiWithAccountID:self.inMobiAppId];
        //注册谷歌广告 官方建议提前 预加载视频广告
        [platformsRegister setupGoogleAdsAndBeforLoadVideo:YES rewardVideoId:self.googleRewardVideoAdsId];
        //注册unity广告
        [platformsRegister setupUnityWithUpid:self.unityAppId delegate:nil testMode:YES];
        //注册穿山甲广告
         [platformsRegister setupBuAdsWithAppId:self.buAppId];
    }];
}

#pragma mark -- set
- (void)setInMobiAppId:(NSString *)inMobiAppId{
    _inMobiAppId = inMobiAppId;
    if (_inMobiAppId.length != 0) {
        //仅在更新id的时候重新注册 第一次赋值 建议统一在赋值完成后在registerAds中注册
        [[DW_ADSRegister new] setupInmobiWithAccountID:inMobiAppId];
    }
}

- (void)setUnityAppId:(NSString *)unityAppId{
    _unityAppId = unityAppId;
    if (_unityAppId.length != 0) {
        //仅在更新id的时候重新注册 第一次赋值 建议统一在赋值完成后在registerAds中注册
        [[DW_ADSRegister new] setupUnityWithUpid:unityAppId delegate:nil testMode:YES];
    }
}

- (void)setBuAppId:(NSString *)buAppId{
    _buAppId = buAppId;
    if (_buAppId.length != 0) {
        //仅在更新id的时候重新注册 第一次赋值 建议统一在赋值完成后在registerAds中注册
        [[DW_ADSRegister new] setupBuAdsWithAppId:buAppId];
    }
}
     
@end
