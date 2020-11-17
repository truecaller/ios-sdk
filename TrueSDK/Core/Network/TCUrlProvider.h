//
//  TCUrlProvider.h
//  TrueSDK
//
//  Created by Sreedeepkesav M S on 16/11/20.
//  Copyright © 2020 True Software Scandinavia AB. All rights reserved.
//

#import "TCBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface TCUrlProvider : TCBaseRequest

+ (NSURL *)baseUrlForCountryCode: (NSString *)countrycode;

@end

NS_ASSUME_NONNULL_END
