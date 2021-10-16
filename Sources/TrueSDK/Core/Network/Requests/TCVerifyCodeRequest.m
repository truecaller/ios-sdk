//
//  TCVerifyCodeRequest.m
//  TrueSDK
//
//  Created by Sreedeepkesav M S on 12/11/20.
//  Copyright © 2020 True Software Scandinavia AB. All rights reserved.
//

#import "TCVerifyCodeRequest.h"
#import "TCError.h"

NSString *const verifyCodeUrl = @"https://api4.truecaller.com/v1/otp/installation/verify";

@implementation TCVerifyCodeRequest

- (instancetype)initWithappKey: (NSString *)appKey
                       appLink: (NSString *)appLink {
    self = [super initWithappKey:appKey
                         appLink:appLink
                      httpMethod:@"POST"
                       urlString:verifyCodeUrl];
    return self;
}

- (void)verifyLoginCodeForPhoneNumber: (NSString *)phone
                          countryCode: (NSString *)countryCode
                     verificationCode: (NSString *)code
                    verificationToken: (NSString *)verificationToken
                           completion: (TCVerifyCodeAPICompletionBlock)completionBlock {
    NSDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    [parameters setValue:countryCode forKey:@"countryCodeName"];
    [parameters setValue:phone forKey:@"phoneNumber"];
    [parameters setValue:code forKey:@"secretToken"];
    [parameters setValue:verificationToken forKey:@"verificationToken"];
    
    [self makeRequestWithParemeters:parameters
                    useCommonParams: NO
                         completion:^(NSDictionary * _Nullable response,
                                      NSError * _Nullable error) {
        if (error == nil) {
            TCError *verificationError = [TCError errorWithDictionary:response];
            if (verificationError == nil) {
                TCLoginCodeResponse *loginCodeResponse = [[TCLoginCodeResponse alloc] initWithDictionary:response];
                completionBlock(loginCodeResponse, nil);
            } else {
                completionBlock(nil, verificationError);
            }
        } else {
            completionBlock(nil, error);
        }
    }];
}

@end
