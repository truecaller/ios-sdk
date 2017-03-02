//
//  NSURL+TrueSDK.m
//  TrueSDK
//
//  Created by Stefan Stolevski on 22/12/16.
//  Copyright © 2016 True Software Scandinavia AB. All rights reserved.
//

#import "NSURL+TrueSDK.h"
#import "TCTrueSDKLogger.h"
#import "TCTrueProfileResponse.h"

NSString *kTrueProfileRequestKey = @"profileRequest";
NSString *kTrueProfileResponseKey = @"response";
NSString *kErrorKey = @"error";

@implementation NSURL (TrueSDK)

- (TCError *)tryParseError
{
    return (TCError *) [self parseArchivedObjectWithKey:kErrorKey];
}

-(id <NSCoding>) parseArchivedObjectWithKey:(NSString *)key
{
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithURL:self resolvingAgainstBaseURL:NO];
    NSArray *queryItems = urlComponents.queryItems;
    NSString *objectString = [self valueForKey:key
                                fromQueryItems:queryItems];
    if (objectString == nil) {
        return nil;
    }
    
    NSData *objectData = [[NSData alloc] initWithBase64EncodedString:objectString options:NSDataBase64DecodingIgnoreUnknownCharacters];
    id object = [NSKeyedUnarchiver unarchiveObjectWithData:objectData];
    TCLog(@"Parsed object: %@", object);
    return object;
}

- (NSString *)valueForKey:(NSString *)key
           fromQueryItems:(NSArray *)queryItems
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name=%@", key];
    NSURLQueryItem *queryItem = [[queryItems
                                  filteredArrayUsingPredicate:predicate]
                                 firstObject];
    return queryItem.value;
}
@end
