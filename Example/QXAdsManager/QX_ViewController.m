//
//  QX_ViewController.m
//  QXAdsManager
//
//  Created by me_zqx on 07/04/2019.
//  Copyright (c) 2019 me_zqx. All rights reserved.
//

#import "QX_ViewController.h"
#import "DW_ADS.h"
#import "Masonry.h"


@interface QX_ViewController ()<DW_BannerAdsProtocol>
@property (nonatomic, strong) DW_BannerView *bannerView;
@end

@implementation QX_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.bannerView];
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(240, 40));
        make.center.equalTo(self.view);
    }];;
}

#pragma mark -- lazy
- (DW_BannerView *)bannerView{
    if (nil == _bannerView) {
        _bannerView = [[DW_BannerView alloc] initWithAdsPlatformType:DWPlatformTypeGDT adsId:@"4090812164690039" rootController:self];
        _bannerView.delegate = self;
        _bannerView.backgroundColor = [UIColor lightGrayColor];
        [_bannerView loadAds];
    }
    return _bannerView;
}

@end
