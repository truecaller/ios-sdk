//
//  TCTrueProfileResponse.m
//  TrueSDK
//
//  Created by Guven Iscan on 11/01/2017.
//  Copyright © 2017 True Software Scandinavia AB. All rights reserved.
//

#import "TCTrueProfileResponse.h"

static NSString *kPayloadKey = @"payload";
static NSString *kSignatureKey = @"signature";
static NSString *kSignatureAlgorithmKey = @"signatureAlgorithm";
static NSString *kRequestNonceKey = @"requestNonce";

@implementation TCTrueProfileResponse

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.payload forKey:kPayloadKey];
    [aCoder encodeObject:self.signature forKey:kSignatureKey];
    [aCoder encodeObject:self.signatureAlgorithm forKey:kSignatureAlgorithmKey];
    [aCoder encodeObject:self.requestNonce forKey:kRequestNonceKey];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self != nil) {
        _payload = [aDecoder decodeObjectForKey:kPayloadKey];
        _signature = [aDecoder decodeObjectForKey:kSignatureKey];
        _signatureAlgorithm = [aDecoder decodeObjectForKey:kSignatureAlgorithmKey];
        _requestNonce = [aDecoder decodeObjectForKey:kRequestNonceKey];
    }
    return self;
}

@end
