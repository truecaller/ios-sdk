//
//  TCBaseRequest.h
//  TrueSDK
//
//  Created by Sreedeepkesav M S on 10/11/20.
//  Copyright © 2020 True Software Scandinavia AB. All rights reserved.
//
#import <Foundation/Foundation.h>

typedef void(^APICompletionBlock)(NSDictionary * _Nullable response, NSError * _Nullable error);

NS_ASSUME_NONNULL_BEGIN

@interface TCBaseRequest : NSObject <NSURLSessionDataDelegate>

@property (nonatomic, strong) NSString *appKey;
@property (nonatomic, strong) NSString *appLink;
@property (nonatomic, strong) NSString *httpMethod;
@property (nonatomic, strong) NSString *urlString;

- (instancetype)initWithappKey: (NSString *)appKey
                       appLink: (NSString *)appLink
                    httpMethod: (NSString *)httpMethod
                     urlString: (NSString *)urlString;

- (void)makeRequestWithParemeters: (NSDictionary *)parameters
                  useCommonParams: (BOOL)useParams
                       completion: (APICompletionBlock)completion;

- (void)makeAuthorisedRequestWithParemeters: (NSDictionary *)parameters
                                       auth: (NSString *)auth
                                 completion: (APICompletionBlock)completion;

- (void)makeGetRequest: (NSString *)auth
            completion: (APICompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END
