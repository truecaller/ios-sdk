//
//  TCVerificationError.h
//  TrueSDK
//
//  Created by Sreedeepkesav M S on 11/11/20.
//  Copyright © 2020 True Software Scandinavia AB. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TCVerificationError : NSError

/*!
 * @brief Method for creating an error object given an API response. Intended for internal usage.
 * @param dictionary Api response dictionary
 * @return TCVerificationError Error object
 */

+ (TCVerificationError *)errorWithDictionary: (NSDictionary *)dictionary;

/*!
 * @brief Method for creating an error object given an error. Intended for internal usage.
 * @param error Api error
 * @return TCVerificationError Error object
 */

+ (TCVerificationError *)errorWithError: (NSError *)error;

@end

NS_ASSUME_NONNULL_END
