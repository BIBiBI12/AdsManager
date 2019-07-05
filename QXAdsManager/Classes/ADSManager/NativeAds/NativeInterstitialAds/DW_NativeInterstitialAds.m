//
//  DW_NativeAds.m
//  DeleteWatermark
//
//  Created by 李若澜 on 2019/6/24.
//  Copyright © 2019 LengFeng9. All rights reserved.
//

#import "DW_NativeInterstitialAds.h"
#import "DW_NativeInterstitialViewController.h"
#import <BUAdSDK/BUNativeAd.h>
#import <BaiduMobAdSDK/BaiduMobAdNative.h>
#import "GDTNativeAd.h"
#import <InMobiSDK/InMobiSDK.h>
#import "DW_AdsPlatformsInfo.h"


@interface DW_NativeInterstitialAds()<BUNativeAdDelegate,BaiduMobAdNativeAdDelegate,GDTNativeAdDelegate,IMNativeDelegate,DW_NativeViewControllerProtocol>
@property (nonatomic, assign) NativeAdsPlatformType platformType;   //平台类型
@property (nonatomic, copy) NSString *adsId;                        //广告id
@property (nonatomic, strong) UIViewController *rootController;
@property (nonatomic, strong) BUNativeAd *buNativeAd;               //穿山甲广告
@property (nonatomic, strong) BaiduMobAdNative *baiduNativeAd;      //百度广告
@property (nonatomic, strong) GDTNativeAd *gdtNativeAd;             //广点通广告
@property (nonatomic, strong) IMNative *inMobiNativeAd;             //inMobi广告
@property (nonatomic, strong) id data;                              //广告数据
@end

@implementation DW_NativeInterstitialAds

- (instancetype)initWithNativePlatform:(NativeAdsPlatformType)platformType
                                 adsId:(NSString *)adsId
                        rootController:(UIViewController *)rootController{
    self = [self init];
    if (self) {
        self.platformType = platformType;
        self.adsId = adsId;
        self.rootController = rootController;
    }
    return self;
}

- (void)showNativeAdsFromController:(UIViewController *)controller{
    switch (self.platformType) {
        case DWNativePlatformBu:{
            //穿山甲
            DW_NativeInterstitialViewController *nativeController = [DW_NativeInterstitialViewController new];
            BUNativeAd *nativeData = (BUNativeAd *)self.data;
            [nativeController setVlaueWithBuNativeAd:nativeData];
            nativeController.delegate = self;
            [controller presentViewController:nativeController animated:YES completion:nil];
        }
            break;
            
        case DWNativePlatformBaidu:{
            //百度
            DW_NativeInterstitialViewController *nativeController = [DW_NativeInterstitialViewController new];
            BaiduMobAdNativeAdObject *nativeData = (BaiduMobAdNativeAdObject *)self.data;
            [nativeController setValueWithBaiduNativeAd:nativeData];
            nativeController.delegate = self;
            [controller presentViewController:nativeController animated:YES completion:nil];
        }
            break;
        
        case DWNativePlatformTypeGDT:{
            //广点通
            DW_NativeInterstitialViewController *nativeController = [DW_NativeInterstitialViewController new];
            GDTNativeAdData *nativeData = (GDTNativeAdData *)self.data;
            [nativeController setValueWithGdtNativeAd:nativeData];
            nativeController.delegate = self;
            self.gdtNativeAd.controller = nativeController;
            [self.gdtNativeAd attachAd:nativeData toView:nativeController.view];
            [controller presentViewController:nativeController animated:YES completion:nil];
        }
            break;
            
        case DWNativePlatformInMobi:{
            //inMobi
            DW_NativeInterstitialViewController *nativeController = [DW_NativeInterstitialViewController new];
            IMNative *nativeData = (IMNative *)self.data;
            [nativeController setVlaueWithInmobiNativeAd:nativeData];
            nativeController.delegate = self;
            [controller presentViewController:nativeController animated:YES completion:nil];
        }
            break;
            
        default:{
            
        }
            break;
    }

}

- (void)loadAds{
    switch (self.platformType) {
            //穿山甲
        case DWNativePlatformBu:{
            [self.buNativeAd loadAdData];
        }
            break;
            
            //百度
        case DWNativePlatformBaidu:{
            [self.baiduNativeAd requestNativeAds];
        }
            break;
            
            //广点通
        case DWNativePlatformTypeGDT:{
            [self.gdtNativeAd loadAd:1];
        }
            break;
            
            //inMobi
        case DWNativePlatformInMobi:{
            [self.inMobiNativeAd load];
        }
        default:
            break;
    }
}

#pragma mark -- BUNativeAdDelegate
/**
 穿山甲广告  加载成功
 */
- (void)nativeAdDidLoad:(BUNativeAd *)nativeAd{
    self.data = nativeAd;
    if ([self.delegate respondsToSelector:@selector(nativeAdDidLoad)]) {
        [self.delegate nativeAdDidLoad];
    }
}

/**
 穿山甲广告 加载失败
 */
- (void)nativeAd:(BUNativeAd *)nativeAd didFailWithError:(NSError *_Nullable)error{
    if ([self.delegate respondsToSelector:@selector(nativeAdDidFailWithError:)]) {
        [self.delegate nativeAdDidFailWithError:error];
    }
}

#pragma mark -- BaiduMobAdNativeAdDelegate
- (NSString *)publisherId{
    return [DW_AdsPlatformsInfo shareInfo].baiduAppId;
}

- (NSString*)apId{
    return self.adsId;
}

/**
 *  百度 原生广告加载广告数据成功回调
 */
- (void)nativeAdObjectsSuccessLoad:(NSArray *)nativeAds{
    self.data = [nativeAds firstObject];
    if ([self.delegate respondsToSelector:@selector(nativeAdDidLoad)]) {
        [self.delegate nativeAdDidLoad];
    }
}

/**
 *  百度 原生广告加载广告数据失败回调
 */
- (void)nativeAdsFailLoad:(BaiduMobFailReason) reason{
    if ([self.delegate respondsToSelector:@selector(nativeAdDidFailWithError:)]) {
        NSString *message = @"";
        if (reason == BaiduMobFailReason_NOAD) {
            message = @"没有推广返回";
        }else if (reason == BaiduMobFailReason_EXCEPTION){
            message = @"网络或其它异常";
        }else{
            message = @"广告尺寸或元素异常，不显示广告";
        }
        NSError *customError = [[NSError alloc] initWithDomain:message code:2 userInfo:nil];
        [self.delegate nativeAdDidFailWithError:customError];
    }
}

- (void)nativeAdClicked:(UIView *)nativeAdView{
    
}

#pragma mark -- GDTNativeAdDelegate
/**
 *  广点通 原生广告加载广告数据成功回调，返回为GDTNativeAdData对象的数组
 */
- (void)nativeAdSuccessToLoad:(NSArray *)nativeAdDataArray{
    self.data = [nativeAdDataArray firstObject];
    if ([self.delegate respondsToSelector:@selector(nativeAdDidLoad)]) {
        [self.delegate nativeAdDidLoad];
    }
}

/**
 *  广点通 原生广告加载广告数据失败回调
 */
- (void)nativeAdFailToLoad:(NSError *)error{
    if ([self.delegate respondsToSelector:@selector(nativeAdDidFailWithError:)]) {
        [self.delegate nativeAdDidFailWithError:error];
    }
}

#pragma mark -- IMNativeDelegate
-(void)nativeDidFinishLoading:(IMNative*)native{
    self.data = nil;
    self.data = native;
    if ([self.delegate respondsToSelector:@selector(nativeAdDidLoad)]) {
        [self.delegate nativeAdDidLoad];
    }
}

-(void)native:(IMNative*)native didFailToLoadWithError:(IMRequestStatus*)error{
    if ([self.delegate respondsToSelector:@selector(nativeAdDidFailWithError:)]) {
        [self.delegate nativeAdDidFailWithError:error];
    }
}

#pragma mark -- DW_NativeViewControllerProtocol (原生模块交互)
- (void)nativeAdDidBecomeVisible{
   

}


- (void)nativeAdDidClickWithView:(UIView *_Nullable)view platformType:(NativeAdsPlatformType)platformType{
    switch (platformType) {
        case DWNativePlatformTypeGDT:{
            //广点通 曝光
            [self.gdtNativeAd clickAd:self.data];
        }
            break;
            
        case DWNativePlatformBu:{
            //穿山甲
        }
            break;
            
        case DWNativePlatformBaidu:{
            //百度
            BaiduMobAdNativeAdObject *baiduNativeAdObj = self.data;
            [baiduNativeAdObj handleClick:view];
        }
            break;
        case DWNativePlatformInMobi:{
            //inMobi
            [self.inMobiNativeAd reportAdClickAndOpenLandingPage];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -- lazy
- (BUNativeAd *)buNativeAd{
    if (nil == _buNativeAd) {
        BUSize *imageSize = [[BUSize alloc] init];
        imageSize.width = 1080;
        imageSize.height = 1920;
        
        BUAdSlot *slot = [[BUAdSlot alloc] init];
        slot.ID = self.adsId;
        slot.AdType = BUAdSlotAdTypeInterstitial;
        slot.position = BUAdSlotPositionFullscreen;
        slot.imgSize = imageSize;
        slot.isSupportDeepLink = YES;
        slot.isOriginAd = YES;
        
        _buNativeAd = [BUNativeAd new];
        _buNativeAd.adslot = slot;
        _buNativeAd.delegate = self;
        _buNativeAd.rootViewController = self.rootController;
    }
    return _buNativeAd;
}

- (BaiduMobAdNative *)baiduNativeAd{
    if (nil == _baiduNativeAd) {
        _baiduNativeAd = [[BaiduMobAdNative alloc] init];
        _baiduNativeAd.delegate = self;
    }
    return _baiduNativeAd;
}

- (GDTNativeAd *)gdtNativeAd{
    if (nil == _gdtNativeAd) {
        //appId          1105344611
        //placementId    1080215124193862
        _gdtNativeAd = [[GDTNativeAd alloc] initWithAppId:[DW_AdsPlatformsInfo shareInfo].gdtAppId placementId:self.adsId];
        _gdtNativeAd.controller = self.rootController;
        _gdtNativeAd.delegate = self;
    }
    return _gdtNativeAd;
}

- (IMNative *)inMobiNativeAd{
    if (nil == _inMobiNativeAd) {
        _inMobiNativeAd = [[IMNative alloc] initWithPlacementId:[self.adsId integerValue]];
        _inMobiNativeAd.delegate = self;
    }
    return _inMobiNativeAd;
}
@end
