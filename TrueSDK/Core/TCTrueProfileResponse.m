//
//  TCTrueProfileResponse.m
//  TrueSDK
//
//  Created by Guven Iscan on 11/01/2017.
//  Copyright © 2017 True Software Scandinavia AB. All rights reserved.
//

#import "TCTrueProfileResponse.h"

NSString *const kTrueProfileResponsePayloadKey = @"payload";
NSString *const kTrueProfileResponseSignatureKey = @"signature";
NSString *const kTrueProfileResponseSignatureAlgorithmKey = @"signatureAlgorithm";
NSString *const kTrueProfileResponseRequestNonceKey = @"requestNonce";

@interface TCTrueProfileResponse ()

@property (nonatomic, strong, readwrite) NSString *payload;
@property (nonatomic, strong, readwrite) NSString *signature;
@property (nonatomic, strong, readwrite) NSString *signatureAlgorithm;
@property (nonatomic, strong, readwrite) NSString *requestNonce;

@end

@implementation TCTrueProfileResponse

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.payload forKey:kTrueProfileResponsePayloadKey];
    [aCoder encodeObject:self.signature forKey:kTrueProfileResponseSignatureKey];
    [aCoder encodeObject:self.signatureAlgorithm forKey:kTrueProfileResponseSignatureAlgorithmKey];
    [aCoder encodeObject:self.requestNonce forKey:kTrueProfileResponseRequestNonceKey];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self != nil) {
        _payload = [aDecoder decodeObjectForKey:kTrueProfileResponsePayloadKey];
        _signature = [aDecoder decodeObjectForKey:kTrueProfileResponseSignatureKey];
        _signatureAlgorithm = [aDecoder decodeObjectForKey:kTrueProfileResponseSignatureAlgorithmKey];
        _requestNonce = [aDecoder decodeObjectForKey:kTrueProfileResponseRequestNonceKey];
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *) dictionary {
    self = [super init];
    if (self != nil) {
        self.payload = dictionary[kTrueProfileResponsePayloadKey];
        self.signature = dictionary[kTrueProfileResponseSignatureKey];
        self.signatureAlgorithm = dictionary[kTrueProfileResponseSignatureAlgorithmKey];
        self.requestNonce = dictionary[kTrueProfileResponseRequestNonceKey];
    }
    
    return self;
}

@end
