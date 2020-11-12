//
//  TCVerificationState.h
//  TrueSDK
//
//  Created by Sreedeepkesav M S on 11/11/20.
//  Copyright © 2020 True Software Scandinavia AB. All rights reserved.
//

/*!
 * @typedef TCVerificationState
 * @brief A list of states codes returned by the TrueSDK for OTP based authentication
 * @constant TCVerificationStateOTPInitiated Retruned whrn OTP is succesfully initiated by Truecaller
 * @constant TCVerificationStateOTPReceived Returned whrn OTP is succesfully registered by the partner to Truecaller.
 * @constant TCVerificationStateVerificationComplete OTP verification sucessful at Truecaller
 * @constant TCVerificationStateVerifiedBefore The user has already been signed in from this device
 */

typedef NS_ENUM(NSUInteger, TCVerificationState) {
    TCVerificationStateOTPInitiated = 0,
    TCVerificationStateOTPReceived,
    TCVerificationStateVerificationComplete,
    TCVerificationStateVerifiedBefore
};
