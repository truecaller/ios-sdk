//
//  TCTrueSDK.m
//  TrueSDK
//
//  Created by Stefan Stolevski on 21/12/16.
//  Copyright © 2016 True Software Scandinavia AB. All rights reserved.
//

#import "TCTrueSDK.h"
#import "TCUtils.h"
#import "NSURL+TrueSDK.h"
#import "TCTrueSDKLogger.h"
#import "TCError.h"
#import "TCTrueProfileRequest.h"
#import "TCTrueProfileResponse.h"
#import "TCLoginCodeRequest.h"
#import "TCVerifyCodeRequest.h"

NSString *const kTCTruecallerAppURL = @"https://www.truecaller.com/userProfile";

@interface TCTrueSDK ()

@property (nonatomic, strong) NSString *appKey;
@property (nonatomic, strong) NSString *appLink;
@property (nonatomic, strong) NSString *requestNonce;

@property (nonatomic) BOOL userCancelledAuth;
@property (nonatomic, strong) TCLoginCodeResponse *loginCodeResponse;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *countryCode;

@end

@implementation TCTrueSDK

+ (nonnull TCTrueSDK *)sharedManager
{
    static TCTrueSDK *sharedManagerInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManagerInstance = [[self alloc] init];
    });
    return sharedManagerInstance;
}

- (void)setupWithAppKey:(nonnull NSString *)appKey
                appLink:(nonnull NSString *)appLink
{
    self.appKey = appKey;
    self.appLink = appLink;
    self.titleType = TitleTypeDefault;
    self.locale = @"en_US";
}

- (void)setupWithAppKey:(nonnull NSString *)appKey
                appLink:(nonnull NSString *)appLink
                requestNonce:(nonnull NSString *)requestNonce
{
    [self setupWithAppKey:appKey appLink:appLink];
    self.requestNonce = requestNonce;
}

+ (NSURL *)buildTruecallerMessageWithItem:(id<NSCoding>)item forKey:(NSString *)key
{
    NSURLComponents *urlComponents = [NSURLComponents componentsWithString:kTCTruecallerAppURL];
    NSData *itemData = [NSKeyedArchiver archivedDataWithRootObject:item];
    NSString *itemString = [itemData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSURLQueryItem *queryItem = [NSURLQueryItem queryItemWithName:key value:itemString];
    urlComponents.queryItems = @[queryItem];
    NSURL *url = urlComponents.URL;
    
    return url;
}

- (void)requestTrueProfile
{    
    if (![TCUtils isOperatingSystemSupported]) {
        TCError *error = [TCError errorWithCode:TCTrueSDKErrorCodeOSNotSupported];
        [self.delegate didFailToReceiveTrueProfileWithError:error];
        return;
    }
    
    if (![TCUtils isTruecallerInstalled]) {
        TCError *error = [TCError errorWithCode:TCTrueSDKErrorCodeTruecallerNotInstalled];
        [self.delegate didFailToReceiveTrueProfileWithError:error];
        return;
    }
    
    if (self.appKey == nil || self.appKey.length == 0) {
        TCError *error = [TCError errorWithCode:TCTrueSDKErrorCodeAppKeyMissing];
        [self.delegate didFailToReceiveTrueProfileWithError:error];
        return;
    }
    
    if (self.appLink == nil || self.appLink.length == 0) {
        TCError *error = [TCError errorWithCode:TCTrueSDKErrorCodeAppLinkMissing];
        [self.delegate didFailToReceiveTrueProfileWithError:error];
        return;
    }
    
    NSString *requestNonce = self.requestNonce ?: [NSUUID UUID].UUIDString;
    
    if ([[TCTrueSDK sharedManager].delegate respondsToSelector:@selector(willRequestProfileWithNonce:)]) {
        [[TCTrueSDK sharedManager].delegate willRequestProfileWithNonce:requestNonce];
    }
    
    TCTrueProfileRequest *profileRequest = [TCTrueProfileRequest new];
    profileRequest.appKey = self.appKey;
    profileRequest.appLink = self.appLink;
    profileRequest.appId = [[NSBundle mainBundle] bundleIdentifier];
    profileRequest.apiVersion = [TCUtils getAPIVersion];
    profileRequest.sdkVersion = [TCUtils getSDKVersion];
    profileRequest.appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
    profileRequest.requestNonce = requestNonce;
    profileRequest.titleType = self.titleType;
    profileRequest.locale = self.locale;
    NSURL *url = [TCTrueSDK buildTruecallerMessageWithItem:profileRequest forKey:kTrueProfileRequestKey];
    
    [TCUtils openUrl:url completionHandler:nil];
}

- (void)requestOTPForPhone: (NSString *)phone
               countryCode: (NSString *)countryCode {
    _phone = phone;
    _countryCode = countryCode;
    
    if ((![TCUtils isTruecallerInstalled]) || (self.userCancelledAuth == true)) {
        TCLoginCodeRequest *request = [[TCLoginCodeRequest alloc] initWithappKey:self.appKey appLink:self.appLink];
        [request requestLoginCodeForPhoneNumber:phone
                                    countryCode:countryCode
                                     completion:^(TCLoginCodeResponse * _Nullable response, NSError * _Nullable error) {
            if (error == nil) {
                if (response.method == nil) {
                    _loginCodeResponse = response;
                    [_delegate verificationStatusChangedTo:TCVerificationStateOTPInitiated];
                } else if (response.accessToken != nil && [response.status intValue] == 1) {
                    [_delegate verificationStatusChangedTo:TCVerificationStateVerifiedBefore];
                }
            } else {
                [_delegate didReceiveVerificationError:[TCVerificationError errorWithError:error]];
            }
        }];
    } else {
        [self requestTrueProfile];
    }
}

- (void)verifySecurityCode: (NSString *)code {
    TCVerifyCodeRequest *request = [[TCVerifyCodeRequest alloc] initWithappKey:self.appKey appLink:self.appLink];
    [request verifyLoginCodeForPhoneNumber:_phone
                               countryCode:_countryCode
                          verificationCode:code
                         verificationToken:_loginCodeResponse.verificationToken
                                completion:^(TCLoginCodeResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            if (response.accessToken != nil) {
                [_delegate verificationStatusChangedTo:TCVerificationStateVerificationComplete];
            }
        } else {
            [_delegate didReceiveVerificationError:[TCVerificationError errorWithError:error]];
        }
    }]
}

- (BOOL)isSupported
{
    return [TCUtils isOperatingSystemSupported] && [TCUtils isTruecallerInstalled];
}

- (BOOL)application:(nonnull UIApplication *)application
continueUserActivity:(nonnull NSUserActivity *)userActivity
 restorationHandler:(nullable void (^)(NSArray * _Nullable restorableObjects))restorationHandler
{
    BOOL retValue = [self continueUserActivity:userActivity];
    return retValue;
}

- (void)scene:(nonnull UIScene *)scene continueUserActivity:(nonnull NSUserActivity *)userActivity {
    BOOL retValue = [self continueUserActivity:userActivity];
}

-(BOOL)continueUserActivity:(nonnull NSUserActivity *)userActivity {
    BOOL retValue = NO;
    if ([userActivity.activityType isEqualToString: NSUserActivityTypeBrowsingWeb]) {
        NSURL *url = userActivity.webpageURL;
        NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithURL:url resolvingAgainstBaseURL:NO];
        urlComponents.query = nil;
        urlComponents.path = nil;
        if ([urlComponents.string isEqualToString:self.appLink]) {
            TCError *error = [url tryParseError];
            if (error != nil) {
                [self processError:error url:url];
            } else {
                [self processTrueProfileResponse:url];
            }
            retValue = YES;
        }
    }
    
    return retValue;
}

- (void)processError: (TCError *)tcError url: (NSURL *)url {
    TCLog(@"Error: %@", tcError);
    TCError *error = (TCError *) [url parseArchivedObjectWithKey:kErrorKey];
    
    if (error.getErrorCode == TCTrueSDKErrorCodeUserCancelled) {
        _userCancelledAuth = true;
    }
    
    [_delegate didFailToReceiveTrueProfileWithError:error];
}

- (void)processTrueProfileResponse: (NSURL *)url {
    TCLog(@"Received True Profile");
    TCTrueProfileResponse *response = (TCTrueProfileResponse *) [url parseArchivedObjectWithKey:kTrueProfileResponseKey];
    if ([self.delegate respondsToSelector:@selector(didReceiveTrueProfileResponse:)]) {
        [self.delegate didReceiveTrueProfileResponse:response];
    }
    
    if (response != nil) {
        NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:response.payload options:0];
        NSError *serializationError = nil;
        NSDictionary *profileDict = [NSJSONSerialization JSONObjectWithData:decodedData options:0 error:&serializationError];
        TCTrueProfile *profile = [[TCTrueProfile alloc] initWithDictionary:profileDict];
        [self.delegate didReceiveTrueProfile:profile];
    } else {
        TCError *error = [TCError errorWithCode:TCTrueSDKErrorCodeUserProfileContentNotValid];
        [self.delegate didFailToReceiveTrueProfileWithError:error];
    }
}

@end
