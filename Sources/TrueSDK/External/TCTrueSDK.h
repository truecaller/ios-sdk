//
//  TCTrueSDK.h
//  TrueSDK
//
//  Created by Stefan Stolevski on 21/12/16.
//  Copyright © 2016 True Software Scandinavia AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TCTrueProfile.h"
#import "TCError.h"
#import "TCTrueProfileResponse.h"
#import "TCTrueProfileRequest.h"
#import "TCVerificationState.h"
#import "TCError.h"

@protocol TCTrueSDKViewDelegate <NSObject>

@end

@protocol TCTrueSDKDelegate <NSObject>

@optional

/*!
 * @discussion Returns the nonce string for the last request, when the SDK returns
 * a profile response you may check it against this nonce and verify they match.
 * TrueSDK makes the automatically for you before sharing the response.
 * @param nonce Request's unique identifier
 */
- (void)willRequestProfileWithNonce:(nonnull NSString *)nonce;

/*!
 * @brief Use this optional delegate method to get the whole response instance and implement additional security checks
 * @param profileResponse The profile response which contains the payload, signature and nonce
 */
- (void)didReceiveTrueProfileResponse:(nonnull TCTrueProfileResponse *)profileResponse;

/*!
 * @brief Use this optional delegate method to get the  status updates while verifying non truecaller users. OTP based verification.
 * @param verificationState The profile response which contains the payload, signature and nonce
 */
- (void)verificationStatusChangedTo:(TCVerificationState)verificationState;

@required

/*!
 * @brief Use this delegate method to handle the retrieved True Profile of the user
 * @param profile The True Profile of the user
 */
- (void)didReceiveTrueProfile:(nonnull TCTrueProfile *)profile;


/*!
 * @brief Use this delegate method to find out what went wrong and why the True Profile could not be retrieved
 * @param error TCError with custom error codes and descriptions (see TCTrueSDKErrorCode)
 */
- (void)didFailToReceiveTrueProfileWithError:(nonnull TCError *)error;

@end

/*!
 * @header TCTrueSDK.h
 * @brief The main class of the TrueSDK framework. Use this class and its singleton to invoke all the TrueSDK methods.
 */

@interface TCTrueSDK : NSObject

@property (nonatomic, weak, nullable) id<TCTrueSDKDelegate> delegate;
@property (nonatomic) TitleType titleType;
@property (nonatomic, nullable) NSString* locale;
@property (nonatomic, weak, nullable) UIViewController<TCTrueSDKViewDelegate> *viewDelegate;

+ (nonnull TCTrueSDK *)sharedManager;

/*!
 * @discussion Check if the current device supports TrueSDK.
 * Althought you can integrate TrueSDK in iOS8, for iOS8 it always returns false.
 * For iOS9 and above it checks whether the user has an app installed that supports the TrueSDK schema.
 * Since we can not register this as a unique schema other apps could register it as well,
 * in which case the method will return a false positive.
 * @return true if supported otherwise false
 */
- (BOOL)isSupported;

/*!
 * @brief Setup by providing the Partner Key and the App Link. SDK needs to be set up before any request.
 * @param appKey Your App Key provided by Truecaller
 * @param appLink Your App Link url string provided by Truecaller
 */
- (void)setupWithAppKey:(nonnull NSString *)appKey
                appLink:(nonnull NSString *)appLink;

/*!
* @brief Setup by providing the Partner Key and the App Link. SDK needs to be set up before any request.
* @param appKey Your App Key provided by Truecaller
* @param appLink Your App Link url string provided by Truecaller
* @param requestNonce Your App generated custom nonce
*/
- (void)setupWithAppKey:(nonnull NSString *)appKey
                appLink:(nonnull NSString *)appLink
           requestNonce:(nonnull NSString *)requestNonce;

/*!
 * @brief Call this method to request the True Profile for a user. Make sure you set the delegate first.
 */
- (void)requestTrueProfile;

/*!
 * @brief Call this method in application:continueUserActivity:restorationHandler: of the App Delegate class.
 * @return true if TrueSDK can handle the URL request
 */
- (BOOL)application:(nonnull UIApplication *)application
continueUserActivity:(nonnull NSUserActivity *)userActivity
 restorationHandler:(nullable void (^)(NSArray * _Nullable restorableObjects))restorationHandler;

/*!
 * @brief Call this method in application:openURL:options: of the App Delegate class.
 * @return true if TrueSDK can handle the URL request
 */
-(BOOL)continueWithUrlScheme:(nonnull NSURL *)url;

/*!
 * @brief Call this method in application:continueUserActivity:restorationHandler: of the App Delegate class.
 * @param phone Phone number you want to get the login code in.
 * @param countryCode Country code as String (eg: "in" for india "sv" for sweden) of the phone number passed.
 */

- (void)requestVerificationForPhone: (nonnull NSString *)phone
                        countryCode: (nonnull NSString *)countryCode;

/*!
 * @brief Call this method after receiving one time code with the code.
 * @param code One time password received.
 */

- (void)verifySecurityCode: (nonnull NSString *)code
        andUpdateFirstname: (nonnull NSString *)firstName
                  lastName: (nonnull NSString *)lastName;

/*!
 * @discussion Access token for back end verification of the data received
 * @return Access token provided by truecaller backend on succesfull verification
 */
- (nullable NSString *)accessTokenForOTPVerification;

/*!
 * @discussion TTL(Time To Live) for the otp received. In seconds.
 * @return TTL provided by the backend for OTP
 */
- (nullable NSNumber*)tokenTtl;

/*!
 * @brief Call this method in scene:continueUserActivity of the Scene Delegate class.
 */

- (void)scene:(nonnull UIScene *)scene
continueUserActivity:(nonnull NSUserActivity *)userActivity API_AVAILABLE(ios(13.0));

@end
