//
//  DW_ADSRegister.m
//  DeleteWatermark
//
//  Created by 李若澜 on 2019/6/12.
//  Copyright © 2019 LengFeng9. All rights reserved.
//

#import "DW_ADSRegister.h"
#import "BUAdSDK/BUAdSDK.h"
#import <GoogleMobileAds/GADRewardBasedVideoAd.h>
#import <InMobiSDK/InMobiSDK.h>

@implementation DW_ADSRegister

- (void)setupInmobiWithAccountID:(NSString *)accountId{
    if (accountId.length == 0) {
        return;
    }
    NSMutableDictionary *consentdict = [[NSMutableDictionary alloc]init];
    [consentdict setObject:@"true" forKey:IM_GDPR_CONSENT_AVAILABLE];
    [consentdict setObject:@1 forKey:@"gdpr"];
    [IMSdk initWithAccountID:accountId consentDictionary:consentdict];
}

- (void)setupGoogleAdsAndBeforLoadVideo:(BOOL)beforLoad
                          rewardVideoId:(NSString *)rewardVideoId{
    rewardVideoId = rewardVideoId.length == 0 ? @"" : rewardVideoId;
    [[GADMobileAds sharedInstance] startWithCompletionHandler:nil];
    if (beforLoad) {
        [[GADRewardBasedVideoAd sharedInstance] loadRequest:[GADRequest request] withAdUnitID:rewardVideoId];
    }
}

- (void)setupUnityWithUpid:(NSString *)upid
                  delegate:(nullable id<UnityAdsDelegate>)delegate
                  testMode:(BOOL)testMode{
    if (upid.length == 0) {
        return;
    }
    [UnityAds initialize:upid delegate:delegate testMode:testMode];
}

- (void)setupBuAdsWithAppId:(NSString *)appId{
    [BUAdSDKManager setAppID:appId];

}

@end
