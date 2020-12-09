//
//  TCLoginCodeRequest.m
//  TrueSDK
//
//  Created by Sreedeepkesav M S on 10/11/20.
//  Copyright © 2020 True Software Scandinavia AB. All rights reserved.
//

#import "TCLoginCodeRequest.h"
#import "TCError.h"

NSString *const loginCodeUrl = @"https://api4.truecaller.com/v1/otp/installation/create";

@implementation TCLoginCodeRequest

- (instancetype)initWithappKey: (NSString *)appKey
                       appLink: (NSString *)appLink {
    self = [super initWithappKey:appKey
                         appLink:appLink
                      httpMethod:@"POST"
                       urlString:loginCodeUrl];
    return self;
}

- (void)requestLoginCodeForPhoneNumber: (NSString *)phone
                           countryCode: (NSString *)countryCode
                            completion: (LoginCodeAPICompletionBlock)completionBlock {
    
    NSDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:countryCode forKey:@"countryCodeName"];
    [parameters setValue:phone forKey:@"phoneNumber"];
    
    [self makeRequestWithParemeters:parameters
                    useCommonParams:YES
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
