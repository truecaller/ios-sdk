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
 * @brief Call this method to request the True Profile for a user. Make sure you set the delegate first.
 */
- (void)requestTrueProfile;

/*!
 * @brief Call this method in application:continueUserActivity:restorationHandler: of the App Delegate class.
 * @return true if TrueSDK can handle the URL request
 */
- (BOOL)application:(nonnull UIApplication *)application continueUserActivity:(nonnull NSUserActivity *)userActivity restorationHandler:(nullable void (^)(NSArray * _Nullable restorableObjects))restorationHandler;

@end
