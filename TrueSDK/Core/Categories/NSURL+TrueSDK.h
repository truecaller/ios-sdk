//
//  NSURL+TrueSDK.h
//  TrueSDK
//
//  Created by Stefan Stolevski on 22/12/16.
//  Copyright © 2016 True Software Scandinavia AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCError.h"

@class TCTrueProfileResponse;

FOUNDATION_EXPORT NSString *kTrueProfileRequestKey;
FOUNDATION_EXPORT NSString *kTrueProfileResponseKey;
FOUNDATION_EXPORT NSString *kErrorKey;

@interface NSURL (TrueSDK)

- (TCError *)tryParseError;
- (id <NSCoding>)parseArchivedObjectWithKey:(NSString *)key;

@end
