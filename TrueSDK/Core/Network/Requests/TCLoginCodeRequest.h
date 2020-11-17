//
//  TCLoginCodeRequest.h
//  TrueSDK
//
//  Created by Sreedeepkesav M S on 10/11/20.
//  Copyright © 2020 True Software Scandinavia AB. All rights reserved.
//

#import "TCBaseRequest.h"
#import "TCLoginCodeResponse.h"

typedef void(^LoginCodeAPICompletionBlock)(TCLoginCodeResponse * _Nullable response, NSError * _Nullable error);

NS_ASSUME_NONNULL_BEGIN

@interface TCLoginCodeRequest : TCBaseRequest

- (instancetype)initWithappKey: (NSString *)appKey
                       appLink: (NSString *)appLink;

- (void)requestLoginCodeForPhoneNumber: (NSString *)phone
                           countryCode: (NSString *)countryCode
                            completion: (LoginCodeAPICompletionBlock)completionBlock;

@end

NS_ASSUME_NONNULL_END
