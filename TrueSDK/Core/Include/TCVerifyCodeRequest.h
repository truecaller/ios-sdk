//
//  TCVerifyCodeRequest.h
//  TrueSDK
//
//  Created by Sreedeepkesav M S on 12/11/20.
//  Copyright © 2020 True Software Scandinavia AB. All rights reserved.
//

#import "TCBaseRequest.h"
#import "TCLoginCodeResponse.h"

typedef void(^TCVerifyCodeAPICompletionBlock)(TCLoginCodeResponse * _Nullable response, NSError * _Nullable error);

NS_ASSUME_NONNULL_BEGIN

@interface TCVerifyCodeRequest : TCBaseRequest

- (instancetype)initWithappKey: (NSString *)appKey
                       appLink: (NSString *)appLink;

- (void)verifyLoginCodeForPhoneNumber: (NSString *)phone
                          countryCode: (NSString *)countryCode
                     verificationCode: (NSString *)code
                    verificationToken: (NSString *)verificationToken
                           completion: (TCVerifyCodeAPICompletionBlock)completionBlock;
                            

@end

NS_ASSUME_NONNULL_END
