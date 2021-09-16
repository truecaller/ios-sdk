//
//  TCUpdateProfileRequest.h
//  TrueSDK
//
//  Created by Sreedeepkesav M S on 16/11/20.
//  Copyright © 2020 True Software Scandinavia AB. All rights reserved.
//

#import "TCBaseRequest.h"
#import <Foundation/Foundation.h>

typedef void(^TCUpdateProfileAPICompletionBlock)(NSError * _Nullable error);

NS_ASSUME_NONNULL_BEGIN

@interface TCUpdateProfileRequest : TCBaseRequest

- (instancetype)initWithappKey: (NSString *)appKey
                       appLink: (NSString *)appLink
                   countryCode: (NSString *)countryCode
                          auth: (NSString *)auth;

- (void)updateFirstName: (NSString *)firstName
               lastName: (NSString *)lastname
      completionHandler: (TCUpdateProfileAPICompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END
