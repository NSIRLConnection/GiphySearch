//
//  GISConstants.m
//  GiphySearch
//
//  Created by Michael Yau on 5/1/16.
//  Copyright © 2016 Michael Yau. All rights reserved.
//

#import "GISConstants.h"

@implementation GISConstants

+ (NSString *)hostServer {
    // Don't really have dev/staging/prod servers, but this is where they'd be defined
    
    NSString *server;
#ifdef DEBUG
    server = @"http://api.giphy.com";
#else
    server = @"http://api.giphy.com";
#endif
    return server;
}

+ (NSString *)APIKey {
    NSString *APIKey;
#ifdef DEBUG
    APIKey = @"dc6zaTOxFJmzC";
#else
    APIKey = @"dc6zaTOxFJmzC";
#endif
    return APIKey;
}

@end
