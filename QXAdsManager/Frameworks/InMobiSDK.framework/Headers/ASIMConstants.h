//
//  ASIMConstants.h
//  UnifiedSDK
//
//  Created by Albert Zhu on 7/19/18.
//  Copyright © 2018 Karthik Vaddamani. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef ASIMConstants_h
#define ASIMConstants_h

#define kAdSetingsShowDebug 0
#define kPlacementInfoShowDebug 0
#define kMappingShowDebug 0
#define kMedCoordShowDebug 0
#define kASIMKeyValueStoreDebug 0

typedef NS_ENUM(NSInteger, ASIMPrimaryIntegration) {
    kASIMPrimaryIntegrationUndefined = -1,
    kASIMPrimaryIntegrationAerServ = 0,
    kASIMPrimaryIntegrationInMobi = 1
};

typedef NS_ENUM(NSInteger, ASIMTrueEventType) {
    kASIMTrueEventTypeRequest = 89,
    kASIMTrueEventTypeReady = 90,
    kASIMTrueEventTypeRequestTerminated = 91,
    kASIMTrueEventTypeFailed = 92,
    kASIMTrueEventTypeFill,
    kASIMTrueEventTypeRequestNotFilled,
    kASIMTrueEventTypeAdClicked,
    kASIMTrueEventTypeAdViewRequested,
    kASIMTrueEventTypeAdViewRequestRejected,
    kASIMTrueEventTypeAdViewDisplayed,
    kASIMTrueEventTypeAdViewClosed,
    kASIMTrueEventTypeAdViewExpanded,
    kASIMTrueEventTypeAdViewCollapsed,
    kASIMTrueEventTypeAdViewFailedToBuild
};

typedef NS_ENUM(NSInteger, ASIMTrueEventReason) {
    kASIMTrueEventReasonNotApplicable,
    kASIMTrueEventReasonFrequentRequests,
    kASIMTrueEventReasonReloadNotPermitted,
    kASIMTrueEventReasonNetworkNotAvailable,
    kASIMTrueEventReasonLoadInProgress,
    kASIMTrueEventReasonRequestCreationFailed
};

typedef NS_ENUM(NSInteger, ASIMAdState) {
    kASIMAdStateInit = 0,
    kASIMAdStateLoading,
    kASIMAdStatePreloaded,
    kASIMAdStateLoaded,
    kASIMAdStateRendered,
    kASIMAdStateActive,
    kASIMAdStateDismissed,
    kASIMAdStateFailed,
    kASIMAdStateFetchingSignals,
    kASIMAdStateFetchedSignals
};

typedef NS_ENUM(NSInteger, ASIMUnifiedTimeout) {
    kASIMUnifiedTimeoutPreinit = 0,
    kASIMUnifiedTimeoutMutt,
    kASIMUnifiedTimeoutMediationLoad,
    kASIMUnifiedTimeoutUnifiedAuction,
    kASIMUnifiedTimeoutRendering,
    kASIMUnifiedTimeoutShow
};

// SDK Meta Info
extern NSString* const kASIMUnifiedMediationNetworkName;
extern NSString* const kASIMUnifiedSDKName;
extern NSString* const kASIMUnifiedSDKVersion;

// AS TRC Default Base Event URL
extern NSString* const kASIMDefaultTRCBaseEventUrl;

// Unified SDK Timeouts
extern NSTimeInterval const kASIMUnifiedStep0_Preinit_TimeoutDefaultVal;
extern NSTimeInterval const kASIMUnifiedStep1a_Mutt_TimeoutDefaultVal;
extern NSTimeInterval const kASIMUnifiedStep1b_MediationLoad_TimeoutDefaultVal;
extern NSTimeInterval const kASIMUnifiedStep2u_UnifiedAuction_UTimeoutDefaultVal;
extern NSTimeInterval const kASIMUnifiedStep3r_Render_TimeoutDefaultVal;
extern NSTimeInterval const kASIMUnifiedStep4s_Show_TimeoutDefaultVal;

// Unified Auction Endpoint
extern NSString* const kUnifiedAuctionEndPointUrl;

// Unified Auction Keys
extern NSString* const kASIMUnifiedAuction_RequestID_Key;
extern NSString* const kASIMUnifiedAuction_AdType_Key;
extern NSString* const kASIMUnifiedAuction_AdSetAuctionMeta_Key;
extern NSString* const kASIMUnifiedAuction_ImpressionId_Key;
extern NSString* const kASIMUnifiedAuction_AdAuctionMeta_Key;
extern NSString* const kASIMUnifiedAuction_DynamicBid_Key;
extern NSString* const kASIMUnifiedAuction_Macros_Key;

// KeyStore Keys
extern NSString* const kASIMKVStoreSDKSettings;
extern NSString* const kASIMKVStoreMappingManagers;
extern NSString* const kASIMKVStorePlacementInfo;
extern NSString* const kASIMKVStoreTrueBaseEventUrls;
extern NSString* const kASIMKVStoreBannerExtras;
extern NSString* const kASIMKVStoreInterstitialExtras;
extern NSString* const kASIMKVStoreNativeExtras;

// Ad Markup Types
extern NSString* const kASIMAdMarkupTypeInMobiJSON;
extern NSString* const kASIMAdMarkupTypeHTML;
extern NSString* const kASIMAdMarkupTypeMediationJSON;

// Banner Refresh
extern NSTimeInterval const kASIMBannerRefreshUnset;
extern NSTimeInterval const kASIMBannerRefreshDisabledForAS;
extern NSTimeInterval const kASIMBannerRefreshDefault;
extern NSTimeInterval const kASIMBannerRefreshMinimum;

// Interstitial Base VC Close Button
extern NSTimeInterval const kASIMInterstitialBaseVCCloseButtonDelay;

// AS Tracking Events
extern NSString* const kASBannerRenderedEventType;
extern NSString* const kASVASTImpressionEventType;

// NSCoding Keys
extern NSString* const kASIMCodingIntTypeKey;
extern NSString* const kASIMCodingIMAccountIdKey;
extern NSString* const kASIMCodingASAppIdKey;
extern NSString* const kASIMCodingPrimaryAcctIdKey;
extern NSString* const kASIMCodingSecondaryAcctIdKey;
extern NSString* const kASIMCodingAppIdKey;
extern NSString* const kASIMCodingLocationKey;
extern NSString* const kASIMCodingBSSIDKey;
extern NSString* const kASIMCodingCellKey;
extern NSString* const kASIMCodingMappingTableKey;
extern NSString* const kASIMCodingMappingASKey;
extern NSString* const kASIMCodingMappingIMKey;
extern NSString* const kASIMCodingASPlacementKey;
extern NSString* const kASIMCodingIMPlacementKey;
extern NSString* const kASIMCodingHasDynamicKey;
extern NSString* const kASIMCodingPrefetchEnabledKey;
extern NSString* const kASIMCodingIsPreloadKey;
extern NSString* const kASIMCodingHasRewardsKey;
extern NSString* const kASIMCodingIsDebugKey;
extern NSString* const kASIMCodingPubKeysKey;
extern NSString* const kASIMCodingUserIdKey;
extern NSString* const kASIMCodingDTBAdResponsesKey;
extern NSString* const kASIMCodingSecureOnlyKey;
extern NSString* const kASIMCodingKeywordsKey;
extern NSString* const kASIMCodingExtKey;
extern NSString* const kASIMCodingExtrasKey;
extern NSString* const kASIMCodingRefreshEnabledKey;
extern NSString* const kASIMCodingRefreshIntervalKey;
extern NSString* const kASIMCodingAnimationTypeKey;

#endif /* ASIMConstants_h */
