//
//  MergeAds.m
//  DeleteWatermark
//
//  Created by 李若澜 on 2019/6/27.
//  Copyright © 2019 LengFeng9. All rights reserved.
//

#import "MergeAds.h"
#import "DW_Interstitial.h"
#import "DW_RewardedVideoAds.h"
#import "DW_NativeInterstitialAds.h"


@interface MergeAds()<DW_FullScreenAdsProtocol,DW_RewardedVideoProtocol>
@property (nonatomic, strong) DW_Interstitial *interstitialAd;
@property (nonatomic, strong) DW_RewardedVideoAds *rewardedVideoAds;
@property (nonatomic, strong) DW_NativeInterstitialAds *nativeAds;
@property (nonatomic, strong) NSString *adsId;
@property (nonatomic, assign) ADSPlatformType adsPlatformType;
@property (nonatomic, assign) DWAdsType adsType;
@property (nonatomic, weak) UIViewController *rootController;
@end

@implementation MergeAds

- (instancetype)initWithAdsPlatformType:(ADSPlatformType)adsPlatformType
                                AdsType:(DWAdsType)adsType
                                  adsId:(NSString *)adsId
                         rootController:(UIViewController *)rootController
                               delegate:(id<DW_MergeAdsProtocol>)delegate{
    self = [self init];
    if (self) {
        self.adsId = adsId;
        self.adsPlatformType = adsPlatformType;
        self.rootController = rootController;
        self.adsType = adsType;
        self.delegate = delegate;
    }
    return self;
}

- (void)loadAds{
    switch (self.adsType) {
        case DWInterstitialAdsype:{
            [self.interstitialAd loadAds];
        }
            break;
            
        case DWRewardedAdsype:{
            [self.rewardedVideoAds loadAds];
        }
            break;
            
        case DWNativeAdsype:{
            [self.nativeAds loadAds];
        }
            break;
            
        default:{
            if ([self.delegate respondsToSelector:@selector(didFailToLoadWithError:)]) {
                NSError *error = [NSError errorWithDomain:@"广告类型不支持，只支持插播/激励/原生" code:2 userInfo:nil];
                [self.delegate didFailToLoadWithError:error];
            }
        }
            break;
    }
}

- (void)showInterstitialAdsFromController:(UIViewController *)controller{
    switch (self.adsType) {
        case DWInterstitialAdsype:{
            [self.interstitialAd showInterstitialAdsFromController:self.rootController];
        }
            break;
            
        case DWRewardedAdsype:{
            [self.rewardedVideoAds showRewardedVideoAdsFromController:self.rootController];
        }
            break;
            
        case DWNativeAdsype:{
            [self.nativeAds showNativeAdsFromController:self.rootController];
        }
            break;
            
        default:{
            if ([self.delegate respondsToSelector:@selector(didFailToLoadWithError:)]) {
                NSError *error = [NSError errorWithDomain:@"广告类型不支持，只支持插播/激励/原生" code:2 userInfo:nil];
                [self.delegate didFailToLoadWithError:error];
            }
        }
            break;
    }
}


#pragma mark -- DW_FullScreenAdsProtocol
/**
 广告加载完成
 */
-(void)adsDidFinishLoading{
    if ([self.delegate respondsToSelector:@selector(adsDidFinishLoading)]) {
        [self.delegate adsDidFinishLoading];
    }
}

/**
 加载广告失败
 */
-(void)didFailToLoadWithError:(NSError*)error{
    if ([self.delegate respondsToSelector:@selector(didFailToLoadWithError:)]) {
        [self.delegate didFailToLoadWithError:error];
    }
}

#pragma mark -- DW_RewardedVideoProtocol
- (void)rewardBasedVideoAd{
    if ([self.delegate respondsToSelector:@selector(rewardedVideoAds)]) {
        [self.delegate rewardBasedVideoAd];
    }
}


#pragma mark -- lazy
- (DW_Interstitial *)interstitialAd{
    if (nil == _interstitialAd) {
        NSLog(@"加载插播广告  id: %@  平台类型: %@",self.adsId,@(self.adsPlatformType));
        _interstitialAd = [[DW_Interstitial alloc] initWithAdsPlatformType:self.adsPlatformType adsId:self.adsId rootController:self.rootController delegate:self];
    }
    return _interstitialAd;
}

- (DW_RewardedVideoAds *)rewardedVideoAds{
    if (nil == _rewardedVideoAds) {
        NSLog(@"加载激励广告  id: %@  平台类型: %@",self.adsId,@(self.adsPlatformType));
        _rewardedVideoAds = [[DW_RewardedVideoAds alloc] initWithAdsPlatformType:self.adsPlatformType adsId:self.adsId rootController:self.rootController delegate:self finishWatchVideoBlock:nil];
    }
    return _rewardedVideoAds;
}

- (DW_NativeInterstitialAds *)nativeAds{
    if (nil == _nativeAds) {
        NSLog(@"加载原生广告  id: %@  平台类型: %@",self.adsId,@(self.adsPlatformType));
        _nativeAds = [[DW_NativeInterstitialAds alloc] initWithNativePlatform:(NativeAdsPlatformType)self.adsPlatformType adsId:self.adsId rootController:self.rootController];
    }
    return _nativeAds;
}
@end
