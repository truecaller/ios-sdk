//
//  TCLoginCodeResponse.m
//  TrueSDK
//
//  Created by Sreedeepkesav M S on 11/11/20.
//  Copyright © 2020 True Software Scandinavia AB. All rights reserved.
//

#import "TCLoginCodeResponse.h"

NSString *const kTCLoginCodeResponseVerificationToken = @"verificationToken";
NSString *const kTCLoginCodeResponseAccessToken = @"accessToken";
NSString *const kTCLoginCodeResponseStatus = @"status";
NSString *const kTCLoginCodeResponseMessage = @"message";
NSString *const kTCLoginCodeResponseMethod = @"method";

@interface TCLoginCodeResponse ()

@property (nonatomic, strong, readwrite) NSString *verificationToken;
@property (nonatomic, strong, readwrite) NSString *accessToken;
@property (nonatomic, strong, readwrite) NSNumber *status;
@property (nonatomic, strong, readwrite) NSString *message;
@property (nonatomic, strong, readwrite) NSString *method;

@end

@implementation TCLoginCodeResponse

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.verificationToken forKey:kTCLoginCodeResponseVerificationToken];
    [aCoder encodeObject:self.accessToken forKey:kTCLoginCodeResponseAccessToken];
    [aCoder encodeObject:self.status forKey:kTCLoginCodeResponseStatus];
    [aCoder encodeObject:self.message forKey:kTCLoginCodeResponseMessage];
    [aCoder encodeObject:self.method forKey:kTCLoginCodeResponseMethod];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self != nil) {
        _verificationToken = [aDecoder decodeObjectForKey:kTCLoginCodeResponseVerificationToken];
        _accessToken = [aDecoder decodeObjectForKey:kTCLoginCodeResponseAccessToken];
        _status = [aDecoder decodeObjectForKey:kTCLoginCodeResponseStatus];
        _message = [aDecoder decodeObjectForKey:kTCLoginCodeResponseMessage];
        _method = [aDecoder decodeObjectForKey:kTCLoginCodeResponseMethod];
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *) dictionary {
    self = [super init];
    if (self != nil) {
        self.verificationToken = dictionary[kTCLoginCodeResponseVerificationToken];
        self.accessToken = dictionary[kTCLoginCodeResponseAccessToken];
        self.status = dictionary[kTCLoginCodeResponseStatus];
        self.message = dictionary[kTCLoginCodeResponseMessage];
        self.method = dictionary[kTCLoginCodeResponseMethod];
    }
    
    return self;
}

@end
