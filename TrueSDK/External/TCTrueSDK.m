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
#import "TCUpdateProfileRequest.h"
#import "TCGetProfileRequest.h"

NSString *const kTCTruecallerAppURL = @"https://www.truecaller.com/userProfile";
NSString *const kTCTermsURL = @"https://developer.truecaller.com/phone-number-verification/privacy-notice";

@interface TCTrueSDK ()

@property (nonatomic, strong) NSString *appKey;
@property (nonatomic, strong) NSString *appLink;
@property (nonatomic, strong) NSString *requestNonce;

@property (nonatomic) BOOL userShownTruecallerFlow;
@property (nonatomic, strong) TCLoginCodeResponse *loginCodeResponse;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *countryCode;

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;

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

//MARK: - Truecaller flow -

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

//MARK: - Non Truecaller flow -

- (void)setViewDelegate:(UIViewController<TCTrueSDKViewDelegate> *)viewDelegate {
    _viewDelegate = viewDelegate;
    [self addTermsAndConditionsView];
}

- (void)addTermsAndConditionsView {
    UIViewController *controller = self.viewDelegate;
    
    NSInteger bottomPadding = 0;
    if (@available(iOS 11.0, *)) {
        UIWindow *window = UIApplication.sharedApplication.windows.firstObject;
        bottomPadding = window.safeAreaInsets.bottom;
    }
    
    NSInteger viewHeight = 50;
    
    UIView *view = [[UIView alloc] init];
    [view setFrame:CGRectMake(0,
                              ([UIScreen mainScreen].bounds.size.height - viewHeight - bottomPadding),
                              controller.view.frame.size.width,
                              viewHeight)];
    [view setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.3]];
    
    [self addTermsAndConditionsLabelTo:view];
    [controller.view addSubview:view];
}

-(void)addTermsAndConditionsLabelTo:(UIView *)view {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, view.frame.size.width - 16,
                                                               view.frame.size.height - 16)];
    [label setTextColor:UIColor.whiteColor];
    
    NSString *termsString = NSLocalizedStringFromTableInBundle(@"truecaller.tandc.text",
                                                          @"Localizable",
                                                          [TCUtils resourcesBundle],
                                                          @"TrueSDK T&C string");
    
    NSString *termsButtonString = NSLocalizedStringFromTableInBundle(@"truecaller.tandc.buttonText",
                                                          @"Localizable",
                                                          [TCUtils resourcesBundle],
                                                          @"TrueSDK T&C button title");
    
    NSRange termsRange = [termsString rangeOfString:termsButtonString];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: termsString attributes:nil];
    [attributedString addAttribute: NSLinkAttributeName value: kTCTermsURL range: termsRange];
    
    UITapGestureRecognizer *tap= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openTermsAndConditions:)];
    label.userInteractionEnabled= YES;
    [label addGestureRecognizer:tap];

    // Assign attributedText to UILabel
    label.attributedText = attributedString;
    label.font = [UIFont systemFontOfSize:12.0];
    label.numberOfLines = 3;
    label.userInteractionEnabled = YES;
    
    [view addSubview:label];
}

-(void)openTermsAndConditions:(id)sender{
    NSURL *termsUrl = [NSURL URLWithString:kTCTermsURL];
    [[UIApplication sharedApplication] openURL: termsUrl];
}

- (void)requestVerificationForPhone: (nonnull NSString *)phone
                        countryCode: (nonnull NSString *)countryCode {
    
    if (_viewDelegate == nil) {
        [_delegate didFailToReceiveTrueProfileWithError:[TCError errorWithCode:TCTrueSDKErrorCodeViewDelegateNil]];
        return;
    }
    
    _phone = phone;
    _countryCode = countryCode;
    
    if ((![TCUtils isTruecallerInstalled]) || (self.userShownTruecallerFlow == true)) {
        TCLoginCodeRequest *request = [[TCLoginCodeRequest alloc] initWithappKey:self.appKey appLink:self.appLink];
        [request requestLoginCodeForPhoneNumber:phone
                                    countryCode:countryCode
                                     completion:^(TCLoginCodeResponse * _Nullable response, NSError * _Nullable error) {
            if (error == nil) {
                TCLog(@"Non truecaller flow - Request OTP success");
                if ([response.method isEqual:@"sms"]) {
                    _loginCodeResponse = response;
                    TCLog(@"Non truecaller flow - OTP initiated");
                    [_delegate verificationStatusChangedTo:TCVerificationStateOTPInitiated];
                } else if (response.accessToken != nil && [response.status intValue] == 1) {
                    TCLog(@"Non truecaller flow - Already verified");
                    [self getProfileForResponse:response];
                    [_delegate verificationStatusChangedTo:TCVerificationStateVerifiedBefore];
                }
            } else {
                TCLog(@"Non truecaller flow - Request OTP error");
                [_delegate didFailToReceiveTrueProfileWithError: [TCError errorWithError:error]];
            }
        }];
    } else {
        TCLog(@"Non truecaller flow - Default fallback to truecaller");
        self.userShownTruecallerFlow = true;
        [self requestTrueProfile];
    }
}

- (void)getProfileForResponse:(TCLoginCodeResponse *)response {
    TCGetProfileRequest *request = [[TCGetProfileRequest alloc] initWithappKey:self.appKey
                                                                       appLink:self.appLink
                                                                   countryCode:self.countryCode
                                                                          auth:response.accessToken];
    
    [request getProfileWithCompletion:^(TCTrueProfile * _Nullable profile, NSError * _Nullable error) {
        if (error == nil) {
            TCLog(@"Non truecaller flow - Get profile Success");
            [self.delegate didReceiveTrueProfile:profile];
        } else {
            TCLog(@"Non truecaller flow - Get profile Error");
            [_delegate didFailToReceiveTrueProfileWithError: [TCError errorWithError:error]];
        }
    }];
}

- (void)verifySecurityCode: (nonnull NSString *)code
        andUpdateFirstname: (nonnull NSString *)firstName
                  lastName: (nonnull NSString *)lastName {
    _firstName = firstName;
    _lastName = lastName;
    
    TCVerifyCodeRequest *request = [[TCVerifyCodeRequest alloc] initWithappKey:self.appKey appLink:self.appLink];
    [request verifyLoginCodeForPhoneNumber:_phone
                               countryCode:_countryCode
                          verificationCode:code
                         verificationToken:_loginCodeResponse.verificationToken
                                completion:^(TCLoginCodeResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            if (response.accessToken != nil) {
                TCLog(@"Non truecaller flow - Verification Complete");
                [self updateProfileDetails:response];
                [_delegate verificationStatusChangedTo:TCVerificationStateVerificationComplete];
            }
        } else {
            TCLog(@"Non truecaller flow - Verification OTP Error");
            [_delegate didFailToReceiveTrueProfileWithError: [TCError errorWithError:error]];
        }
    }];
}

- (void)updateProfileDetails: (TCLoginCodeResponse *)response {
    TCLog(@"Profile update call");
    TCUpdateProfileRequest *request = [[TCUpdateProfileRequest alloc] initWithappKey:self.appKey
                                                                             appLink:self.appLink
                                                                         countryCode:self.countryCode
                                                                                auth:response.accessToken];
    [request updateFirstName:self.firstName lastName:self.lastName];
}

- (NSString *)accessTokenForOTPVerification {
    return _loginCodeResponse.accessToken;
}

- (NSNumber *)tokenTtl {
    return  _loginCodeResponse.tokenTtl;
}

@end
