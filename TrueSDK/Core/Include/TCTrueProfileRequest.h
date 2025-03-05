//
//  TCTrueProfileRequest.h
//  TrueSDK
//
//  Created by Guven Iscan on 23/12/2016.
//  Copyright © 2016 True Software Scandinavia AB. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TitleType) {
    TitleTypeDefault = 0,
    TitleTypeLoginTo,
    TitleTypeSignUpWith,
    TitleTypeSigninTo,
    TitleTypeVerifyWith,
    TitleTypeGetStartedWith,
    TitleTypeRegisterWith
};

@interface TCTrueProfileRequest : NSObject <NSCoding>

@property (nonatomic, strong, nullable) NSString *appId;
@property (nonatomic, strong, nullable) NSString *appKey;
@property (nonatomic, strong, nullable) NSString *appLink;
@property (nonatomic, strong, nullable) NSString *appName;
@property (nonatomic, strong, nullable) NSString *requestNonce;
@property (nonatomic, strong, nullable) NSString *apiVersion;
@property (nonatomic, strong, nullable) NSString *sdkVersion;
@property (nonatomic, assign) enum TitleType titleType;
@property (nonatomic, strong, nullable) NSString *locale;
@property (nonatomic, strong, nullable) NSString *urlScheme;

@end
