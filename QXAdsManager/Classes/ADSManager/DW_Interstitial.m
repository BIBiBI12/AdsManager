//
//  DW_Interstitial.m
//  DeleteWatermark
//
//  Created by 李若澜 on 2019/6/12.
//  Copyright © 2019 LengFeng9. All rights reserved.
//

#import "DW_Interstitial.h"
#import <InMobiSDK/InMobiSDK.h>
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "GDTMobInterstitial.h"
#import "DW_AdsPlatformsInfo.h"
#import "BaiduMobAdSDK/BaiduMobAdInterstitial.h"
#import "BaiduMobAdSDK/BaiduMobAdInterstitialDelegate.h"
#import "BUAdSDK/BUAdSDK.h"
#import "DW_ADSManager.h"

@interface DW_Interstitial()<IMInterstitialDelegate,GADInterstitialDelegate,UnityAdsDelegate,GDTMobInterstitialDelegate,BaiduMobAdInterstitialDelegate,BUInterstitialAdDelegate>
@property (nonatomic, strong) GADInterstitial *googleInterstitial;      //谷歌广告
@property (nonatomic, strong) IMInterstitial *imInterstitial;           //inmobi广告
@property (nonatomic, strong) GDTMobInterstitial *gdtInterstitial;      //广点通广告
@property (nonatomic, strong) BaiduMobAdInterstitial *baiduInterstitial;//百度广告
@property (nonatomic, strong) BUInterstitialAd *buInterstitial;         //穿山甲广告
@property (nonatomic, strong) NSString *adsId;
@property (nonatomic, assign) ADSPlatformType adsPlatformType;
@property (nonatomic, weak) UIViewController *rootController;
@end

@implementation DW_Interstitial

- (instancetype)initWithAdsPlatformType:(ADSPlatformType)adsPlatformType
                                  adsId:(NSString *)adsId
                         rootController:(UIViewController *)rootController delegate:(id<DW_FullScreenAdsProtocol>)delegate{
    self = [self init];
    if (self) {
        self.adsId = adsId;
        self.adsPlatformType = adsPlatformType;
        self.rootController = rootController;
        self.delegate = delegate;
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
                [self.googleInterstitial loadRequest:[GADRequest request]];
            }
            
            break;
            
            case DWPlatformTypeGDT:{
                [self.gdtInterstitial loadAd];
            }
            break;
            
            case DWPlatformTypeUnity:{
                if ([UnityAds isReady:self.adsId]) {
                    if ([self.delegate respondsToSelector:@selector(adsDidFinishLoading)]) {
                        [self.delegate adsDidFinishLoading];
                    }
                }else{
                     [UnityAds initialize:[DW_AdsPlatformsInfo shareInfo].unityAppId delegate:self testMode:YES];
                }
            }
            break;
            
            case DWPlatformBaidu:{
                [self.baiduInterstitial load];
            }
            break;
            
            case DWPlatformBu:{
                [self.buInterstitial loadAdData];
            }
            break;
            
        default:
            break;
    }
}

- (void)showInterstitialAdsFromController:(UIViewController *)controller{
    if ([DW_ADSManager getAdsStatus]) {
        return;
    }
    switch (self.adsPlatformType) {
            case DWPlatformTypeInMobi:{
                
                [self.imInterstitial showFromViewController:controller withAnimation:kIMInterstitialAnimationTypeFlipHorizontal];
            }
            break;
            
            case DWPlatformTypeGoogle:{
                if (self.googleInterstitial.isReady) {
                    [self.googleInterstitial presentFromRootViewController:controller];
                }else{
                    NSLog(@"广告尚未准备好");
                }
                
            }
            
            break;
            
            case DWPlatformTypeGDT:{
                [self.gdtInterstitial presentFromRootViewController:controller];
            }
            break;
            
            case DWPlatformTypeUnity:{
                if ([UnityAds isReady:self.adsId]) {
                    [UnityAds show:controller placementId:self.adsId];
                }else{
                    NSLog(@"unity插屏广告尚未准备完毕");
                }
            }
            break;
            
            case DWPlatformBaidu:{
                if (self.baiduInterstitial.isReady) {
                    [self.baiduInterstitial presentFromRootViewController:controller];
                }
            }
            break;
            
            case DWPlatformBu:{
                if (self.buInterstitial.adValid) {
                    [self.buInterstitial showAdFromRootViewController:controller];
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

#pragma mark -- GADInterstitialDelegate 谷歌
//加载广告成功
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad{
    if ([self.delegate respondsToSelector:@selector(adsDidFinishLoading)]) {
        [self.delegate adsDidFinishLoading];
    }
}

//加载广告失败
- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error{
    if ([self.delegate respondsToSelector:@selector(didFailToLoadWithError:)]) {
        [self.delegate didFailToLoadWithError:error];
    }
}

#pragma mark -- UnityAdsDelegate
//加载广告成功
- (void)unityAdsReady:(NSString *)placementId{
    if (![placementId isEqualToString:self.adsId]) {
        return;
    }
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

#pragma mark -- GDTMobInterstitialDelegate
// 广告预加载成功回调
- (void)gdtInterstitialSuccessToLoadAd:(GDTMobInterstitial *)interstitial{
    if ([self.delegate respondsToSelector:@selector(adsDidFinishLoading)]) {
        [self.delegate adsDidFinishLoading];
    }
}

// 广告预加载失败回调
- (void)interstitialFailToLoadAd:(GDTMobInterstitial *)interstitial error:(NSError *)error{
    if ([self.delegate respondsToSelector:@selector(didFailToLoadWithError:)]) {
        [self.delegate didFailToLoadWithError:error];
    }
}

#pragma mark -- BaiduMobAdInterstitialDelegate
// 百度 appId
- (NSString *)publisherId{
    NSString *baiduAppId = [DW_AdsPlatformsInfo shareInfo].baiduAppId;
    return baiduAppId;
}

// 广告预加载成功
- (void)interstitialSuccessToLoadAd:(BaiduMobAdInterstitial *)interstitial{
    if ([self.delegate respondsToSelector:@selector(adsDidFinishLoading)]) {
        [self.delegate adsDidFinishLoading];
    }
}

//广告预加载失败
- (void)interstitialFailToLoadAd:(BaiduMobAdInterstitial *)interstitial{
    if ([self.delegate respondsToSelector:@selector(didFailToLoadWithError:)]) {
        NSError *customError = [[NSError alloc] initWithDomain:@"加载百度插播式广告失败" code:nil userInfo:nil];
        [self.delegate didFailToLoadWithError:customError];
    }
}

- (void)interstitialFailPresentScreen:(BaiduMobAdInterstitial *)interstitial withError:(BaiduMobFailReason) reason{
    
}

#pragma mark -- BUInterstitialAdDelegate
//加载完成
- (void)interstitialAdDidLoad:(BUInterstitialAd *)interstitialAd{
    NSLog(@"穿上甲广告加载完成");
    if ([self.delegate respondsToSelector:@selector(adsDidFinishLoading)]) {
        [self.delegate adsDidFinishLoading];
    }
}

//加载失败
- (void)interstitialAd:(BUInterstitialAd *)interstitialAd didFailWithError:(NSError *)error{
    if ([self.delegate respondsToSelector:@selector(didFailToLoadWithError:)]) {
        [self.delegate didFailToLoadWithError:error];
    }
}

#pragma mark -- lazy
- (GADInterstitial *)googleInterstitial{
    if (nil == _googleInterstitial) {
        _googleInterstitial = [[GADInterstitial alloc] initWithAdUnitID:self.adsId];
        _googleInterstitial.delegate = self;
    }
    return _googleInterstitial;
}

- (IMInterstitial *)imInterstitial{
    if (nil == _imInterstitial) {
        _imInterstitial = [[IMInterstitial alloc] initWithPlacementId:[self.adsId integerValue] delegate:self];
    }
    return _imInterstitial;
}

- (GDTMobInterstitial *)gdtInterstitial{
    if (nil == _gdtInterstitial) {
        _gdtInterstitial = [[GDTMobInterstitial alloc] initWithAppId:[DW_AdsPlatformsInfo shareInfo].gdtAppId placementId:self.adsId];
        _gdtInterstitial.delegate = self;
        _gdtInterstitial.isGpsOn = NO;
        
    }
    return _gdtInterstitial;
}

- (BaiduMobAdInterstitial *)baiduInterstitial{
    if (nil == _baiduInterstitial) {
        _baiduInterstitial = [[BaiduMobAdInterstitial alloc] init];
        _baiduInterstitial.interstitialType = BaiduMobAdViewTypeInterstitialBeforeVideo;
        _baiduInterstitial.AdUnitTag = self.adsId;
        _baiduInterstitial.delegate = self;
    }
    return _baiduInterstitial;
}

- (BUInterstitialAd *)buInterstitial{
    if (nil == _buInterstitial) {
        _buInterstitial = [[BUInterstitialAd alloc] initWithSlotID:self.adsId size:[BUSize sizeBy:BUProposalSize_Interstitial600_600]];
        _buInterstitial.delegate = self;
    }
    return _buInterstitial;
}
@end
