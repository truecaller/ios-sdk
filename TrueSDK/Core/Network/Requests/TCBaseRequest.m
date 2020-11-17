//
//  TCBaseRequest.m
//  TrueSDK
//
//  Created by Sreedeepkesav M S on 10/11/20.
//  Copyright © 2020 True Software Scandinavia AB. All rights reserved.
//

#import "TCBaseRequest.h"

@interface TCBaseRequest ()

@end

@implementation TCBaseRequest

- (instancetype)initWithappKey: (NSString *)appKey
                       appLink: (NSString *)appLink
                    httpMethod: (NSString *)httpMethod
                     urlString: (NSString *)urlString {
    self = [super init];
    _appKey = appKey;
    _appLink = appLink;
    _httpMethod = httpMethod;
    _urlString = urlString;
    return self;
}

- (NSMutableURLRequest *)makeRequestWithHeaders {
    NSURL *url = [NSURL URLWithString:self.urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:self.appKey forHTTPHeaderField:@"appKey"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request addValue:self.appLink forHTTPHeaderField:@"appLink"];
    [request setHTTPMethod:self.httpMethod];
    
    return request;
}

- (NSDictionary *)commonParameters {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:[NSNumber numberWithInt:16] forKey:@"clientId"];
    [dictionary setValue:@NO forKey:@"phonePermission"];
    [dictionary setValue:@"ios" forKey:@"os"];
    
    NSString *buildVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    [dictionary setValue:buildVersion forKey:@"version"];
    [dictionary setValue:[NSNumber numberWithInt:1] forKey:@"sequence"];
    [dictionary setValue:[self getUniqueIdentifierForDevice] forKey:@"deviceId"];
    [dictionary setValue:[NSArray arrayWithObject:[self getUniqueIdentifierForDevice]] forKey:@"simSerial"];
    
    return dictionary;
}

// TODO: - Change once decides on saving logic -
- (NSString *)getUniqueIdentifierForDevice {
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSString *timeIntervalString = [NSString stringWithFormat:@"%f", time];
    NSString *uuid = [[NSUUID UUID] UUIDString];
    NSString *randomString =  [NSString stringWithFormat:@"%@%@", uuid, timeIntervalString];
    return randomString;
}

- (void)makeRequestWithParemeters: (NSDictionary *)parameters
                  useCommonParams: (BOOL)useParams
                       completion: (APICompletionBlock)completion {
    
    NSMutableDictionary *params = [parameters mutableCopy];
    if (useParams == true) {
        [params addEntriesFromDictionary:self.commonParameters];
    }
    
    NSError *error;
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    NSMutableURLRequest *request = [self makeRequestWithHeaders];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
    [request setHTTPBody:postData];

    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request
                                                    completionHandler:^(NSData *data,
                                                                        NSURLResponse *response,
                                                                        NSError *error) {
        if (error == nil) {
            NSMutableDictionary *responseJson = [NSJSONSerialization JSONObjectWithData: data
                                                                                options: kNilOptions
                                                                                  error: &error];
            completion(responseJson, nil);
        } else {
            completion(nil, error);
        }
    }];

    [postDataTask resume];
}

@end

