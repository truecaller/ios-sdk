//
//  TCError.m
//  TrueSDK
//
//  Created by Stefan Stolevski on 03/01/17.
//  Copyright © 2016 True Software Scandinavia AB. All rights reserved.
//

#import "TCError.h"
#define kTrueSDKErrorDomain @"TrueSDKErrorDomain"
#define kTrueSDKErrorDescription NSLocalizedDescriptionKey

@implementation TCError

+ (TCError *)errorWithCode:(TCTrueSDKErrorCode)code
{
    NSString *errorDescription = @"";
    switch (code) {
        case TCTrueSDKErrorCodeAppKeyMissing:
            errorDescription = @"Your app key is missing";
            break;
        case TCTrueSDKErrorCodeAppLinkMissing:
            errorDescription = @"Your app link is missing";
            break;
        case TCTrueSDKErrorCodeUserCancelled:
            errorDescription = @"User cancelled operation";
            break;
        case TCTrueSDKErrorCodeInternal:
            errorDescription = @"An internal error occurred in backend";
            break;
        case TCTrueSDKErrorCodeUnauthorizedUser:
            errorDescription = @"User is not authorized";
            break;
        case TCTrueSDKErrorCodeUnauthorizedDeveloper:
            errorDescription = @"Developer credentials could not be verified";
            break;
        case TCTrueSDKErrorCodeSDKTooOld:
            errorDescription = @"The SDK version is old and not compatible with the Truecaller app";
            break;
        case TCTrueSDKErrorCodeTruecallerTooOld:
            errorDescription = @"The Truecaller version is old and not compatible with the SDK version";
            break;
        case TCTrueSDKErrorCodeOSNotSupported:
            errorDescription = @"This version of iOS is not supported";
            break;
        case TCTrueSDKErrorCodeTruecallerNotInstalled:
            errorDescription = @"Compatible version of Truecaller is not installed";
            break;
        case TCTrueSDKErrorCodeNetwork:
            errorDescription = @"Error occurred in network communication";
            break;
        case TCTrueSDKErrorCodeUserNotSignedIn:
            errorDescription = @"User has not signed in with Truecaller yet";
            break;
        case TCTrueSDKErrorCodeUserProfileContentNotValid:
            errorDescription = @"Profile content is not valid";
            break;
        case TCTrueSDKErrorCodeBadRequest:
            errorDescription = @"Bad request";
            break;
        case TCTrueSDKErrorCodeVerificationFailed:
            errorDescription = @"Signature verification failed";
            break;
        case TCTrueSDKErrorCodeRequestNonceMismatch:
            errorDescription = @"The request's nonce does not match the nonce in response";
            break;
        case TCTrueSDKErrorCodeViewDelegateNil:
            errorDescription = @"View delegate is nil. You have to set a view delegate";
            break;
        case TCTrueSDKErrorCodeInvalidName:
            errorDescription = @"Please provide a valid name";
            break;
        case TCTrueSDKErrorCodeUniversalLinkFailed:
            errorDescription = @"Cannot open app because Universal Link failed";
            break;
        case TCTrueSDKErrorCodeUrlSchemeMissing:
            errorDescription = @"Please add Url Scheme to plist";
            break;
        default:
            break;
    }
    
    return [self errorWithCode:code description:errorDescription];
}

+ (TCError *)errorWithCode:(TCTrueSDKErrorCode)code
               description:(NSString *)errorDescription
{
    return [[self class] errorWithDomain:kTrueSDKErrorDomain
                                    code:code
                                userInfo:@{kTrueSDKErrorDescription : errorDescription ? errorDescription : @""}];
}

+ (TCError *)errorWithDictionary: (NSDictionary *)dictionary
{
    if (dictionary[@"code"] == nil) {
        return nil;
    }
    
    NSInteger code = (NSInteger)dictionary[@"code"];
    NSString *message = (NSString *)dictionary[@"message"];
    return [[self class] errorWithDomain:kTrueSDKErrorDomain
                                    code:code
                                userInfo:@{kTrueSDKErrorDescription : message ? message : @""}];
}

+ (TCError *)errorWithError: (NSError *)error {
    return [[self class] errorWithDomain:kTrueSDKErrorDomain
                                    code:error.code
                                userInfo:@{kTrueSDKErrorDescription : error.localizedDescription ? error.localizedDescription : @""}];
}


- (TCTrueSDKErrorCode)getErrorCode
{
    return (TCTrueSDKErrorCode)self.code;
}
@end
