//
//  DW_SplashAdsView.m
//  AdsDemo
//
//  Created by 李若澜 on 2019/6/19.
//  Copyright © 2019 小众. All rights reserved.
//

#import "DW_SplashAds.h"
#import "GDTSplashAd.h"
#import "DW_AdsPlatformsInfo.h"
#import <BUAdSDK/BUAdSDK.h>
#import <BaiduMobAdSDK/BaiduMobAdSplash.h>
#import <BaiduMobAdSDK/BaiduMobAdSplashDelegate.h>
#import "DW_ADSManager.h"
#import "Masonry.h"

@interface DW_SplashAds()<GDTSplashAdDelegate,BUSplashAdDelegate,BaiduMobAdSplashDelegate>
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, assign) SplashADSPlatformType splashAdsPlatformType;
@property (nonatomic, strong) UIView *splashView;
@property (nonatomic, strong) GDTSplashAd *gdtSplashAds;
@property (nonatomic, strong) BUSplashAdView *buSplashAdsView;
@property (nonatomic, strong) BaiduMobAdSplash *baiduSplashAds;
@property (nonatomic, strong) UIImageView *placeholderView;
@property (nonatomic, strong) id placeholder;

@end

@implementation DW_SplashAds

- (instancetype)initWithAdsPlatformType:(SplashADSPlatformType)adsPlatformType
                                  adsId:(NSString *)adsId
                                 window:(UIWindow *)window
                            placeholder:(id)placeholder{
    self = [self init];
    if (self) {
        self.splashAdsPlatformType = adsPlatformType;
        self.adsId = adsId;
        self.window = window;
        self.placeholder = placeholder;
        [self setUI];
    }
    return self;
}

//添加展位图控件
- (void)addPlaceholderView{
    if ([DW_ADSManager getAdsStatus]) {
        return;
    }
    if (nil == self.placeholder) {
        return;
    }
    
    if ([self.placeholder isKindOfClass:[UIView class]]) {
        self.placeholderView = self.placeholder;
    }else if ([self.placeholder isKindOfClass:[UIImage class]]){
        self.placeholderView.image = (UIImage *)self.placeholder;
    }
    [self.window.rootViewController.view addSubview:self.placeholderView];
    [self.placeholderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.window.rootViewController.view);
    }];
}

- (void)setUI{
    [self addPlaceholderView];
    switch (self.splashAdsPlatformType) {
        case DWSplashPlatformBu:{
            self.splashView = self.buSplashAdsView;
        }
            break;
            
        default:
            break;
    }
    
}

- (void)loadAdAndShowInWindow:(UIWindow *)window{
    if ([DW_ADSManager getAdsStatus]) {
        return;
    }
    switch (self.splashAdsPlatformType) {
            //广点通
        case DWSplashPlatformTypeGDT:{
            [self.gdtSplashAds loadAdAndShowInWindow:window];
        }
            break;
            
            //百度
        case DWSplashPlatformBaidu:{
            [self.baiduSplashAds loadAndDisplayUsingKeyWindow:self.window];
        }
            break;
            
            //穿山甲
        case DWSplashPlatformBu:{
            [self.buSplashAdsView loadAdData];
            [self.window.rootViewController.view addSubview:self.buSplashAdsView];
            self.buSplashAdsView.rootViewController = self.window.rootViewController;
            [self addPlaceholderView];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -- GDTSplashAdDelegate
//开屏页 成功展示
- (void)splashAdSuccessPresentScreen:(GDTSplashAd *)splashAd{
    if ([self.delegate respondsToSelector:@selector(splashAdDidLoad)]) {
        [self.delegate splashAdDidLoad];
    }
    NSLog(@"成功展示 广点通开屏页");
    if ([self.placeholderView superview]) {
        [self.placeholderView removeFromSuperview];
    }
    
}

//开屏广告展示失败
- (void)splashAdFailToPresent:(GDTSplashAd *)splashAd withError:(NSError *)error{
    NSLog(@"展示失败  广点通开屏页： %@",error);
    if ([self.delegate respondsToSelector:@selector(splashAdDidFailWithError:)]) {
        [self.delegate splashAdDidFailWithError:error];
    }
    if ([self.placeholderView superview]) {
        [self.placeholderView removeFromSuperview];
    }
}

- (void)splashAdDidPresentFullScreenModal:(GDTSplashAd *)splashAd{
    NSLog(@"splashAdDidPresentFullScreenModal");
}

#pragma mark -- BUSplashAdDelegate
- (void)splashAdDidLoad:(BUSplashAdView *)splashAd{
    if ([self.delegate respondsToSelector:@selector(splashAdDidLoad)]) {
        [self.delegate splashAdDidLoad];
    }
    NSLog(@"开屏广告加载完成");
    if ([self.placeholderView superview]) {
        [self.placeholderView removeFromSuperview];
    }
}

- (void)splashAd:(BUSplashAdView *)splashAd didFailWithError:(NSError *)error{
    NSLog(@"穿山甲 加载开屏广告失败 : %@",error);
    [splashAd removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(splashAdDidFailWithError:)]) {
        [self.delegate splashAdDidFailWithError:error];
    }
    if ([self.placeholderView superview]) {
        [self.placeholderView removeFromSuperview];
    }
}

- (void)splashAdDidClose:(BUSplashAdView *)splashAd{
    [splashAd removeFromSuperview];
}

#pragma mark -- BaiduMobAdSplashDelegate
- (NSString *)publisherId{
    return [DW_AdsPlatformsInfo shareInfo].baiduAppId;
}

- (void)splashSuccessPresentScreen:(BaiduMobAdSplash *)splash{
    NSLog(@"百度 加载开屏广告成功");
    if ([self.delegate respondsToSelector:@selector(splashAdDidLoad)]) {
        [self.delegate splashAdDidLoad];
    }
    if ([self.placeholderView superview]) {
        [self.placeholderView removeFromSuperview];
    }
}

- (void)splashlFailPresentScreen:(BaiduMobAdSplash *)splash withError:(BaiduMobFailReason) reason{
    NSLog(@"百度 加载开屏广告失败");
    if ([self.delegate respondsToSelector:@selector(splashAdDidFailWithError:)]) {
        NSString *message = @"";
        if (reason == BaiduMobFailReason_NOAD) {
            message = @"没有推广返回";
        }else if (reason == BaiduMobFailReason_EXCEPTION){
            message = @"网络或其它异常";
        }else{
            message = @"广告尺寸或元素异常，不显示广告";
        }
        NSError *customError = [[NSError alloc] initWithDomain:message code:2 userInfo:nil];
        [self.delegate splashAdDidFailWithError:customError];
    }
    if ([self.placeholderView superview]) {
        [self.placeholderView removeFromSuperview];
    }
}

#pragma mark -- lazy
- (GDTSplashAd *)gdtSplashAds{
    if (nil == _gdtSplashAds) {
        _gdtSplashAds = [[GDTSplashAd alloc] initWithAppId:[DW_AdsPlatformsInfo shareInfo].gdtAppId placementId:self.adsId];
        _gdtSplashAds.delegate = self;
        _gdtSplashAds.fetchDelay = 5;
    }
    return _gdtSplashAds;
}

- (BUSplashAdView *)buSplashAdsView{
    if (nil == _buSplashAdsView) {
        CGRect frame = [UIScreen mainScreen].bounds;
        _buSplashAdsView = [[BUSplashAdView alloc] initWithSlotID:self.adsId frame:frame];
        _buSplashAdsView.delegate = self;
    }
    return _buSplashAdsView;
}

- (BaiduMobAdSplash *)baiduSplashAds{
    if (nil ==_baiduSplashAds ) {
        _baiduSplashAds = [[BaiduMobAdSplash alloc] init];
        _baiduSplashAds.AdUnitTag = self.adsId;
        _baiduSplashAds.canSplashClick = YES;
        _baiduSplashAds.delegate = self;
    }
    return _baiduSplashAds;
}

- (UIImageView *)placeholderView{
    if (nil == _placeholderView) {
        _placeholderView = [UIImageView new];
    }
    return _placeholderView;
}
@end
