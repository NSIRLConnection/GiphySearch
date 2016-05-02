//
//  GISGiphyAPI.h
//  GiphySearch
//
//  Created by Michael Yau on 5/1/16.
//  Copyright © 2016 Michael Yau. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PMKPromise;

@interface GISGiphyAPI : NSObject

+ (nonnull PMKPromise *)fetchTrendingGiphyData:(nonnull NSNumber *)offset;
+ (nonnull PMKPromise *)fetchSearchGiphyData:(nonnull NSString *)searchString offset:(nonnull NSNumber *)offset;

@end
