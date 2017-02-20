//
//  TCTrueProfileResponse.h
//  TrueSDK
//
//  Created by Guven Iscan on 11/01/2017.
//  Copyright © 2017 True Software Scandinavia AB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCTrueProfileResponse : NSObject <NSCoding>

@property (nonatomic, strong) NSString *payload;
@property (nonatomic, strong) NSString *signature;
@property (nonatomic, strong) NSString *signatureAlgorithm;
@property (nonatomic, strong) NSString *requestNonce;

@end
