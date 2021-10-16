//
//  TCTrueProfileResponse.h
//  TrueSDK
//
//  Created by Guven Iscan on 11/01/2017.
//  Copyright © 2017 True Software Scandinavia AB. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *__nonnull const kTrueProfileResponsePayloadKey;
extern NSString *__nonnull const kTrueProfileResponseSignatureKey;
extern NSString *__nonnull const kTrueProfileResponseSignatureAlgorithmKey;
extern NSString *__nonnull const kTrueProfileResponseRequestNonceKey;

@interface TCTrueProfileResponse : NSObject <NSCoding>

@property (nonatomic, nullable, readonly) NSString *payload;
@property (nonatomic, nullable, readonly) NSString *signature;
@property (nonatomic, nullable, readonly) NSString *signatureAlgorithm;
@property (nonatomic, nullable, readonly) NSString *requestNonce;

- (nullable instancetype)initWithDictionary:(nullable NSDictionary *) dictionary;

@end
