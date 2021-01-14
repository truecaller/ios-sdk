//
//  TCLoginCodeResponse.h
//  TrueSDK
//
//  Created by Sreedeepkesav M S on 11/11/20.
//  Copyright © 2020 True Software Scandinavia AB. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *__nonnull const kTCLoginCodeResponseVerificationToken;
extern NSString *__nonnull const kTCLoginCodeResponseAccessToken;
extern NSString *__nonnull const kTCLoginCodeResponseStatus;
extern NSString *__nonnull const kTCLoginCodeResponseMessage;
extern NSString *__nonnull const kTCLoginCodeResponseMethod;
extern NSString *__nonnull const kTCLoginCodeResponseTokenTtl;

NS_ASSUME_NONNULL_BEGIN

@interface TCLoginCodeResponse : NSObject

@property (nonatomic, nullable, readonly) NSString *verificationToken;
@property (nonatomic, nullable, readonly) NSString *accessToken;
@property (nonatomic, nullable, readonly) NSNumber *status;
@property (nonatomic, nullable, readonly) NSString *message;
@property (nonatomic, nullable, readonly) NSString *method;
@property (nonatomic, nullable, readonly) NSNumber *tokenTtl;

- (nullable instancetype)initWithDictionary:(nullable NSDictionary *) dictionary;

@end

NS_ASSUME_NONNULL_END
