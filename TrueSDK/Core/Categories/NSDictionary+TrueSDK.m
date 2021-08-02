//
//  NSDictionary+TrueSDK.m
//  TrueSDK
//
//  Created by Ashutosh Roy on 02/08/21.
//  Copyright © 2021 True Software Scandinavia AB. All rights reserved.
//

#import "NSDictionary+TrueSDK.h"

@implementation NSDictionary (TrueSDK)

- (NSString *)stringForKey:(NSString *)key
{
    id object = [self objectForKey:key];
    
    if ([object isKindOfClass:[NSString class]]) {
        return object;
    } else if ([object isKindOfClass:[NSNumber class]]) {
        return [object stringValue];
    }
    
    return nil;
}

@end
