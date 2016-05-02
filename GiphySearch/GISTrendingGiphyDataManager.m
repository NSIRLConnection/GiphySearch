//
//  GISTrendingGiphyDataManager.m
//  GiphySearch
//
//  Created by Michael Yau on 5/1/16.
//  Copyright © 2016 Michael Yau. All rights reserved.
//

#import "GISTrendingGiphyDataManager.h"
#import "GISGiphyAPI.h"
#import "GISGiphyData.h"
#import "GISAbstractGiphyDataManager+Private.h"

@implementation GISTrendingGiphyDataManager

+ (instancetype)sharedManager {
    static id _sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (PMKPromise *)fetchNextPage {
    if (self.isUpdating) {
        return [PMKPromise promiseWithValue:nil];
    }
    self.updating = YES;
    return [GISGiphyAPI fetchTrendingGiphyData:self.offset].then(^(id responseObject){
        [self.mutableGiphyData addObjectsFromArray:[GISAbstractParser resultForResponseObject:responseObject[@"data"] targetClass:[GISGiphyData class]]];
        [self updateOffset:responseObject];
        return self.giphyData;
    }).finally(^(){
        self.updating = NO;
    });
}

@end
