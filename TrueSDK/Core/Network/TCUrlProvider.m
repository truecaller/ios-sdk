//
//  TCUrlProvider.m
//  TrueSDK
//
//  Created by Sreedeepkesav M S on 16/11/20.
//  Copyright © 2020 True Software Scandinavia AB. All rights reserved.
//

#import "TCUrlProvider.h"

@implementation TCUrlProvider

+ (NSURL *)baseUrlForCountryCode: (NSString *)countrycode {
    if([[[self class] euCountryCodes] containsObject:countrycode]) {
        return [NSURL URLWithString: @"https://outline-eu.truecaller.com"];
    }
    
    return [NSURL URLWithString:@"https://outline-noneu.truecaller.com"];
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
