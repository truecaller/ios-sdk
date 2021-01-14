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

+ (NSURL *)baseUrlForCountryCode: (NSString *)countrycode {
    if([[self euCountryCodes] containsObject:countrycode]) {
        return [self URLWithString: @"https://outline-eu.truecaller.com"];
    }
    
    return [self URLWithString:@"https://outline-noneu.truecaller.com"];
}

+ (NSArray *)euCountryCodes
{
    static NSArray *_euCountryCodes;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _euCountryCodes = @[
                    @"AT", //Austria
                    @"BE", //Belgium
                    @"BG", //Bulgaria
                    @"HR", //Croatia
                    @"CY", //Republic of Cyprus
                    @"CZ", //Czech Republic
                    @"DK", //Denmark
                    @"EE", //Estonia
                    @"FI", //Finland
                    @"FR", //France
                    @"DE", //Germany
                    @"GR", //Greece
                    @"HU", //Hungary
                    @"IE", //Ireland
                    @"IT", //Italy
                    @"LV", //Latvia
                    @"LT", //Lithuania
                    @"LU", //Luxembourg
                    @"MT", //Malta
                    @"NL", //Netherlands
                    @"PL", //Poland
                    @"PT", //Portugal
                    @"RO", //Romania
                    @"SK", //Slovakia
                    @"SI", //Slovenia
                    @"ES", //Spain
                    @"SE", //Sweden
                    @"UK", //UK
                    @"GB", //UK
                    @"IS", //Iceland
                    @"LI", //Liechtenstein
                    @"NO", //Norway
                    @"CH", //Switzerland
                    @"AD", //Andorra
                    @"FO", //Faroe Islands
                    @"GI", //Gibraltar
                    @"GG", //Guernsey
                    @"IM", //Isle of Man
                    @"JE", //Jersey
                    @"MC", //Monaco
                    @"SM", //San Marino
                    @"SJ", //Svalbard and Jan Mayen
                    @"VA", //Vatican
                    @"AX"  //Åland Islands
        ];
    });
    return _euCountryCodes;
}

@end
