//
//  IMAudienceBidder.h
//
//  Created on 2/19/19.
//

#import <Foundation/Foundation.h>

/*!
 * ENUM to select desired ad type when submitting a bid to audience bidder
 */
typedef NS_ENUM(NSInteger, IMBiddingAdType) {
    kIMBiddingAdTypeBanner = 0,
    kIMBiddingAdTypeInterstitial,
    kIMBiddingAdTypeRewarded
};

@protocol IMAudienceBidderDelegate;
@class IMBidObject;
@class IMBidResponse;

@interface IMAudienceBidder : NSObject

/*!
 * Dictionary hash for all current bid objects
 */
+ (NSMutableDictionary*)biddingInfo;

/*!
 * Initialization for audience bidder to be called near application start
 * @param appId the application ID setup from the AerServ dashboard
 * @param consentDictionary a dictionary for publishers to set according user consent per territorial regulations
 */
+ (void)initializeWithAppID:(NSString*)appId andUserConsent:(NSDictionary*)consentDictionary;

/*!
 * Submit external bid to be considered in auction
 * @param plc the placement associated to the bid submitted
 * @param extBid the partner bid that is also participating
 */
+ (void)submitExternalBid:(id)extBid withPlacement:(NSString*)plc;

/*!
 * Retrieve external bids that have been submitted for auction
 * @param plc the placment associated to the bid submitted
 * @return array of external bids
 */
+ (NSArray*)externalBidsForPlacement:(NSString*)plc;

/*!
 * Clear cache of external bids for a particular placement
 * @param plc the placment associated to the the external bids
 */
+ (void)clearExternalBidCacheForPlacement:(NSString*)plc;

/*!
 * Create bid for audience bidder to reduce latency during the primary mediations waterfall
 * @param type the IMBiddingAdType ENUM to desiginate the desired ad
 * @param plc the placement associated to the bid submitted
 * @param ad the primary mediation's ad that will run the final auction
 * @param delegate a callback protocol that informs of the status of the bid
 * @return IMBidObject that holds reference to the current bid
 */
+ (IMBidObject*)createBidForAdType:(IMBiddingAdType)type withPlacement:(NSString*)plc adObj:(id)ad andDelegate:(id<IMAudienceBidderDelegate>)delegate;

/*!
 * Create bid for audience bidder with an expected window for bid response
 * @param type the IMBiddingAdType ENUM to desiginate the desired ad
 * @param plc the placement associated to the bid submitted
 * @param ad the primary mediation's ad that will run the final auction
 * @param window the time interval allowed for a bid to be submitted
 * @param delegate a callback protocol that informs of the status of the bid
 * @return IMBidObject that holds reference to the current bid
 */
+ (IMBidObject*)createBidForAdType:(IMBiddingAdType)type withPlacement:(NSString*)plc adObj:(id)ad bidWindow:(NSTimeInterval)window andDelegate:(id<IMAudienceBidderDelegate>)delegate;

/*!
 * Submit bid for audience bidder with expectation that a bid response object will be returned
 * through the delegate callback -audienceBidderDidGenerateBidResponse:
 * @param type the IMBiddingAdType ENUM to designate the desired ad
 * @param plc the placement associated to the bid submitted
 * @param delegate a callback protocol that will return a bid response
 */
+ (void)submitBidForAdType:(IMBiddingAdType)type withPlacement:(NSString*)plc andDelegate:(id<IMAudienceBidderDelegate>)delegate;

/*!
 * For rewarded ads, optionally set a user id for the ad rquested
 * @param userId the string user id to be used for rewarded ads
 */
+ (void)setRewardedUserId:(NSString*)userId;

@end

@protocol IMAudienceBidderDelegate <NSObject>
@optional

/*!
 * Callback when a bid has been submitted successfully
 * @param adObject the primary mediation ad which a bid has been added to
 */
- (void)audienceBidderDidReceiveBidFor:(id)adObject;

/*!
 * Callback when a bid has an encounted an issue during submission
 * @param adObject the primary mediation ad which failed to receive bid
 * @param error the reason for bid submission failure
 */
- (void)audienceBidderDidFailBidFor:(id)adObject withError:(NSError*)error;

/*!
 * Callback for when an ad object is not supplied and keywords will be
 * manually added by publisher.
 * @param bidResponse the bid response object that contains all relevant information about bid
 */
- (void)audienceBidderDidGenerateBidResponse:(IMBidResponse*)bidResponse;

#pragma mark - DEPRECATED CALLBACKS
- (void)audienceBidder:(IMAudienceBidder*)bidder didReceiveBidFor:(id)adObject __deprecated_msg("Please use callback -audienceBidderDidReceiveBidFor: instead");
- (void)audienceBidder:(IMAudienceBidder*)bidder didFailBidFor:(id)adObject withError:(NSError*)error __deprecated_msg("Please use callback -audienceBidderDidFailBidFor:withError: instead");

@end
