//
//  GISGiphyAPI.m
//  GiphySearch
//
//  Created by Michael Yau on 5/1/16.
//  Copyright © 2016 Michael Yau. All rights reserved.
//

#import "GISGiphyAPI.h"
#import "GISHTTPClient.h"
#import "GISConstants.h"

#pragma mark - API
#define API_KEY [GISConstants APIKey]
#define API_PARAMETER [NSString stringWithFormat:@"api_key=%@", API_KEY]
#define SEARCH_PARAMETER(arg) [NSString stringWithFormat:@"&q=%@", arg]
#define OFFSET_PARAMETER(arg) [NSString stringWithFormat:@"&offset=%@", arg]
#define LIMIT_PARAMETER(arg) [NSString stringWithFormat:@"&limit=%@", arg]

#pragma mark - Host Server

#define HOST_SERVER [GISConstants hostServer]
#define HOST_SERVER_API(service) [NSString stringWithFormat:@"%@%@", HOST_SERVER, service]

#pragma mark - Services
#define GIFS HOST_SERVER_API(@"/v1/gifs")

#pragma mark - Endpoints
#define TRENDING @"/trending?"
#define SEARCH @"/search?"

@implementation GISGiphyAPI

+ (nonnull PMKPromise *)fetchTrendingGiphyData:(nonnull NSNumber *)offset {
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@%@%@", GIFS, TRENDING, API_PARAMETER, OFFSET_PARAMETER(offset), LIMIT_PARAMETER(@50)];
    return [GISHTTPClient GET:urlString];
}

+ (nonnull PMKPromise *)fetchSearchGiphyData:(nonnull NSString *)searchString offset:(nonnull NSNumber *)offset {
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@%@%@%@", GIFS, SEARCH, API_PARAMETER, SEARCH_PARAMETER(searchString), OFFSET_PARAMETER(offset),LIMIT_PARAMETER(@50)];
    return [GISHTTPClient GET:urlString];
}

@end
