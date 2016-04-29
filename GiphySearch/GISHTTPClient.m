//
//  GISHTTPClient.m
//  GiphySearch
//
//  Created by Michael Yau on 4/29/16.
//  Copyright © 2016 Michael Yau. All rights reserved.
//

#import "GISHTTPClient.h"
#import "GISLog.h"
#import <PromiseKit/PromiseKit.h>

@implementation NSURLRequest (cURLRepresentation)

- (NSString *)gis_escapeQuotesInString:(NSString *)string {
    NSParameterAssert(string.length);
    return [string stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
}

- (NSString *)gis_cURLRepresentation {
    NSMutableString *cURLString = [NSMutableString stringWithFormat:@"cURL -k -X %@ --dump-header -", self.HTTPMethod];
    for (NSString *key in self.allHTTPHeaderFields.allKeys) {
        NSString *headerKey = [self gis_escapeQuotesInString: key];
        NSString *headerValue = [self gis_escapeQuotesInString: self.allHTTPHeaderFields[key] ];
        [cURLString appendFormat:@" -H \"%@: %@\"", headerKey, headerValue];
    }
    NSString *bodyDataString = [[NSString alloc] initWithData:self.HTTPBody encoding:NSUTF8StringEncoding];
    if (bodyDataString.length) {
        bodyDataString = [self gis_escapeQuotesInString: bodyDataString];
        [cURLString appendFormat:@" -d \"%@\"", bodyDataString];
    }
    [cURLString appendFormat:@" \"%@\"", self.URL.absoluteString];
    
    return cURLString;
}

@end

@interface GISHTTPClient () <NSURLSessionDelegate>

@property (readwrite, nonatomic, copy, nonnull) NSArray <NSString *> *acceptableInvalidDomains;

@end

@implementation GISHTTPClient

+ (nonnull instancetype)sharedInstance {
    static id _sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (instancetype)init {
    return [self initWithAcceptableInvalidDomains:nil];
}

- (instancetype)initWithAcceptableInvalidDomains:(nullable NSArray <NSString *> *)acceptableInvalidDomains {
    self = [super init];
    if (!self) {
        return nil;
    }
    if (!acceptableInvalidDomains) {
        _acceptableInvalidDomains = @[];
    }
    else {
        _acceptableInvalidDomains = acceptableInvalidDomains;
    }
    return self;
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSString *host = challenge.protectionSpace.host;
        BOOL accept = NO;
        for (NSString *pattern in self.acceptableInvalidDomains) {
            NSRange range = [host rangeOfString:pattern options:NSCaseInsensitiveSearch|NSRegularExpressionSearch];
            if (range.location != NSNotFound) {
                accept = YES;
                break;
            }
        }
        if (accept) {
            GISLog(@"%@", [NSString stringWithFormat:@"WARNING: accepting an invalid certificate from host: %@", host]);
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        }
        else {
            GISLog(@"%@", [NSString stringWithFormat:@"WARNING: discarding an invalid certificate from host: %@", host]);
        }
    }
}

+ (nonnull PMKPromise *)GET:(nonnull NSString *)URLString {
    return [PMKPromise new:^(PMKPromiseFulfiller fulfiller, PMKPromiseRejecter rejecter) {
        [self GET:URLString completion:^(id responseObject, NSError *error) {
            if (error) {
                rejecter(error);
            }
            else {
                fulfiller(responseObject);
            }
        }];
    }];
}

+ (void)GET:(nonnull NSString *)URLString completion:(void (^)(id, NSError *))completion {
    NSURL *URL = [NSURL URLWithString:URLString];
    if (!URL) {
        NSLog(@"URL was unexpectedly nil!");
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:[NSString stringWithFormat:@"URL was unexpectedly nil from URLWithString:%@", URLString] userInfo:nil];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    if (!request) {
        NSLog(@"request was unexpectedly nil!");
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:[NSString stringWithFormat:@"URL was unexpectedly nil from requestWithURL:%@", URL] userInfo:nil];
    }
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:(id<NSURLSessionDelegate>)[GISHTTPClient sharedInstance] delegateQueue:[NSOperationQueue mainQueue]];
    GISLog(@"\n-------\nSending request\n\n%@\n-------", [request gis_cURLRepresentation]);
    NSDate *startDate = [NSDate date];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSTimeInterval requestDuration = [[NSDate date] timeIntervalSinceDate:startDate];
        GISLog(@"\n-------\nFinished request\nURL: %@\nDuration: %.2f Seconds\n\n%@\n-------", request.URL.absoluteString, requestDuration, [request gis_cURLRepresentation]);
        if ([(NSHTTPURLResponse *)response statusCode] != 200 && !error) {
            GISLog(@"\nResponse Code: %d", [(NSHTTPURLResponse *)response statusCode]);
            GISLog(@"Response String: %@", [[NSHTTPURLResponse localizedStringForStatusCode:[(NSHTTPURLResponse *)response statusCode]] capitalizedString]);
            GISLog(@"Response Description: %@", response.description);
            completion(nil, error);
        }
        else if (completion) {
            if (data) {
                id responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                if (error) {
                    GISLog(@"%@", [error localizedDescription]);
                    completion(nil, error);
                }
                else {
                    completion(responseObject,error);
                }
            }
            else {
                GISLog(@"No return data");
                completion(nil, nil);
            }
        }
    }];
    [task resume];
}

@end
