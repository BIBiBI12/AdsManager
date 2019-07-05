//
//  DW_RewardedVideoAds.m
//  DeleteWatermark
//
//  Created by 李若澜 on 2019/6/12.
//  Copyright © 2019 LengFeng9. All rights reserved.
//

#import "DW_RewardedVideoAds.h"
#import "GDTRewardVideoAd.h"
#import "DW_AdsPlatformsInfo.h"
#import "BaiduMobAdSDK/BaiduMobAdRewardVideo.h"
#import "BaiduMobAdSDK/BaiduMobAdRewardVideoDelegate.h"
#import "BUAdSDK/BUAdSDK.h"
#import "DW_ADSManager.h"

@interface DW_RewardedVideoAds()<IMInterstitialDelegate,GADRewardBasedVideoAdDelegate,UnityAdsDelegate,
GDTRewardedVideoAdDelegate,BaiduMobAdRewardVideoDelegate,BURewardedVideoAdDelegate>
@property (nonatomic, strong) IMInterstitial *imInterstitial;            //inmobi广告
@property (nonatomic, strong) GDTRewardVideoAd *gdtRewardVideoAd;        //广点通
@property (nonatomic, strong) BaiduMobAdRewardVideo *baiduRewardVideoAd; //百度 激励广告
@property (nonatomic, strong) BURewardedVideoAd *buRewardVideoAd;        //穿山甲 激励广告
@property (nonatomic, strong) NSString *adsId;
@property (nonatomic, assign) ADSPlatformType adsPlatformType;
@property (nonatomic, weak) UIViewController *rootController;
@property (nonatomic, assign) BOOL unityAdsAlreayPlay;                  //unity 激励广告已经播放完毕
@end

@implementation DW_RewardedVideoAds

- (instancetype)initWithAdsPlatformType:(ADSPlatformType)adsPlatformType
                                  adsId:(NSString *)adsId
                         rootController:(UIViewController *)rootController delegate:(id<DW_RewardedVideoProtocol>)delegate
                  finishWatchVideoBlock:(void (^)(void))finishWatchVideoBlock{
    self = [self init];
    if (self) {
        self.adsId = adsId;
        self.adsPlatformType = adsPlatformType;
        self.rootController = rootController;
        self.delegate = delegate;
        self.finishWatchVideoBlock = finishWatchVideoBlock;
    }
    return self;
}

- (void)loadAds{
    if ([DW_ADSManager getAdsStatus]) {
        return;
    }
    switch (self.adsPlatformType) {
            case DWPlatformTypeInMobi:{
                [self.imInterstitial load];
            }
            break;
            
            case DWPlatformTypeGoogle:{
                NSLog(@"开始加载谷歌广告: %@",self.adsId);
                [GADRewardBasedVideoAd sharedInstance].delegate = self;
                [[GADRewardBasedVideoAd sharedInstance] loadRequest:[GADRequest request]
                                                       withAdUnitID:self.adsId];
            }
            
            break;
            
            case DWPlatformTypeGDT:{
                [self.gdtRewardVideoAd loadAd];
            }
            break;
            
            case DWPlatformTypeUnity:{
                if ([UnityAds isReady:self.adsId]) {
                    [UnityAds addDelegate:self];
                    if ([self.delegate respondsToSelector:@selector(adsDidFinishLoading)]) {
                        [self.delegate adsDidFinishLoading];
                    }
                }else{
                    [UnityAds initialize:[DW_AdsPlatformsInfo shareInfo].unityAppId delegate:self testMode:YES];
                }
            }
            break;
            
            case DWPlatformBaidu:{
                [self.baiduRewardVideoAd load];
            }
            break;
            
            case DWPlatformBu:{
                [self.buRewardVideoAd loadAdData];
            }
            break;
            
        default:
            break;
    }
}

- (void)showRewardedVideoAdsFromController:(UIViewController *)controller{
    if ([DW_ADSManager getAdsStatus]) {
        return;
    }
    switch (self.adsPlatformType) {
            case DWPlatformTypeInMobi:{
                [self.imInterstitial showFromViewController:controller withAnimation:kIMInterstitialAnimationTypeFlipHorizontal];
            }
            break;
            
            case DWPlatformTypeGoogle:{
                if ([[GADRewardBasedVideoAd sharedInstance] isReady]) {
                    [[GADRewardBasedVideoAd sharedInstance] presentFromRootViewController:controller];
                }
            }
            
            break;
            
            case DWPlatformTypeGDT:{
                [self.gdtRewardVideoAd showAdFromRootViewController:controller];
            }
            break;
            
            case DWPlatformTypeUnity:{
                if ([UnityAds isReady:self.adsId]) {
                    [UnityAds show:controller placementId:self.adsId];
                }
            }
            break;
            
            case DWPlatformBaidu:{
                if(self.baiduRewardVideoAd.isReady){
                    [self.baiduRewardVideoAd showFromViewController:controller];
                }
            }
            break;
            
            case DWPlatformBu:{
                if (self.buRewardVideoAd.isAdValid) {
                    [self.buRewardVideoAd showAdFromRootViewController:controller];
                }
            }
            
        default:
            break;
    }
}

#pragma mark -- IMInterstitialDelegate inMobi
//加载广告成功
-(void)interstitialDidFinishLoading:(IMInterstitial*)interstitial{
    if ([self.delegate respondsToSelector:@selector(adsDidFinishLoading)]) {
        [self.delegate adsDidFinishLoading];
    }
}

//加载广告失败
-(void)interstitial:(IMInterstitial*)interstitial didFailToLoadWithError:(IMRequestStatus *)error{
    if ([self.delegate respondsToSelector:@selector(didFailToLoadWithError:)]) {
        [self.delegate didFailToLoadWithError:error];
    }
}

//完成了奖励广告
-(void)interstitial:(IMInterstitial*)interstitial rewardActionCompletedWithRewards:(NSDictionary*)rewards{
    if ([self.delegate respondsToSelector:@selector(finishWatchVideo:)]) {
        [self.delegate finishWatchVideo:self];
    }
}

//关闭广告
-(void)interstitialDidDismiss:(IMInterstitial*)interstitial{
    if ([self.delegate respondsToSelector:@selector(rewardVideoAdDidClose:)]) {
        [self.delegate rewardVideoAdDidClose:self];
    }
}

#pragma mark -- GADRewardBasedVideoAdDelegate 谷歌
//加载广告成功
- (void)rewardBasedVideoAdDidReceiveAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd{
    if ([self.delegate respondsToSelector:@selector(adsDidFinishLoading)]) {
        [self.delegate adsDidFinishLoading];
    }
}

//加载广告失败
- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
    didFailToLoadWithError:(NSError *)error{
    if ([self.delegate respondsToSelector:@selector(didFailToLoadWithError:)]) {
        [self.delegate didFailToLoadWithError:error];
    }
}

//看完广告了
- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd
   didRewardUserWithReward:(GADAdReward *)reward{
    if (self.finishWatchVideoBlock) {
        self.finishWatchVideoBlock();
    }
    if ([self.delegate respondsToSelector:@selector(finishWatchVideo:)]) {
        [self.delegate finishWatchVideo:self];
    }
}

//关闭广告
- (void)rewardBasedVideoAdDidClose:(GADRewardBasedVideoAd *)rewardBasedVideoAd{
    if ([self.delegate respondsToSelector:@selector(rewardVideoAdDidClose:)]) {
        [self.delegate rewardVideoAdDidClose:self];
    }
}

#pragma mark -- UnityAdsDelegate
//加载广告成功
- (void)unityAdsReady:(NSString *)placementId{
    NSLog(@"placementId: %@",placementId);
    if (![placementId isEqualToString:self.adsId]) {
        return;
    }
    if (self.unityAdsAlreayPlay) {
        return;
    }
    NSLog(@"unity 加载奖励广告完成");
    if ([self.delegate respondsToSelector:@selector(adsDidFinishLoading)]) {
        [self.delegate adsDidFinishLoading];
    }
}

//加载广告失败
- (void)unityAdsDidError:(UnityAdsError)error withMessage:(NSString *)message{
    if ([self.delegate respondsToSelector:@selector(didFailToLoadWithError:)]) {
        NSError *customError = [[NSError alloc] initWithDomain:message code:error userInfo:nil];
        [self.delegate didFailToLoadWithError:customError];
    }
}

//完成奖励视频
- (void)unityAdsDidFinish:(NSString *)placementId
          withFinishState:(UnityAdsFinishState)state {
    // Conditional logic dependent on whether the player finished the ad:
    if ([self.adsId isEqualToString:placementId]) {
        if (state == kUnityAdsFinishStateCompleted) {
            if ([self.delegate respondsToSelector:@selector(finishWatchVideo:)]) {
                [self.delegate finishWatchVideo:self];
            }
            if (self.finishWatchVideoBlock) {
                self.finishWatchVideoBlock();
            }
            self.unityAdsAlreayPlay = YES;
        } else if (state == kUnityAdsFinishStateSkipped) {
            
        } else if (state == kUnityAdsFinishStateError) {
           
        }
    }
}

#pragma mark -- GDTRewardedVideoAdDelegate 广点通
//加载广告成功
- (void)gdt_rewardVideoAdDidLoad:(GDTRewardVideoAd *)rewardedVideoAd{
    if ([self.delegate respondsToSelector:@selector(adsDidFinishLoading)]) {
        [self.delegate adsDidFinishLoading];
    }
}

//达到奖励条件
- (void)gdt_rewardVideoAdDidPlayFinish:(GDTRewardVideoAd *)rewardedVideoAd{
    if ([self.delegate respondsToSelector:@selector(finishWatchVideo:)]) {
        [self.delegate finishWatchVideo:self];
    }
    if (self.finishWatchVideoBlock) {
        self.finishWatchVideoBlock();
    }
}

//关闭视频
- (void)gdt_rewardVideoAdDidClose:(GDTRewardVideoAd *)rewardedVideoAd{
    if ([self.delegate respondsToSelector:@selector(rewardVideoAdDidClose:)]) {
        [self.delegate rewardVideoAdDidClose:self];
    }
}

#pragma mark -- BaiduMobAdRewardVideoDelegate
/**
 *  视频缓存成功
 */
- (void)rewardedVideoAdLoaded:(BaiduMobAdRewardVideo *)video{
    if ([self.delegate respondsToSelector:@selector(adsDidFinishLoading)]) {
        [self.delegate adsDidFinishLoading];
    }
}

/**
 *  视频缓存失败
 */
- (void)rewardedVideoAdLoadFailed:(BaiduMobAdRewardVideo *)video withError:(BaiduMobFailReason)reason{
    if ([self.delegate respondsToSelector:@selector(didFailToLoadWithError:)]) {
        NSString *message = @"";
        if (reason == BaiduMobFailReason_NOAD) {
            message = @"没有推广返回";
        }else if(reason == BaiduMobFailReason_EXCEPTION){
            message = @"网络或其它异常";
        }else{
            message = @"广告尺寸或元素异常，不显示广告";
        }
        NSError *customError = [[NSError alloc] initWithDomain:message code:nil userInfo:nil];
        [self.delegate didFailToLoadWithError:customError];
    }
}

/**
 完成播放

 @param video 视频对象
 */
- (void)rewardedVideoAdDidPlayFinish:(BaiduMobAdRewardVideo *)video{
    if ([self.delegate respondsToSelector:@selector(finishWatchVideo:)]) {
        [self.delegate finishWatchVideo:self];
    }
    if (self.finishWatchVideoBlock) {
        self.finishWatchVideoBlock();
    }
}

//点击关闭视频
- (void)rewardedVideoAdDidClose:(BaiduMobAdRewardVideo *)video withPlayingProgress:(CGFloat)progress{
    if ([self.delegate respondsToSelector:@selector(rewardVideoAdDidClose:)]) {
        [self.delegate rewardVideoAdDidClose:self];
    }
}

#pragma mark -- BURewardedVideoAdDelegate
//视频加载完成
- (void)rewardedVideoAdDidLoad:(BURewardedVideoAd *)rewardedVideoAd{
    if ([self.delegate respondsToSelector:@selector(adsDidFinishLoading)]) {
        [self.delegate adsDidFinishLoading];
    }
}

//视频加载失败
- (void)rewardedVideoAd:(BURewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error{
    if ([self.delegate respondsToSelector:@selector(didFailToLoadWithError:)]) {
        [self.delegate didFailToLoadWithError:error];
    }
}

- (void)rewardedVideoAdDidPlayFinish:(BURewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error{
    if (error) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(finishWatchVideo:)]) {
        [self.delegate finishWatchVideo:self];
    }
}

//点击关闭视频
- (void)rewardedVideoAdDidClose:(BURewardedVideoAd *)rewardedVideoAd{
    if ([self.delegate respondsToSelector:@selector(rewardVideoAdDidClose:)]) {
        [self.delegate rewardVideoAdDidClose:self];
    }
}


#pragma mark -- lazy
- (IMInterstitial *)imInterstitial{
    if (nil == _imInterstitial) {
        _imInterstitial = [[IMInterstitial alloc] initWithPlacementId:[self.adsId integerValue] delegate:self];
    }
    return _imInterstitial;
}

- (GDTRewardVideoAd *)gdtRewardVideoAd{
    if (nil == _gdtRewardVideoAd) {
        _gdtRewardVideoAd = [[GDTRewardVideoAd alloc] initWithAppId:[DW_AdsPlatformsInfo shareInfo].gdtAppId placementId:self.adsId];
        _gdtRewardVideoAd.delegate = self;
    }
    return _gdtRewardVideoAd;
}

- (BaiduMobAdRewardVideo *)baiduRewardVideoAd{
    if (nil == _baiduRewardVideoAd) {
        _baiduRewardVideoAd = [[BaiduMobAdRewardVideo alloc] init];
        _baiduRewardVideoAd.delegate = self;
        _baiduRewardVideoAd.AdUnitTag = self.adsId;
        _baiduRewardVideoAd.publisherId = [DW_AdsPlatformsInfo shareInfo].baiduAppId;
    }
    return _baiduRewardVideoAd;
}

- (BURewardedVideoAd *)buRewardVideoAd{
    if (nil == _buRewardVideoAd) {
        BURewardedVideoModel *model = [[BURewardedVideoModel alloc] init];
        model.userId = @"123";
        model.isShowDownloadBar = YES;
        _buRewardVideoAd = [[BURewardedVideoAd alloc] initWithSlotID:self.adsId rewardedVideoModel:model];
        _buRewardVideoAd.delegate = self;
    }
    return _buRewardVideoAd;
}

@end
