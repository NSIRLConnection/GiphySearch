//
//  GISAbstractGiphyDataManager.h
//  GiphySearch
//
//  Created by Michael Yau on 5/1/16.
//  Copyright © 2016 Michael Yau. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GISAbstractParser.h"
#import <PromiseKit/PromiseKit.h>
@class GISGiphyData;

@interface GISAbstractGiphyDataManager : NSObject

@property (readonly, nonatomic, copy, nonnull) NSOrderedSet <GISGiphyData *> *giphyData;
@property (readonly, nonatomic, copy, nonnull) NSNumber *offset;
@property (readonly, nonatomic, assign, getter=isUpdating) BOOL updating;

- (nonnull PMKPromise *)fetchNextPage;

@end
