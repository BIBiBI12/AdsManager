//
//  DW_ADSTool.m
//  DeleteWatermark
//
//  Created by 李若澜 on 2019/6/11.
//  Copyright © 2019 LengFeng9. All rights reserved.
//

#import "DW_ADSManager.h"
#import "DW_BannerView.h"
#import "DW_ADSTypeDefine.h"
#import <CoreLocation/CoreLocation.h>
#import <InMobiSDK/InMobiSDK.h>
#import <GoogleMobileAds/GoogleMobileAds.h>
#import <UnityAds/UnityAds.h>

#define adsSwitchKey @"zqxzsAdsSwitchKey"

@implementation DW_ADSManager

+ (void)registPlatforms:(void(^)(DW_ADSRegister *platformsRegister))importHandler{
    if (importHandler) {
        DW_ADSRegister *adsRegister =  [DW_ADSRegister new];
        importHandler(adsRegister);
    }
}

+ (void)closeAds{
    //TODO:加上用户 标识别
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:adsSwitchKey];
}

+ (void)openAds{
    //TODO:加上用户 标识别
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:adsSwitchKey];
}

//状态为YES 则为屏蔽广告
+ (BOOL)getAdsStatus{
    return [[NSUserDefaults standardUserDefaults] boolForKey:adsSwitchKey];
}

@end
