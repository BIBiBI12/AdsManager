//
//  AerServSDK.h
//  AerServSDK
//
//  Copyright (c) 2014 AerServ, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AerServSDK : NSObject

/*!
 * Looks into the supplied app id and will run pre-initialization for any mediation partner sources that requires an extra setup phase.
 *
 * @param appId a string of the app id
 */
+ (void)initializeWithAppID:(NSString*)appId;

/*!
 * Looks into the supplied app id and will run pre-initialization for any mediation partner sources that requires an extra setup phase.
 *
 * @param appId a string of the app id
 * @param userConsent a boolean flag for GDPR user consent. Set to YES if user consent was given and NO is user consent was denied
 */
+ (void)initializeWithAppID:(NSString*)appId andGDPRUserConsent:(BOOL)userConsent;

/*!
 * Returns current AerServSDK version
 */
+ (NSString*)sdkVersion;

/*!
 * Shows console logs for debugging purposes.
 */
+ (void)showLogs:(BOOL)yesOrNo;

/*!
 * Enables testMode. If possible, this will enabled testMode for SDK mediation.
 * Please refer to online integration documentation for list of supported SDK mediations.
 */
+ (void)enableTestMode:(BOOL)yesOrNo;

/*!
 * Returns if the SDK is in testMode mode.
 */
+ (BOOL)isTestModeEnabled;

/*!
 * Returns the GDPR user consent value.
 */
+ (BOOL)getGDPRConsentValue;

/*!
 * Updates GDPR user consent. The updated GDPR user consent value will be used for all subsequent requests.
 * @param userConsent a boolean flag for GDPR user consent. Set to YES if user consent was given and NO is user consent was denied
 */
+ (void)setGDPRWithUserConsent:(BOOL)userConsent;

@end
