//
//  IMBidObject.h
//
//  Created on 2/19/19.
//

#import <Foundation/Foundation.h>
#import "IMAudienceBidder.h"

/*!
 * Static key to be use to store the placement associated with the bid inside
 * the partner ad's local cache
 */
#define kIMABLocalCacheKey @"IMABLocalCache"

/*!
 * Static keys to look up IMAB Keywords
 */
#define kIMABKeywordKey @"IMAB"

/*!
 * Static key used to return a bid response
 */
#define kIMABSupportForNoAd @"NO_AD"

/*!
 * Keys to look up keywords and extras for Rewarded Video ads
 */
#define kIMABMPRewardedVideoPlacementKey @"placement"
#define kIMABMPRewardedVideoKeywordsKey @"keywords"
#define kIMABMPRewardedVideoExtrasKey @"extras"

/*!
 * ENUM for list of primary mediation ads supported
 */
typedef NS_ENUM(NSInteger, IMABSupportedAd) {
    kIMABSupportedAd_None = 0,
    kIMABSupportedAd_NoAd,
    kIMABSupportedAd_MPAdView,
    kIMABSupportedAd_MPInterstitialAdController,
    kIMABSupportedAd_MPRewardedVideo,
    kIMABSupportedAd_ANBannerAdView,
    kIMABSupportedAd_ANInterstitialAd
};

/*!
 * Static error messages from bid object
 */
#define kIMABErrorAdNotSupported @"Supplied ad not supported for audience bidding"

@interface IMBidObject : NSObject

/*!
 * Delegate for reporting bid status
 */
@property (nonatomic, strong, nullable) id<IMAudienceBidderDelegate> delegate;

/*!
 * Placement from AerServ's SSUI which holds all relevant ad sources for bid
 */
@property (nonatomic, strong, nullable) NSString* placement;

/*!
 * InMobi ad that is participating in the final external auction
 */
@property (nonatomic, strong, nullable) id imAd;

/*!
 * The primary mediation manager ad that is running the final external auction
 */
@property (nonatomic, weak, nullable) id pmmAd;

/*!
 * ENUM for the supported ad type
 */
@property (nonatomic, readonly) IMABSupportedAd support;

/*!
 * Array of external bids to be considered for auction
 */
@property (nonatomic, strong, nullable) NSArray* extBids;

#pragma mark - Initializer

/*!
 * Initializes bid object with basic information: placement, partner ad, and delegate
 */
- (nullable instancetype)initWithPlacement:(nonnull NSString*)plc
                                     adObj:(nonnull id)ad
                               withSupport:(IMABSupportedAd)support
                              externalBids:(nullable NSArray*)extBidsArr
                                 bidWindow:(NSTimeInterval)window
                               andDelegate:(nonnull id<IMAudienceBidderDelegate>)delegate;

#pragma mark - Bid Object Methods

/*!
 * This method will submit a bid into the primary mediations auction
 */
- (void)submitBid;

/*!
 * This method will check if callback can be sent
 */
- (BOOL)canSendCallback;

#pragma mark - Helpers for processing keywords strings

/*!
 * This method will check if bid is valid
 * @param bidKey the bid that is being attempted to be added
 * @return a BOOL to signify accepted or not
 */
- (BOOL)isBidAccepted:(nullable NSString*)bidKey;

/*!
 * This method will remove any extra or repeated commas from a string list
 * @param inputStr the string given to be processed
 * @return a string that has any wrongly placed commas removed
 */
- (nullable NSString*)handleExtraCommasFor:(nullable NSString*)inputStr;

/*!
 * This method will search for and remove any existing or stale bids from InMobi Audience Bidder
 * It will also return an emptry string if the keywords string did not previously exist
 * @param keywords the string to be processed
 * @return a string that has removed of any InMobi Audience Bidder bids
 */
- (nullable NSString*)processedKeywordsRemovingPreviousBids:(nullable NSString*)keywords;

/*!
 * This method will take a keyword bid and appened it to the keywords from the partner ad
 * or just returning the keyword bid if no keywords exist
 * @param keywords a string list of the partner ads currently defined keywords
 * @param bidKey a string that represents the bid that InMobi Audience Bidder is entering the auction at
 * @return a string that has been processed with the bidKey included in the list
 */
- (nullable NSString*)processedKeywords:(nullable NSString*)keywords byAppendingBid:(nullable NSString*)bidKey;

#pragma mark - Keyword bid generation

/*!
 * This method will create the according keyword bid with the given buyer price for the ad
 * @param buyerPrice a number that is the payable price for rendering the ad
 * @param priceCeiling a double value to cap the maximum returned price at
 * @return a string for the keyword bid at the given price
 */
- (nonnull NSString*)generateBidKeyFor:(nullable NSNumber*)buyerPrice withMax:(double)priceCeiling;

/*!
 * This method will grab the price string from the IMAB keyword and return it as a separate string,
 * @param keyword string that the price should be derived from
 * @return a string with the price taken from the keyword
 */
+ (NSString*)getPriceFromKeyword:(NSString*)keyword;

#pragma mark - Processing external bids

/*!
 * Processing APS specific external bids
 * @return an array of strings that contatin relevant APS information
 */
- (nullable NSArray*)processExternalBidForAPS;

#pragma mark - Bid timer methods

/*!
 * This method will stop and remove the bid timer
 */
- (void)removeTimer;

#pragma mark - Methods to be overridden by subclass

/*!
 * This method will be called with a buyer price to generate a keyword per ad type
 * for the bid to participate in the primary mediation's auction at.
 * @param buyerPrice the number value that signifies the price of the ad
 * @return a string for the keyword bid at the given price
 */
- (nullable NSString*)generateBidKeyFor:(nullable NSNumber*)buyerPrice;

/*!
 * This method checks if the given ad is supported by InMobi Audience Bidder
 * @param ad the partner ad that will be checked to see for added support
 * @return a BOOL to signify support
 */
- (IMABSupportedAd)isAdSupported:(nullable id)ad;

/*!
 * This method will check existing keywords and remove any previous or stale bids
 */
- (void)removePreviousBids;

/*!
 * This method will add a new bid to the partner ad's keywords list
 * @param bidKey the string keyword bid that will be added
 */
- (void)appendBid:(nullable NSString*)bidKey;

/*!
 * This method will store the placement inside the ad to be accessed if the bid wins
 * @param plc the placement to be stored, when nil will remove previously stored placement
 */
- (void)storePlacement:(nullable NSString*)plc;

#pragma mark - Clean up method

/*!
 * This method will remove both keywords and stored placement from the primary mediation ad
 */
- (void)cleanUp;

@end
