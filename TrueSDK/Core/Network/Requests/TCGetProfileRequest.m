//
//  TCGetProfileRequest.m
//  TrueSDK
//
//  Created by Sreedeepkesav M S on 18/11/20.
//  Copyright © 2020 True Software Scandinavia AB. All rights reserved.
//

#import "TCGetProfileRequest.h"
#import "NSURL+TrueSDK.h"
#import "TCError.h"

@interface TCGetProfileRequest()

@property (nonatomic, strong) NSString *auth;

@end


@implementation TCGetProfileRequest

- (instancetype)initWithappKey: (NSString *)appKey
                       appLink: (NSString *)appLink
                   countryCode: (NSString *)countryCode
                          auth: (NSString *)auth {
    NSURL *url = [NSURL baseUrlForCountryCode:countryCode];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", url.absoluteString, @"/v1/profile"];
    self = [super initWithappKey:appKey
                         appLink:appLink
                      httpMethod:@"GET"
                       urlString:urlString];
    self.auth = auth;
    return self;
}

- (void)getProfileWithCompletion: (TCGetProfileRequestCompletionBlock)completionBlock {
    [self makeGetRequest:self.auth
              completion:^(NSDictionary * _Nullable response,
                           NSError * _Nullable error) {
        if (error == nil) {
            TCError *verificationError = [TCError errorWithDictionary:response];
            if (verificationError == nil) {
                TCTrueProfile *profile = [[TCTrueProfile alloc] initWithDictionary:response];
                completionBlock(profile, nil);
            } else {
                completionBlock(nil, verificationError);
            }
        } else {
            completionBlock(nil, error);
        }
    }];
}

@end
