//
//  TCTrueProfile.m
//  TrueSDK
//
//  Created by Stefan Stolevski on 21/12/16.
//  Copyright © 2016 True Software Scandinavia AB. All rights reserved.
//

#import "TCTrueProfile.h"

NSString *const kFirstNameKey = @"firstName";
NSString *const kLastNameKey = @"lastName";
NSString *const kPhoneNumberKey = @"phoneNumber";
NSString *const kGenderKey = @"gender";
NSString *const kCountryCodeKey = @"countryCode";
NSString *const kStreetKey = @"street";
NSString *const kCityKey = @"city";
NSString *const kZipCodeKey = @"zipcode";
NSString *const kFacebookIdKey = @"facebookID";
NSString *const kTwitterIdKey = @"twitterID";
NSString *const kEmailKey = @"email";
NSString *const kUrlKey = @"url";
NSString *const kAvatarUrlKey = @"avatarUrl";
NSString *const kJobTitleKey = @"jobTitle";
NSString *const kCompanyNameKey = @"companyName";
NSString *const kIsVerifiedKey = @"isTrueName";
NSString *const kIsAmbassadorKey = @"isAmbassador";

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
    [aCoder encodeObject:self.firstName forKey:kFirstNameKey];
    [aCoder encodeObject:self.lastName forKey:kLastNameKey];
    [aCoder encodeObject:self.phoneNumber forKey:kPhoneNumberKey];
    [aCoder encodeObject:self.genderValue forKey:kGenderKey];
    [aCoder encodeObject:self.countryCode forKey:kCountryCodeKey];
    [aCoder encodeObject:self.street forKey:kStreetKey];
    [aCoder encodeObject:self.city forKey:kCityKey];
    [aCoder encodeObject:self.zipCode forKey:kZipCodeKey];
    [aCoder encodeObject:self.facebookID forKey:kFacebookIdKey];
    [aCoder encodeObject:self.twitterID forKey:kTwitterIdKey];
    [aCoder encodeObject:self.email forKey:kEmailKey];
    [aCoder encodeObject:self.url forKey:kUrlKey];
    [aCoder encodeObject:self.avatarURL forKey:kAvatarUrlKey];
    [aCoder encodeObject:self.jobTitle forKey:kJobTitleKey];
    [aCoder encodeObject:self.companyName forKey:kCompanyNameKey];
    [aCoder encodeBool:self.isVerified forKey:kIsVerifiedKey];
    [aCoder encodeBool:self.isAmbassador forKey:kIsAmbassadorKey];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self != nil) {
        _firstName = [aDecoder decodeObjectForKey:kFirstNameKey];
        _lastName = [aDecoder decodeObjectForKey:kLastNameKey];
        _phoneNumber = [aDecoder decodeObjectForKey:kPhoneNumberKey];
        _genderValue = [aDecoder decodeObjectForKey:kGenderKey];
        _countryCode = [aDecoder decodeObjectForKey:kCountryCodeKey];
        _street = [aDecoder decodeObjectForKey:kStreetKey];
        _city = [aDecoder decodeObjectForKey:kCityKey];
        _zipCode = [aDecoder decodeObjectForKey:kZipCodeKey];
        _facebookID = [aDecoder decodeObjectForKey:kFacebookIdKey];
        _twitterID = [aDecoder decodeObjectForKey:kTwitterIdKey];
        _email = [aDecoder decodeObjectForKey:kEmailKey];
        _url = [aDecoder decodeObjectForKey:kUrlKey];
        _avatarURL = [aDecoder decodeObjectForKey:kAvatarUrlKey];
        _jobTitle = [aDecoder decodeObjectForKey:kJobTitleKey];
        _companyName = [aDecoder decodeObjectForKey:kCompanyNameKey];
        _isVerified = [aDecoder decodeBoolForKey:kIsVerifiedKey];
        _isAmbassador = [aDecoder decodeBoolForKey:kIsAmbassadorKey];
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self != nil) {
        _firstName = dict[kFirstNameKey];
        _lastName = dict[kLastNameKey];
        _phoneNumber = dict[kPhoneNumberKey];
        _genderValue = dict[kGenderKey];
        _countryCode = dict[kCountryCodeKey];
        _street = dict[kStreetKey];
        _city = dict[kCityKey];
        _zipCode = dict[kZipCodeKey];
        _facebookID = dict[kFacebookIdKey];
        _twitterID = dict[kTwitterIdKey];
        _email = dict[kEmailKey];
        _url = dict[kUrlKey];
        _avatarURL = dict[kAvatarUrlKey];
        _jobTitle = dict[kJobTitleKey];
        _companyName = dict[kCompanyNameKey];
        _isVerified = [dict[kIsVerifiedKey] boolValue];
        _isAmbassador = [dict[kIsAmbassadorKey] boolValue];
    }
    
    return self;
}

@end
