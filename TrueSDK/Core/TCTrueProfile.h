//
//  TCTrueProfile.h
//  TrueSDK
//
//  Created by Stefan Stolevski on 21/12/16.
//  Copyright © 2016 True Software Scandinavia AB. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 * @header TCTrueProfile.h
 * @brief The True Profile info returned via delegate methods once the user accepts to continue the Autofill with Truecaller process
 */

extern NSString *__nonnull const kTrueProfileFirstNameKey;
extern NSString *__nonnull const kTrueProfileLastNameKey;
extern NSString *__nonnull const kTrueProfilePhoneNumberKey;
extern NSString *__nonnull const kTrueProfileGenderKey;
extern NSString *__nonnull const kTrueProfileCountryCodeKey;
extern NSString *__nonnull const kTrueProfileStreetKey;
extern NSString *__nonnull const kTrueProfileCityKey;
extern NSString *__nonnull const kTrueProfileZipCodeKey;
extern NSString *__nonnull const kTrueProfileFacebookIdKey;
extern NSString *__nonnull const kTrueProfileTwitterIdKey;
extern NSString *__nonnull const kTrueProfileEmailKey;
extern NSString *__nonnull const kTrueProfileUrlKey;
extern NSString *__nonnull const kTrueProfileAvatarUrlKey;
extern NSString *__nonnull const kTrueProfileJobTitleKey;
extern NSString *__nonnull const kTrueProfileCompanyNameKey;
extern NSString *__nonnull const kTrueProfileIsVerifiedKey;
extern NSString *__nonnull const kTrueProfileIsAmbassadorKey;

/*!
 * @typedef TCTrueSDKGender
 * @brief A list of gender types supported by TrueSDK
 * @constant TCTrueSDKGenderNotSpecified The user did not want to specify their gender.
 * @constant TCTrueSDKGenderMale The user gender is male.
 * @constant TCTrueSDKGenderFemale The user gender is female.
 */
typedef NS_ENUM(NSUInteger, TCTrueSDKGender) {
    TCTrueSDKGenderNotSpecified = 0, //
    TCTrueSDKGenderMale, //
    TCTrueSDKGenderFemale, //
};

/*!
 * @class TCTrueProfile
 * @brief The True Profile info returned.
 */

@interface TCTrueProfile : NSObject <NSCoding>

/*! @property firstName @brief User's first name */
@property (nonatomic, strong, nullable, readonly) NSString *firstName;
/*! @property lastName @brief User's last name */
@property (nonatomic, strong, nullable, readonly) NSString *lastName;
/*! @property phoneNumber @brief User's phone number */
@property (nonatomic, strong, nullable, readonly) NSString *phoneNumber;
/*! @property countryCode @brief User's country code */
@property (nonatomic, strong, nullable, readonly) NSString *countryCode;
/*! @property street @brief User's street address */
@property (nonatomic, strong, nullable, readonly) NSString *street;
/*! @property city @brief User's city */
@property (nonatomic, strong, nullable, readonly) NSString *city;
/*! @property zipCode @brief User's zip code */
@property (nonatomic, strong, nullable, readonly) NSString *zipCode;
/*! @property facebookID @brief User's facebook id */
@property (nonatomic, strong, nullable, readonly) NSString *facebookID;
/*! @property twitterID @brief User's twitter id */
@property (nonatomic, strong, nullable, readonly) NSString *twitterID;
/*! @property email @brief User's email */
@property (nonatomic, strong, nullable, readonly) NSString *email;
/*! @property url @brief User's Truecaller profile url */
@property (nonatomic, strong, nullable, readonly) NSString *url;
/*! @property avatarURL @brief User's avatar url */
@property (nonatomic, strong, nullable, readonly) NSString *avatarURL;
/*! @property jobTitle @brief User's job title */
@property (nonatomic, strong, nullable, readonly) NSString *jobTitle;
/*! @property companyName @brief User's company name */
@property (nonatomic, strong, nullable, readonly) NSString *companyName;
/*! @property gender @brief User's gender */
@property (nonatomic, assign, readonly) TCTrueSDKGender gender;
/*! @property isVerified @brief User's account special verification status */
@property (nonatomic, assign, readonly) BOOL isVerified;
/*! @property isAmbassador @brief Is the user a Truecaller ambasador */
@property (nonatomic, assign, readonly) BOOL isAmbassador;

- (nullable instancetype)initWithDictionary:(nullable NSDictionary *)dict;

@end
