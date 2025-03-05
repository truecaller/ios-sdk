//
//  TCGetProfileRequest.h
//  TrueSDK
//
//  Created by Sreedeepkesav M S on 18/11/20.
//  Copyright © 2020 True Software Scandinavia AB. All rights reserved.
//

#import "TCBaseRequest.h"
#import "TCTrueProfile.h"

typedef void(^TCGetProfileRequestCompletionBlock)(TCTrueProfile * _Nullable profile, NSError * _Nullable error);

NS_ASSUME_NONNULL_BEGIN

@interface TCGetProfileRequest : TCBaseRequest

- (instancetype)initWithappKey: (NSString *)appKey
                       appLink: (NSString *)appLink
                   countryCode: (NSString *)countryCode
                          auth: (NSString *)auth;

- (void)getProfileWithCompletion: (TCGetProfileRequestCompletionBlock)completionBlock;

@end

NS_ASSUME_NONNULL_END
