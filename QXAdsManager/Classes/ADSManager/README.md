##  初始化
```c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    DW_AdsPlatformsInfo *platformInfo = [[DW_AdsPlatformsInfo alloc] initWithGdtAppId:@"1105344611"
                                       unityAppId:@"3183624"
                                      googleAppId:@""
                                      inMobiAppId:@"9e2be5cb53e84caf861ce7528d7b8092"];
    [platformInfo registerAds];
}
```


## 横幅广告

#### 控件初始化
```c
    - (DW_BannerView *)googleBannerView{
    if (nil == _googleBannerView) {
        _googleBannerView = [[DW_BannerView alloc] initWithAdsPlatformType:DWPlatformTypeInMobi adsId:@"1560887356979" rootController:self];
        [_googleBannerView loadAds];
    }
    return _googleBannerView;
}

```

#### 布局代码
```c
[self.view addSubview:self.googleBannerView];
    [self.googleBannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inmobiBannerView.mas_bottom).offset(30.f);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(240.f, 50.f));
    }];
```

## 插播式广告
#### 控件初始化
```c
    - (DW_Interstitial *)interstitial{
    if (nil == _interstitial) {
        ADSPlatformType type = DWPlatformTypeGDT;
        if (type == DWPlatformTypeInMobi) {
            _interstitial = [[DW_Interstitial alloc] initWithAdsPlatformType:DWPlatformTypeInMobi
                                                                       adsId:@"1561342683209"
                                                              rootController:self
                                                                    delegate:self];
        }else if (type ==DWPlatformTypeGoogle){
            _interstitial = [[DW_Interstitial alloc] initWithAdsPlatformType:DWPlatformTypeGoogle
                                                                       adsId:@"ca-app-pub-3940256099942544/4411468910"
                                                              rootController:self
                                                                    delegate:self];
        }else if (type == DWPlatformTypeUnity){
            _interstitial = [[DW_Interstitial alloc] initWithAdsPlatformType:DWPlatformTypeUnity
                                                                       adsId:@"interstitialXiaoZhong"
                                                              rootController:self
                                                                    delegate:self];
        }else if (type == DWPlatformTypeGDT){
            _interstitial = [[DW_Interstitial alloc] initWithAdsPlatformType:DWPlatformTypeGDT
                                                                       adsId:@"2030814134092814"
                                                              rootController:self
                                                                    delegate:self];
        }
    }
    return _interstitial;
}
```

#### 加载广告
```c
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.interstitial loadAds];
}
```

#### 完成的协议中 展示广告
```c
#pragma mark -- DWInterstitialProtocol
- (void)adsDidFinishLoading{
    [self.interstitial showInterstitialAdsFromController:self];
}

-(void)didFailToLoadWithError:(NSError*)error{
    NSLog(@"加载插页式广告失败: %@",error);
}
```

## 奖励式广告
#### 初始化广告
```c
- (DW_RewardedVideoAds *)rewardVideosAds{
    if (nil == _rewardVideosAds) {
        _rewardVideosAds = [[DW_RewardedVideoAds alloc] initWithAdsPlatformType:DWPlatformTypeGDT adsId:@"8020744212936426" rootController:self delegate:self];

    }
    return _rewardVideosAds;
}
```

####  加载广告
```c
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.rewardVideosAds loadAds];
}
```

#### 加载完成的协议中 展示广告 
```c
- (void)rewardBasedVideoAd{
    NSLog(@"看完奖励广告回调");
}

-(void)adsDidFinishLoading{
    NSLog(@"adsDidFinishLoading");
    [self.rewardVideosAds showInterstitialAdsFromController:self];
}

-(void)didFailToLoadWithError:(NSError*)error{
    NSLog(@"加载激励广告失败: %@",error);
}
```


##### 布局依赖   pod 'Masonry', '~> 1.1.0'

##### 系统依赖 
- InMobiSDK.framework
- libsqlite3.0.tbd
- libz.tbd
- WebKit.framework
- libxml2.tbd 
- CoreLocation.framework
- QuarzCore.framework
- SystemConfiguration.framework
- CoreTelephony.framework
- libz.dylib 或 libz.tbd
- Security.framework
- StoreKit.framework
- AVFoundation.framework
- libxml2.tbd
