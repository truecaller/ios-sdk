//
//  TCUtils.m
//  TrueSDK
//
//  Created by Aleksandar Mihailovski on 19/12/16.
//  Copyright © 2016 True Software Scandinavia AB. All rights reserved.
//

#import "TCUtils.h"
#import <UIKit/UIKit.h>
#import "TCTrueSDKLogger.h"
#import "TCVersion.h"

@implementation TCUtils

+ (BOOL)isOperatingSystemSupported
{
    NSString *requiredSystemVersion = @"9.0";
    NSString *currentSystemVersion = [[UIDevice currentDevice] systemVersion];
    TCLog(@"Current Operating System Version: %@", currentSystemVersion);
    TCLog(@"Required Operating System Version: %@", requiredSystemVersion);
    BOOL isOperatingSystemSupported = ([currentSystemVersion compare:requiredSystemVersion options:NSNumericSearch] != NSOrderedAscending);
    TCLog(@"Is Operating System Supported: %@", isOperatingSystemSupported ? @"YES" : @"NO");
    return isOperatingSystemSupported;
}

+ (BOOL)isTruecallerInstalled
{
    BOOL canOpenTruecaller = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"truesdk://"]];
    TCLog(@"Can open Truecaller: %@", canOpenTruecaller ? @"YES" : @"NO");
    return canOpenTruecaller;
}

+ (void)openUrl:(NSURL*)url completionHandler:(void (^)(BOOL success))completion
{
    UIApplication *currentApplication = [UIApplication sharedApplication];
    if ([currentApplication respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        //The completion handler is called on the main thread
        [currentApplication openURL:url options:@{} completionHandler:completion];
    } else {
        BOOL success = [currentApplication openURL:url];
        if (completion != nil) {
            //Call the completion handler on the main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(success);
            });
        }
    }
}

+ (NSBundle *)resourcesBundle
{
    NSBundle *frameworkBundle = [NSBundle bundleForClass:[self class]];
    NSURL *bundleUrl = [frameworkBundle.resourceURL URLByAppendingPathComponent:@"TrueSDK.bundle"];
    NSBundle *bundle = [NSBundle bundleWithURL:bundleUrl];
    
    return bundle ?: frameworkBundle;
}

+ (NSString *)getAPIVersion
{
    return TrueSDKApiVersion;
}

+ (NSString *)getSDKVersion
{
    return TrueSDKVersion;
}

@end
