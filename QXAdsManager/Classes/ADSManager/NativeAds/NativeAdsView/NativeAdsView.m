
//
//  NativeAdsView.m
//  DeleteWatermark
//
//  Created by 李若澜 on 2019/7/2.
//  Copyright © 2019 LengFeng9. All rights reserved.
//

#import "NativeAdsView.h"
#import <BUAdSDK/BUNativeAd.h>
#import <BaiduMobAdSDK/BaiduMobAdNative.h>
#import "GDTNativeAd.h"
#import "BaiduMobAdSDK/BaiduMobAdNativeAdObject.h"
#import <InMobiSDK/InMobiSDK.h>
#import "Masonry.h"
#import "YYWebImage.h"
#import "UIImageView+YYWebImage.h"
#import "DW_AdsPlatformsInfo.h"


@interface NativeAdsView()<BUNativeAdDelegate,BaiduMobAdNativeAdDelegate,GDTNativeAdDelegate,IMNativeDelegate>
@property (nonatomic, assign) NativeAdsPlatformType platformType;   //平台类型
@property (nonatomic, copy) NSString *adsId;                        //广告id
@property (nonatomic, strong) UIViewController *rootController;     //根视图
@property (nonatomic, strong) BUNativeAd *buNativeAd;               //穿山甲广告
@property (nonatomic, strong) BaiduMobAdNative *baiduNativeAd;      //百度广告
@property (nonatomic, strong) GDTNativeAd *gdtNativeAd;             //广点通广告
@property (nonatomic, strong) IMNative *inMobiNativeAd;             //inMobi广告
@property (nonatomic, strong) id data;                              //广告数据

@property (nonatomic, strong) UIView *titleUnder;
@property (nonatomic, strong) UIImageView *adsImageView;            //广告图片
@property (nonatomic, strong) UILabel *titleLabel;                  //广告标题
@property (nonatomic, strong) UILabel *desLabel;                    //广告描述label
@property (nonatomic, strong) UIButton *downBtn;                    //下载按钮
@property (nonatomic, strong) UIImageView *logoImageView;           //logo图片
@end

@implementation NativeAdsView

- (instancetype)initWithNativePlatform:(NativeAdsPlatformType)platformType
                                 adsId:(NSString *)adsId
                        rootController:(nonnull UIViewController *)rootController{
    self = [self init];
    if (self) {
        self.platformType = platformType;
        self.adsId = adsId;
        self.rootController = rootController;
        [self setUI];
    }
    return self;
}

- (void)setUI{
    [self addSubview:self.adsImageView];
    [self addSubview:self.titleUnder];
    [self.titleUnder addSubview:self.titleLabel];
    [self.titleUnder addSubview:self.desLabel];
}

- (void)layoutSubviews{
    
    [self.adsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.titleUnder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(0.f);
        make.height.mas_equalTo(40.f);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-10.f);
        make.top.mas_equalTo(3.f);
    }];
    
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(1.f);
        make.left.right.equalTo(self.titleLabel);
        
    }];
}

- (void)setValue{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.titleUnder.hidden = NO;
        });
    });
    
    switch (self.platformType) {
            //穿山甲
        case DWNativePlatformBu:{
            [self setValueWithBuNativeAd:self.data];
            
        }
            break;
            
            //广点通
        case DWNativePlatformTypeGDT:{
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self setValueWithGdtNativeAd:self.data];
            });
            
        }
            break;
            
            //百度
        case DWNativePlatformBaidu:{
            [self setValueWithBaiduNativeAd:self.data];
        }
            break;
            
            //inMobi
        case DWNativePlatformInMobi:{
            [self setValueWithInmobiNativeAd:self.data];
        }
            break;
            
        default:
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

- (void)clickAds{
    if ([self.delegate respondsToSelector:@selector(nativeAdDidClickWithView:)]) {
        [self.delegate nativeAdDidClickWithView:self];
    }
    switch (self.platformType) {
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
            [baiduNativeAdObj handleClick:self];
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

#pragma mark -- 赋值穿山甲广告
- (void)setValueWithBuNativeAd:(BUNativeAd *)nativeAd{
    self.platformType = DWNativePlatformBu;
    self.titleLabel.text = nativeAd.data.AdTitle;
    self.desLabel.text = nativeAd.data.AdDescription;
    BUImage *adImage = [nativeAd.data.imageAry firstObject];
    [self.adsImageView yy_setImageWithURL:[NSURL URLWithString:adImage.imageURL] placeholder:nil];
    [self.downBtn setTitle:nativeAd.data.buttonText forState:UIControlStateNormal];
    [nativeAd registerContainer:self    withClickableViews:@[self.titleLabel,self.adsImageView,self.desLabel,self.downBtn]];
}

#pragma mark -- 赋值百度广告
- (void)setValueWithBaiduNativeAd:(BaiduMobAdNativeAdObject *)nativeAd{
    self.platformType = DWNativePlatformBaidu;
    self.titleLabel.text = nativeAd.title;
    self.desLabel.text = nativeAd.text;
    [self.adsImageView yy_setImageWithURL:[NSURL URLWithString:nativeAd.mainImageURLString] placeholder:nil];
    self.downBtn.hidden = YES;
}

#pragma mark -- 赋值广点通广告
- (void)setValueWithGdtNativeAd:(GDTNativeAdData *)nativeAd{
    self.platformType = DWNativePlatformTypeGDT;
    self.titleLabel.text = [nativeAd.properties objectForKey:GDTNativeAdDataKeyTitle];
    self.desLabel.text = [nativeAd.properties objectForKey:GDTNativeAdDataKeyDesc];
    [self.adsImageView yy_setImageWithURL:[NSURL URLWithString:[nativeAd.properties objectForKey:GDTNativeAdDataKeyImgUrl]] placeholder:nil];
    self.downBtn.hidden = !nativeAd.isAppAd;
    [self.downBtn setTitle:@"下载App" forState:UIControlStateNormal];
    [self.downBtn addTarget:self action:@selector(downApp:) forControlEvents:UIControlEventTouchUpInside];
    [self.logoImageView yy_setImageWithURL:[NSURL URLWithString:[nativeAd.properties objectForKey:GDTNativeAdDataKeyIconUrl]] placeholder:nil];
    [self.gdtNativeAd attachAd:nativeAd toView:self];
}

#pragma mark -- inMobi广告赋值
- (void)setValueWithInmobiNativeAd:(IMNative *)nativeAd{
    self.platformType = DWNativePlatformInMobi;
    self.titleLabel.text = nativeAd.adTitle;
    self.desLabel.text = nativeAd.adDescription;
    [self.adsImageView setImage:nativeAd.adIcon];
    self.downBtn.hidden = !nativeAd.isAppDownload;
    NSLog(@"广告内容: %@",nativeAd.customAdContent);
}

#pragma mark -- BUNativeAdDelegate
/**
 穿山甲广告  加载成功
 */
- (void)nativeAdDidLoad:(BUNativeAd *)nativeAd{
    self.data = nativeAd;
    [self setValue];
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
    [self setValue];
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
    [self setValue];
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
    [self setValue];
    if ([self.delegate respondsToSelector:@selector(nativeAdDidLoad)]) {
        [self.delegate nativeAdDidLoad];
    }
}

-(void)native:(IMNative*)native didFailToLoadWithError:(IMRequestStatus*)error{
    if ([self.delegate respondsToSelector:@selector(nativeAdDidFailWithError:)]) {
        [self.delegate nativeAdDidFailWithError:error];
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
        _gdtNativeAd.delegate = self;
        _gdtNativeAd.controller = self.rootController;
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

- (UIView *)titleUnder{
    if (nil == _titleUnder) {
        _titleUnder = [UIView new];
        _titleUnder.hidden = YES;
        _titleUnder.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:0.5];;
    }
    return _titleUnder;
}

- (UIImageView *)adsImageView{
    if (nil == _adsImageView) {
        _adsImageView = [UIImageView new];
        _adsImageView.backgroundColor = [UIColor whiteColor];
        _adsImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAds)];
        [_adsImageView addGestureRecognizer:tap];
    }
    return _adsImageView;
}

- (UILabel *)titleLabel{
    if (nil == _titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:12.f];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (UILabel *)desLabel{
    if (nil == _desLabel) {
        _desLabel = [UILabel new];
        _desLabel.font = [UIFont systemFontOfSize:10.f];
        _desLabel.textColor = [UIColor whiteColor];
    }
    return _desLabel;
}

- (UIButton *)downBtn{
    if (nil == _downBtn) {
        _downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _downBtn;
}

- (UIImageView *)logoImageView{
    if (nil == _logoImageView) {
        _logoImageView = [UIImageView new];
    }
    return _logoImageView;
}

@end
