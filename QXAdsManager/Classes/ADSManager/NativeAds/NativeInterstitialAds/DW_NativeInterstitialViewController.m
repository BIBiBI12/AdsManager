//
//  DW_NativeInterstitialViewController.m
//  DeleteWatermark
//
//  Created by 李若澜 on 2019/6/24.
//  Copyright © 2019 LengFeng9. All rights reserved.
//

#import "DW_NativeInterstitialViewController.h"
#import <BUAdSDK/BUNativeAdRelatedView.h>
#import <BUAdSDK/BUNativeAd.h>
#import "GDTNativeAd.h"
#import <objc/runtime.h>
#import "Masonry.h"
#import "DW_ADSTypeDefine.h"
#import <YYWebImage/YYWebImage.h>


static CGSize const dislikeSize = {15, 15};
static CGSize const logoSize = {20, 20};


#define leftEdge 20
#define titleHeight 40

@interface DW_NativeInterstitialViewController ()<BUNativeAdDelegate>
@property (nonatomic, strong) BUNativeAdRelatedView *relatedView;
@property (nonatomic, strong) UIView *whiteBackgroundView;
@property (nonatomic, strong) UIImageView *logoImgeView;
@property (nonatomic, strong) UIButton *dislikeButton;
@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UILabel *describeLable;
@property (nonatomic, strong) UIImageView *interstitialAdView;
@property (nonatomic, strong) UIButton *dowloadButton;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIButton *refreshbutton;
@property (nonatomic, strong) GDTNativeAdData *gdtNativeAdData;
@property (nonatomic, assign) NativeAdsPlatformType platformType;     //平台类型
@end

@implementation DW_NativeInterstitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

- (void)setUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.interstitialAdView];
    [self.interstitialAdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width - 60.f, 240.f));
        make.center.equalTo(self.view);
    }];
    
    [self.view addSubview:self.describeLable];
    [self.describeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.interstitialAdView.mas_top).offset(-36.f);
        make.left.mas_equalTo(24.f);
        make.right.mas_equalTo(-24.f);
    }];
    
    [self.view addSubview:self.logoImgeView];
    [self.logoImgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.interstitialAdView);
        make.size.mas_equalTo(CGSizeMake(30.f, 30.f));
        make.bottom.equalTo(self.describeLable.mas_top).offset(-24.f);
    }];
    
    [self.view addSubview:self.titleLable];
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.describeLable.mas_top).offset(-24.f);
        make.centerX.equalTo(self.view);
    }];
    
    [self.view addSubview:self.dowloadButton];
    [self.dowloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.interstitialAdView.mas_bottom).offset(36.f);
        make.size.mas_equalTo(CGSizeMake(300.f, 40.f));
        make.centerX.equalTo(self.view);
    }];
    
    [self.view addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(24, 24));
        make.top.mas_equalTo(70.f);
        make.right.equalTo(self.interstitialAdView);
    }];
}

//关闭广告
- (void)closeAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//点击广告
- (void)tapAds:(UITapGestureRecognizer *)sender{
    if ([self.delegate respondsToSelector:@selector(nativeAdDidClickWithView:platformType:)]) {
        [self.delegate nativeAdDidClickWithView:sender.view platformType:self.platformType];
    }
}

//点击下载按钮
- (void)downApp:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(nativeAdDidClickWithView:platformType:)]) {
        [self.delegate nativeAdDidClickWithView:sender platformType:self.platformType];
    }
}

//穿山甲广告 绑定点击事件 
- (void)addAccessibilityIdentifierForQA {
    self.interstitialAdView.accessibilityIdentifier = @"interaction_view";
    self.relatedView.logoImageView.accessibilityIdentifier = @"interaction_logo";
    self.dislikeButton.accessibilityIdentifier = @"interaction_close";
}

- (UITapGestureRecognizer *)newTapGesture{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAds:)];
    return tap;
}

#pragma mark -- 赋值穿山甲广告
- (void)setVlaueWithBuNativeAd:(BUNativeAd *)nativeAd{
    self.platformType = DWNativePlatformBu;
    self.titleLable.text = nativeAd.data.AdTitle;
    self.describeLable.text = nativeAd.data.AdDescription;
    BUImage *adImage = [nativeAd.data.imageAry firstObject];
    [self.interstitialAdView yy_setImageWithURL:[NSURL URLWithString:adImage.imageURL] placeholder:nil];
    [self.dowloadButton setTitle:nativeAd.data.buttonText forState:UIControlStateNormal];
    [nativeAd registerContainer:self.whiteBackgroundView    withClickableViews:@[self.titleLable,self.interstitialAdView,self.describeLable,self.dowloadButton]];
}

#pragma mark -- 赋值百度广告
- (void)setValueWithBaiduNativeAd:(BaiduMobAdNativeAdObject *)nativeAd{
    self.platformType = DWNativePlatformBaidu;
    self.titleLable.text = nativeAd.title;
    self.describeLable.text = nativeAd.text;
    [self.interstitialAdView yy_setImageWithURL:[NSURL URLWithString:nativeAd.mainImageURLString] placeholder:nil];
    self.dowloadButton.hidden = YES;
}

#pragma mark -- 赋值广点通广告
- (void)setValueWithGdtNativeAd:(GDTNativeAdData *)nativeAd{
    self.platformType = DWNativePlatformTypeGDT;
    self.gdtNativeAdData = nativeAd;
    self.titleLable.text = [nativeAd.properties objectForKey:GDTNativeAdDataKeyTitle];
    self.describeLable.text = [nativeAd.properties objectForKey:GDTNativeAdDataKeyDesc];
    [self.interstitialAdView yy_setImageWithURL:[NSURL URLWithString:[nativeAd.properties objectForKey:GDTNativeAdDataKeyImgUrl]] placeholder:nil];
    self.dowloadButton.hidden = !nativeAd.isAppAd;
    [self.dowloadButton setTitle:@"下载App" forState:UIControlStateNormal];
    [self.dowloadButton addTarget:self action:@selector(downApp:) forControlEvents:UIControlEventTouchUpInside];
    [self.logoImgeView yy_setImageWithURL:[NSURL URLWithString:[nativeAd.properties objectForKey:GDTNativeAdDataKeyIconUrl]] placeholder:nil];
    
    [self.view addSubview:self.titleLable];
    [self.titleLable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.describeLable.mas_top).offset(-24.f);
        make.left.equalTo(self.logoImgeView.mas_right).offset(8.f);
    }];
}

#pragma mark -- inMobi广告赋值
- (void)setVlaueWithInmobiNativeAd:(IMNative *)nativeAd{
    self.platformType = DWNativePlatformInMobi;
    self.titleLable.text = nativeAd.adTitle;
    self.describeLable.text = nativeAd.adDescription;
    [self.interstitialAdView setImage:nativeAd.adIcon];
    self.dowloadButton.hidden = !nativeAd.isAppDownload;
    NSLog(@"广告内容: %@",nativeAd.customAdContent);
}

#pragma mark -- lazy
- (UILabel *)titleLable{
    if (nil == _titleLable) {
        _titleLable = [UILabel new];
        _titleLable.text = @"初始值";
        _titleLable.font = [UIFont systemFontOfSize:15.f];
        [_titleLable addGestureRecognizer:[self newTapGesture]];

    }
    return _titleLable;
}

- (UILabel *)describeLable{
    if (nil == _describeLable) {
        _describeLable = [UILabel new];
        _describeLable.numberOfLines = 0;
        _describeLable.font = [UIFont systemFontOfSize:13.f];
        [_describeLable addGestureRecognizer:[self newTapGesture]];
    }
    return _describeLable;
}

- (UIImageView *)interstitialAdView{
    if (nil == _interstitialAdView) {
        _interstitialAdView = [UIImageView new];
        _interstitialAdView.userInteractionEnabled = YES;
        [_interstitialAdView addGestureRecognizer:[self newTapGesture]];

    }
    return _interstitialAdView;
}

- (UIButton *)dowloadButton{
    if (nil == _dowloadButton) {
        _dowloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _dowloadButton.backgroundColor = [UIColor colorWithRed:255 green:88 blue:82 alpha:1];
        _dowloadButton.layer.cornerRadius = 5;
        _dowloadButton.clipsToBounds = YES;
    }
    return _dowloadButton;
}

- (UIButton *)closeBtn{
    if (nil == _closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"close_icon"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _closeBtn;
}

- (UIImageView *)logoImgeView{
    if (nil == _logoImgeView) {
        _logoImgeView = [UIImageView new];
        [_logoImgeView addGestureRecognizer:[self newTapGesture]];
    }
    return _logoImgeView;
}

@end
