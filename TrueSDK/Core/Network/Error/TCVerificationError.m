//
//  TCVerificationError.m
//  TrueSDK
//
//  Created by Sreedeepkesav M S on 11/11/20.
//  Copyright © 2020 True Software Scandinavia AB. All rights reserved.
//

#import "TCVerificationError.h"

#define kTrueSDKVerificationErrorDomain @"TrueSDKVerificationErrorDomain"
#define kTrueSDKVerificationErrorDescription NSLocalizedDescriptionKey

@implementation TCVerificationError

+ (TCVerificationError *)errorWithDictionary: (NSDictionary *)dictionary
{
    if (dictionary[@"code"] == nil) {
        return nil;
    }
    
    NSInteger code = (NSInteger)dictionary[@"code"];
    NSString *message = (NSString *)dictionary[@"message"];
    return [[self class] errorWithDomain:kTrueSDKVerificationErrorDomain
                                    code:code
                                userInfo:@{kTrueSDKVerificationErrorDescription : message ? message : @""}];
}

+ (TCVerificationError *)errorWithError: (NSError *)error {
    return [[self class] errorWithDomain:kTrueSDKVerificationErrorDomain
                                    code:error.code
                                userInfo:@{kTrueSDKVerificationErrorDescription : error.localizedDescription ? error.localizedDescription : @""}];
}

@end
