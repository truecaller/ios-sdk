//
//  TCBaseRequest.m
//  TrueSDK
//
//  Created by Sreedeepkesav M S on 10/11/20.
//  Copyright © 2020 True Software Scandinavia AB. All rights reserved.
//

#import "TCBaseRequest.h"
#import <UIKit/UIKit.h>
#import "TCUtils.h"

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
    
    NSString *sdkVersion = [TCUtils getSDKVersion];
    [request addValue:sdkVersion forHTTPHeaderField:@"sdkVersion"];
    [request addValue:@"native" forHTTPHeaderField:@"sdkVariant"];

    return request;
}

- (NSMutableURLRequest *)makeAuthorisedRequestWithToken: (NSString *)token {
    NSMutableURLRequest *request = [self makeRequestWithHeaders];
    [request addValue:[NSString stringWithFormat:@"Bearer %@", token] forHTTPHeaderField:@"Authorization"];
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

- (NSString *)getUniqueIdentifierForDevice {
    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    return idfv;
}

- (void)makeAuthorisedRequestWithParemeters: (NSDictionary *)parameters
                                       auth: (NSString *)auth
                                 completion: (APICompletionBlock)completion {
    NSMutableURLRequest *request = [self makeAuthorisedRequestWithToken:auth];
    [self performRequestWithParemeters:request parameters:parameters completion:completion];
}

- (void)makeRequestWithParemeters: (NSDictionary *)parameters
                  useCommonParams: (BOOL)useParams
                       completion: (APICompletionBlock)completion {
    
    NSMutableDictionary *params = [parameters mutableCopy];
    if (useParams == true) {
        [params addEntriesFromDictionary:self.commonParameters];
    }
    
    NSMutableURLRequest *request = [self makeRequestWithHeaders];
    [self performRequestWithParemeters:request parameters:params completion:completion];
}

- (void)makeGetRequest: (NSString *)auth
            completion: (APICompletionBlock)completion {
    NSMutableURLRequest *request = [self makeAuthorisedRequestWithToken:auth];
    [self performRequestWithParemeters:request parameters:nil completion:completion];
}

- (void)performRequestWithParemeters: (NSMutableURLRequest *) request
                           parameters: (NSDictionary *)parameters
                           completion: (APICompletionBlock)completion {
    NSError *error;
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    if(parameters != nil) {
        NSData *requestData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
        [request setHTTPBody:requestData];
    }
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
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
    
    [dataTask resume];
}

@end

