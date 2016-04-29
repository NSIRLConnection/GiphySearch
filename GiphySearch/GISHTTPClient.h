//
//  GISHTTPClient.h
//  GiphySearch
//
//  Created by Michael Yau on 4/29/16.
//  Copyright © 2016 Michael Yau. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PMKPromise;

@interface GISHTTPClient : NSObject

+ (nonnull PMKPromise *)GET:(nonnull NSString *)URLString;

@end
