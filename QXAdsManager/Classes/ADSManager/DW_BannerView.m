//
//  DW_BannerView.m
//  DeleteWatermark
//
//  Created by 李若澜 on 2019/6/12.
//  Copyright © 2019 LengFeng9. All rights reserved.
//

#import "DW_BannerView.h"
#import "GDTMobBannerView.h"
#import "DW_AdsPlatformsInfo.h"
#import "BaiduMobAdSDK/BaiduMobAdView.h"
#import "BaiduMobAdSDK/BaiduMobAdDelegateProtocol.h"
#import <BUAdSDK/BUBannerAdView.h>
#import "Masonry.h"
#import "DW_ADSManager.h"
#import "DW_AdsPlatformsInfo.h"


@interface DW_BannerView()<UnityAdsBannerDelegate,UnityAdsDelegate,GDTMobBannerViewDelegate,BaiduMobAdViewDelegate,BUBannerAdViewDelegate,IMBannerDelegate,GADBannerViewDelegate>
@property (nonatomic, assign) ADSPlatformType adsPlatformType;
@property (nonatomic, strong) UIView *bannerView;
@property (nonatomic, strong) IMBanner *imBanner;                    //inmobi横幅
@property (nonatomic, strong) GADBannerView *googleBannerView;       //google横幅
@property (nonatomic, strong) GDTMobBannerView *gdtBannerView;       //广点通横幅
@property (nonatomic, strong) BaiduMobAdView *baiduBannerView;       //百度横幅广告
@property (nonatomic, strong) BUBannerAdView *buBannerView;          //穿山甲横幅广告

//@property (nonatomic, strong)
@property (nonatomic, weak) UIViewController *rootController;
@end

@implementation DW_BannerView

- (instancetype)initWithAdsPlatformType:(ADSPlatformType)adsPlatformType
                                  adsId:(NSString *)adsId
                         rootController:(UIViewController *)rootController{
    self = [self init];
    if (self) {
        self.adsPlatformType = adsPlatformType;
        self.adsId = adsId;
        self.rootController = rootController;
        [self setUI];
    }
    return self;
}

- (void)setUI{
    if ([DW_ADSManager getAdsStatus]) {
        return;
    }
    switch (_adsPlatformType) {
            //inmobi横幅
            case DWPlatformTypeInMobi:{
                self.bannerView = self.imBanner;
            }
            break;
            
            //google横幅
            case DWPlatformTypeGoogle:{
                self.bannerView = self.googleBannerView;
            }
            break;
            
            //广点通横幅
            case DWPlatformTypeGDT:{
                self.bannerView = self.gdtBannerView;
            }
            break;
            
            //unity
            case DWPlatformTypeUnity:{
                [UnityAdsBanner setDelegate:self];
                [UnityAdsBanner setBannerPosition:kUnityAdsBannerPositionCenter];
            }
            break;
            
            //百度
            case DWPlatformBaidu:{
                self.bannerView = self.baiduBannerView;
            }
            break;
            
            //穿山甲 （字节跳动）
            case DWPlatformBu:{
                self.bannerView = self.buBannerView;
            }
            break;
            
            
        default:
            break;
    }
    [self addSubview:self.bannerView];
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.centerX.equalTo(self);
    }];
}

- (void)loadAds{
    if ([DW_ADSManager getAdsStatus]) {
        return;
    }
    if (self.bannerView == nil) {
        return;
    }
    switch (_adsPlatformType) {
            case DWPlatformTypeInMobi:{
                [self.imBanner load];
            }
            break;
            
            case DWPlatformTypeGoogle:{
                [self.googleBannerView loadRequest:[GADRequest request]];
            }
            break;
            
            case DWPlatformTypeGDT:{
                [self.gdtBannerView loadAdAndShow];
            }
            break;
            
            case DWPlatformTypeUnity:{
                if ([UnityAds isReady:self.adsId]) {
                    [UnityAdsBanner loadBanner:self.adsId];
                }else{
                    [UnityAds initialize:[DW_AdsPlatformsInfo shareInfo].unityAppId delegate:self testMode:YES];
                }
            }
            break;
            
            case DWPlatformBaidu:{
                [self.baiduBannerView start];
            }
            break;
            
            case DWPlatformBu:{
                [self.buBannerView loadAdData];
            }
            
        default:
            break;
    }
}


#pragma mark -- IMBannerDelegate Im
//imBanner 加载完成
- (void)bannerDidFinishLoading:(IMBanner*)banner{
    if ([self.delegate respondsToSelector:@selector(bannerDidFinishLoad:)]) {
        [self.delegate bannerDidFinishLoad:DWPlatformTypeInMobi];
    }
}

//imBanner 加载失败
-(void)banner:(IMBanner*)banner didFailToLoadWithError:(IMRequestStatus*)error{
    if ([self.delegate respondsToSelector:@selector(banner:didFailToLoadWithError:)]) {
        [self.delegate banner:self didFailToLoadWithError:error];
    }
}

#pragma mark -- UnityAdsDelegate unity（注册所有类型广告）
//unity 加载完毕点广告 （各种类型的广告）
- (void)unityAdsReady:(NSString *)placementId{
    NSLog(@"unityAdsReady placementId : %@",placementId);
    if (![placementId isEqualToString:self.adsId]) {
        return;
    }
    [UnityAdsBanner loadBanner:self.adsId];
    
}

//unity 加载广告失败
- (void)unityAdsDidError:(UnityAdsError)error withMessage:(NSString *)message{
    NSLog(@"unityAdsDidError message : %@ error : %@",message,@(error));
    
}

#pragma mark -- UnityAdsBannerDelegate unity
//unity 成功加载
-(void) unityAdsBannerDidLoad: (NSString *) placementId view: (UIView *) view {
    self.bannerView = view;
    [self addSubview:self.bannerView];
    if ([self.delegate respondsToSelector:@selector(bannerDidFinishLoad:)]) {
        [self.delegate bannerDidFinishLoad:DWPlatformTypeUnity];
    }
}

-(void) unityAdsBannerDidUnload: (NSString *) placementId {
    self.bannerView = nil;
}

//unity 加载失败
-(void)unityAdsBannerDidError:(NSString *)message{
    NSLog(@"加载unity广告失败 : %@",message);
    if ([self.delegate respondsToSelector:@selector(banner:didFailToLoadWithError:)]) {
        NSError *customError = [[NSError alloc] initWithDomain:message code:2 userInfo:nil];
        [self.delegate banner:self didFailToLoadWithError:customError];
    }
}

#pragma mark -- GDTMobBannerViewDelegate 广点通
//广点通 横幅加载成功
- (void)bannerViewDidReceived{
    NSLog(@"GDT横幅加载成功");
    if ([self.delegate respondsToSelector:@selector(bannerDidFinishLoad:)]) {
        [self.delegate bannerDidFinishLoad:DWPlatformTypeUnity];
    }
}

//广点通 横幅加载失败
- (void)bannerViewFailToReceived:(NSError *)error{
    NSLog(@"GDT横幅加载失败 : %@",error);
    if ([self.delegate respondsToSelector:@selector(banner:didFailToLoadWithError:)]) {
        [self.delegate banner:self didFailToLoadWithError:error];
    }
}

#pragma mark -- BaiduMobAdViewDelegate 百度
- (NSString *)publisherId{
    return [DW_AdsPlatformsInfo shareInfo].baiduAppId;
}

// 百度 成功加载
- (void)didAdImpressed{
    if ([self.delegate respondsToSelector:@selector(bannerDidFinishLoad:)]) {
        [self.delegate bannerDidFinishLoad:DWPlatformTypeUnity];
    }
}

//百度 加载失败
- (void)failedDisplayAd:(BaiduMobFailReason)reason{
    if ([self.delegate respondsToSelector:@selector(banner:didFailToLoadWithError:)]) {
        NSString *message = @"";
        if (reason == BaiduMobFailReason_NOAD) {
            message = @"没有推广返回";
        }else if (reason == BaiduMobFailReason_EXCEPTION){
            message = @"网络或其它异常";
        }else{
            message = @"广告尺寸或元素异常，不显示广告";
        }
        NSError *customError = [[NSError alloc] initWithDomain:message code:2 userInfo:nil];
        [self.delegate banner:self didFailToLoadWithError:customError];
    }
}


#pragma mark -- BUBannerAdViewDelegate 穿山甲
//穿山甲 成功加载
- (void)bannerAdViewDidLoad:(BUBannerAdView *)bannerAdView WithAdmodel:(BUNativeAd *_Nullable)nativeAd{
    if ([self.delegate respondsToSelector:@selector(bannerDidFinishLoad:)]) {
        [self.delegate bannerDidFinishLoad:DWPlatformTypeUnity];
    }
}

//穿山甲 加载失败
- (void)bannerAdView:(BUBannerAdView *)bannerAdView didLoadFailWithError:(NSError *_Nullable)error{
    if ([self.delegate respondsToSelector:@selector(banner:didFailToLoadWithError:)]) {
        [self.delegate banner:self didFailToLoadWithError:error];
    }
}

#pragma mark -- GADBannerViewDelegate 谷歌
//谷歌 成功加载
- (void)adViewDidReceiveAd:(nonnull GADBannerView *)bannerView{
    if ([self.delegate respondsToSelector:@selector(bannerDidFinishLoad:)]) {
        [self.delegate bannerDidFinishLoad:DWPlatformTypeUnity];
    }
}

//谷歌 加载失败
- (void)adView:(nonnull GADBannerView *)bannerView didFailToReceiveAdWithError:(nonnull GADRequestError *)error{
    if ([self.delegate respondsToSelector:@selector(banner:didFailToLoadWithError:)]) {
        [self.delegate banner:self didFailToLoadWithError:error];
    }
}

#pragma mark -- set


#pragma mark -- lazy
- (UIView *)bannerView{
    if (nil == _bannerView) {
        _bannerView = [UIView new];
    }
    return _bannerView;
}

- (IMBanner *)imBanner{
    if (nil == _imBanner) {
        _imBanner = [[IMBanner alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)
                                      placementId:[self.adsId integerValue]];
        _imBanner.delegate = self;
        [_imBanner setRefreshInterval:12.f];
    }
    return _imBanner;
}

- (GADBannerView *)googleBannerView{
    if (nil == _googleBannerView) {
        _googleBannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
        _googleBannerView.adSize = kGADAdSizeBanner;
        _googleBannerView.adUnitID = self.adsId; //@"ca-app-pub-3940256099942544/2934735716";
        _googleBannerView.delegate = self;
        _googleBannerView.rootViewController = self.rootController;
    }
    return _googleBannerView;
}

- (GDTMobBannerView *)gdtBannerView{
    if (nil == _gdtBannerView) {
        //AppId 通过其他地方配置
        _gdtBannerView = [[GDTMobBannerView alloc] initWithAppId:[DW_AdsPlatformsInfo shareInfo].gdtAppId placementId:self.adsId];
        _gdtBannerView.currentViewController = self.rootController;
        _gdtBannerView.delegate = self;
        _gdtBannerView.isGpsOn = NO;
        _gdtBannerView.interval = 30.f;
    }
    return _gdtBannerView;
}

- (BaiduMobAdView *)baiduBannerView{
    if (nil == _baiduBannerView) {
        _baiduBannerView = [[BaiduMobAdView alloc] init];
        _baiduBannerView.AdType = BaiduMobAdViewTypeBanner;
        _baiduBannerView.AdUnitTag = self.adsId;
        _baiduBannerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50);
        _baiduBannerView.delegate = self;
    }
    return _baiduBannerView;
}

- (BUBannerAdView *)buBannerView{
    if (nil == _buBannerView) {
        BUSize *size = [BUSize sizeBy:BUProposalSize_Banner600_150];
        _buBannerView = [[BUBannerAdView alloc] initWithSlotID:self.adsId size:size rootViewController:self.rootController];
        _buBannerView.delegate = self;
    }
    return _buBannerView;
}

#pragma mark -- dealloc

- (void)dealloc
{
    if (_imBanner) {
        _imBanner.delegate = nil;
    }

    if (_googleBannerView) {
        _googleBannerView.delegate = nil;
    }
     NSLog(@"bannerView delloc");
}
@end
