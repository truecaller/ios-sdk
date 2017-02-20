//
//  TCError.h
//  TrueSDK
//
//  Created by Stefan Stolevski on 03/01/17.
//  Copyright © 2016 True Software Scandinavia AB. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 * @typedef TCTrueSDKErrorCode
 * @brief A list of error codes returned by the TrueSDK
 * @constant TCTrueSDKErrorCodeAppKeyMissing The App Key is a mandatory field. It is provided to you by Truecaller.
 * @constant TCTrueSDKErrorCodeAppLinkMissing The App Link is a mandatory field. It is provided to you by Truecaller.
 * @constant TCTrueSDKErrorCodeUserCancelled The user has decided to cancel (abort) the operation of providing TrueProfile info to your app
 * @constant TCTrueSDKErrorCodeUserNotSignedIn The user has not signed in using the Truecaller app yet
 * @constant TCTrueSDKErrorCodeSDKTooOld The SDK version is old and not compatible with the Truecaller app
 * @constant TCTrueSDKErrorCodeTruecallerTooOld The Truecaller version is old and not compatible with the SDK version
 * @constant TCTrueSDKErrorCodeOSNotSupported Current version of the iOS is not supported
 * @constant TCTrueSDKErrorCodeTruecallerNotInstalled The Truecaller app is not installed
 * @constant TCTrueSDKErrorCodeNetwork Error occurred in network communication or no network connectivity
 * @constant TCTrueSDKErrorCodeInternal Truecaller internal error. Internal error.
 * @constant TCTrueSDKErrorCodeUnauthorizedUser The user has not been authorized by Truecaller servers.
 * @constant TCTrueSDKErrorCodeUnauthorizedDeveloper The credentials cannot be verified. Internal error.
 * @constant TCTrueSDKErrorCodeUserProfileContentNotValid The Profile content is not valid. Internal error.
 * @constant TCTrueSDKErrorCodeBadRequest Bad request. Internal error.
 * @constant TCTrueSDKErrorCodeVerificationFailed The response signature could not be verified. Internal error.
 * @constant TCTrueSDKErrorCodeRequestNonceMismatch The request's nonce does not match the nonce in response. Internal error.
 */

typedef NS_ENUM(NSUInteger, TCTrueSDKErrorCode) {
    TCTrueSDKErrorCodeAppKeyMissing = 1, //
    TCTrueSDKErrorCodeAppLinkMissing, //
    TCTrueSDKErrorCodeUserCancelled, //
    TCTrueSDKErrorCodeUserNotSignedIn, //
    TCTrueSDKErrorCodeSDKTooOld, //
    TCTrueSDKErrorCodeTruecallerTooOld, //
    TCTrueSDKErrorCodeOSNotSupported, //
    TCTrueSDKErrorCodeTruecallerNotInstalled, //
    TCTrueSDKErrorCodeNetwork, //
    TCTrueSDKErrorCodeInternal, //
    TCTrueSDKErrorCodeUnauthorizedUser, //
    TCTrueSDKErrorCodeUnauthorizedDeveloper, //
    TCTrueSDKErrorCodeUserProfileContentNotValid, //
    TCTrueSDKErrorCodeBadRequest, //
    TCTrueSDKErrorCodeVerificationFailed, //
    TCTrueSDKErrorCodeRequestNonceMismatch, //
};

/*!
 * @header TCError.h
 * @brief Class for the error objects return by the TrueSDK
 */

@interface TCError : NSError
/*!
 * @brief Method for returning the error code for a given error object
 * @return TCTrueSDKErrorCode code
 */
- (TCTrueSDKErrorCode)getErrorCode;

/*!
 * @brief Method for creating an error object given an error code. Intended for internal usage.
 * @param code Error code
 * @return TCError Error object
 */
+ (TCError *)errorWithCode:(TCTrueSDKErrorCode)code;

/*!
 * @brief Method for creating an error object given an error code and description. Intended for internal usage.
 * @param code Error code
 * @param errorDescription Error description
 * @return TCError Error object
 */
+ (TCError *)errorWithCode:(TCTrueSDKErrorCode)code
               description:(NSString *)errorDescription;
@end
