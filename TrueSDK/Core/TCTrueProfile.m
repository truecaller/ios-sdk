//
//  TCTrueProfile.m
//  TrueSDK
//
//  Created by Stefan Stolevski on 21/12/16.
//  Copyright © 2016 True Software Scandinavia AB. All rights reserved.
//

#import "TCTrueProfile.h"

NSString *const kTrueProfileFirstNameKey = @"firstName";
NSString *const kTrueProfileLastNameKey = @"lastName";
NSString *const kTrueProfilePhoneNumberKey = @"phoneNumber";
NSString *const kTrueProfileGenderKey = @"gender";
NSString *const kTrueProfileCountryCodeKey = @"countryCode";
NSString *const kTrueProfileStreetKey = @"street";
NSString *const kTrueProfileCityKey = @"city";
NSString *const kTrueProfileZipCodeKey = @"zipcode";
NSString *const kTrueProfileFacebookIdKey = @"facebookID";
NSString *const kTrueProfileTwitterIdKey = @"twitterID";
NSString *const kTrueProfileEmailKey = @"email";
NSString *const kTrueProfileUrlKey = @"url";
NSString *const kTrueProfileAvatarUrlKey = @"avatarUrl";
NSString *const kTrueProfileJobTitleKey = @"jobTitle";
NSString *const kTrueProfileCompanyNameKey = @"companyName";
NSString *const kTrueProfileIsVerifiedKey = @"isTrueName";
NSString *const kTrueProfileIsAmbassadorKey = @"isAmbassador";

@interface TCTrueProfile()

/**
 TCTrueSDKGender gender
 It is only used as a wrapper around the real value which is private
 : genderValue
 */

//Private
@property (nonatomic, strong, nullable, readwrite) NSString *genderValue;
//Public
@property (nonatomic, strong, nullable, readwrite) NSString *firstName;
@property (nonatomic, strong, nullable, readwrite) NSString *lastName;
@property (nonatomic, strong, nullable, readwrite) NSString *phoneNumber;
@property (nonatomic, strong, nullable, readwrite) NSString *countryCode;
@property (nonatomic, strong, nullable, readwrite) NSString *street;
@property (nonatomic, strong, nullable, readwrite) NSString *city;
@property (nonatomic, strong, nullable, readwrite) NSString *zipCode;
@property (nonatomic, strong, nullable, readwrite) NSString *facebookID;
@property (nonatomic, strong, nullable, readwrite) NSString *twitterID;
@property (nonatomic, strong, nullable, readwrite) NSString *email;
@property (nonatomic, strong, nullable, readwrite) NSString *url;
@property (nonatomic, strong, nullable, readwrite) NSString *avatarURL;
@property (nonatomic, strong, nullable, readwrite) NSString *jobTitle;
@property (nonatomic, strong, nullable, readwrite) NSString *companyName;
@property (nonatomic, assign, readwrite) BOOL isVerified;
@property (nonatomic, assign, readwrite) BOOL isAmbassador;

@end

@implementation TCTrueProfile

- (TCTrueSDKGender)gender
{
    if ([self.genderValue.lowercaseString isEqualToString:@"m"]) {
        return TCTrueSDKGenderMale;
    }
    
    if ([self.genderValue.lowercaseString isEqualToString:@"f"]) {
        return TCTrueSDKGenderFemale;
    }
    
    return TCTrueSDKGenderNotSpecified;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.firstName forKey:kTrueProfileFirstNameKey];
    [aCoder encodeObject:self.lastName forKey:kTrueProfileLastNameKey];
    [aCoder encodeObject:self.phoneNumber forKey:kTrueProfilePhoneNumberKey];
    [aCoder encodeObject:self.genderValue forKey:kTrueProfileGenderKey];
    [aCoder encodeObject:self.countryCode forKey:kTrueProfileCountryCodeKey];
    [aCoder encodeObject:self.street forKey:kTrueProfileStreetKey];
    [aCoder encodeObject:self.city forKey:kTrueProfileCityKey];
    [aCoder encodeObject:self.zipCode forKey:kTrueProfileZipCodeKey];
    [aCoder encodeObject:self.facebookID forKey:kTrueProfileFacebookIdKey];
    [aCoder encodeObject:self.twitterID forKey:kTrueProfileTwitterIdKey];
    [aCoder encodeObject:self.email forKey:kTrueProfileEmailKey];
    [aCoder encodeObject:self.url forKey:kTrueProfileUrlKey];
    [aCoder encodeObject:self.avatarURL forKey:kTrueProfileAvatarUrlKey];
    [aCoder encodeObject:self.jobTitle forKey:kTrueProfileJobTitleKey];
    [aCoder encodeObject:self.companyName forKey:kTrueProfileCompanyNameKey];
    [aCoder encodeBool:self.isVerified forKey:kTrueProfileIsVerifiedKey];
    [aCoder encodeBool:self.isAmbassador forKey:kTrueProfileIsAmbassadorKey];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self != nil) {
        _firstName = [aDecoder decodeObjectForKey:kTrueProfileFirstNameKey];
        _lastName = [aDecoder decodeObjectForKey:kTrueProfileLastNameKey];
        _phoneNumber = [aDecoder decodeObjectForKey:kTrueProfilePhoneNumberKey];
        _genderValue = [aDecoder decodeObjectForKey:kTrueProfileGenderKey];
        _countryCode = [aDecoder decodeObjectForKey:kTrueProfileCountryCodeKey];
        _street = [aDecoder decodeObjectForKey:kTrueProfileStreetKey];
        _city = [aDecoder decodeObjectForKey:kTrueProfileCityKey];
        _zipCode = [aDecoder decodeObjectForKey:kTrueProfileZipCodeKey];
        _facebookID = [aDecoder decodeObjectForKey:kTrueProfileFacebookIdKey];
        _twitterID = [aDecoder decodeObjectForKey:kTrueProfileTwitterIdKey];
        _email = [aDecoder decodeObjectForKey:kTrueProfileEmailKey];
        _url = [aDecoder decodeObjectForKey:kTrueProfileUrlKey];
        _avatarURL = [aDecoder decodeObjectForKey:kTrueProfileAvatarUrlKey];
        _jobTitle = [aDecoder decodeObjectForKey:kTrueProfileJobTitleKey];
        _companyName = [aDecoder decodeObjectForKey:kTrueProfileCompanyNameKey];
        _isVerified = [aDecoder decodeBoolForKey:kTrueProfileIsVerifiedKey];
        _isAmbassador = [aDecoder decodeBoolForKey:kTrueProfileIsAmbassadorKey];
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self != nil) {
        _firstName = dict[kTrueProfileFirstNameKey];
        _lastName = dict[kTrueProfileLastNameKey];
        _phoneNumber = dict[kTrueProfilePhoneNumberKey];
        _genderValue = dict[kTrueProfileGenderKey];
        _countryCode = dict[kTrueProfileCountryCodeKey];
        _street = dict[kTrueProfileStreetKey];
        _city = dict[kTrueProfileCityKey];
        _zipCode = dict[kTrueProfileZipCodeKey];
        _facebookID = dict[kTrueProfileFacebookIdKey];
        _twitterID = dict[kTrueProfileTwitterIdKey];
        _email = dict[kTrueProfileEmailKey];
        _url = dict[kTrueProfileUrlKey];
        _avatarURL = dict[kTrueProfileAvatarUrlKey];
        _jobTitle = dict[kTrueProfileJobTitleKey];
        _companyName = dict[kTrueProfileCompanyNameKey];
        _isVerified = [dict[kTrueProfileIsVerifiedKey] boolValue];
        _isAmbassador = [dict[kTrueProfileIsAmbassadorKey] boolValue];
    }
    
    return self;
}

@end
