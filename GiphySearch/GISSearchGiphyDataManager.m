//
//  GISSearchGiphyDataManager.m
//  GiphySearch
//
//  Created by Michael Yau on 5/1/16.
//  Copyright © 2016 Michael Yau. All rights reserved.
//

#import "GISSearchGiphyDataManager.h"
#import "GISGiphyAPI.h"
#import "GISGiphyData.h"
#import "GISAbstractGiphyDataManager+Private.h"

@interface GISSearchGiphyDataManager ()
@property (readwrite, nonatomic, copy, nonnull) NSString *searchString;
@end

@implementation GISSearchGiphyDataManager

+ (instancetype)sharedManager {
//    static id _sharedManager = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        _sharedManager = [[self alloc] init];
//    });
//    return _sharedManager;
    return nil;
}

- (nonnull instancetype)initWithSearchString:(nonnull NSString *)searchString {
    self = [super init];
    if (!self) {
        return nil;
    }
    _searchString = [searchString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    return self;
}

- (PMKPromise *)fetchNextPage {
    if (self.isUpdating) {
        return [PMKPromise promiseWithValue:nil];
    }
    self.updating = YES;
    return [GISGiphyAPI fetchSearchGiphyData:self.searchString offset:self.offset].then(^(id responseObject){
        [self updateOffset:responseObject];
        [self.mutableGiphyData addObjectsFromArray:[GISAbstractParser resultForResponseObject:responseObject[@"data"] targetClass:[GISGiphyData class]]];
        return self.giphyData;
    }).finally(^(){
        self.updating = NO;
    });
}

- (PMKPromise *)fetchGiphyData:(NSString *)searchString {
    [self resetOffset];
    self.searchString = searchString;
    return [self fetchNextPage];
}

@end
