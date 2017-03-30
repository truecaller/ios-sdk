//
//  TCUtils.h
//  TrueSDK
//
//  Created by Aleksandar Mihailovski on 19/12/16.
//  Copyright © 2016 True Software Scandinavia AB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCUtils : NSObject

/*!
 *  @brief Check if the current ios version is supported by the SDK
 *  @return true if supported otherwise false
 */
+ (BOOL)isOperatingSystemSupported;

/*!
 * @brief Check whether Truecaller is installed or not
 * @return true if installed otherwise false
 */
+ (BOOL)isTruecallerInstalled;

/*!
 * @brief Attempts to open the resource at the specified URL asynchronously.
 * @param url A URL (Universal Resource Locator).
 * @param completion The block to execute with the results. The block has no return value.
 *                   Takes a Boolean indicating whether the URL was opened successfully.
 *                   This block is executed asynchronously on the app's main thread.
 */
+ (void)openUrl:(NSURL*)url completionHandler:(void (^)(BOOL success))completion;

/*!
 * @brief Get the resource bundle for TrueSDK
 * @return bundle
 */
+ (NSBundle *)resourcesBundle;

/*!
 * @brief Get the API version of the TrueSDK
 * @return version
 */
+ (NSString *)getAPIVersion;

/*!
 * @brief Get the SDK version of the TrueSDK
 * @return version
 */
+ (NSString *)getSDKVersion;

@end
