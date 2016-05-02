//
//  GISAbstractGiphyDataManager.m
//  GiphySearch
//
//  Created by Michael Yau on 5/1/16.
//  Copyright © 2016 Michael Yau. All rights reserved.
//

#import "GISAbstractGiphyDataManager.h"
#import "MustOverride.h"
#import "GISAbstractGiphyDataManager+Private.h"

@interface GISAbstractGiphyDataManager ()
@property (readwrite, nonatomic, copy, nonnull) NSMutableOrderedSet <GISGiphyData *> *mutableGiphyData;
@property (readwrite, nonatomic, copy, nonnull) NSNumber *offset;
@property (readwrite, nonatomic, assign, getter=isUpdating) BOOL updating;

@end

@implementation GISAbstractGiphyDataManager

- (nonnull instancetype) init {
    self = [super init];
    if (!self) {
        return nil;
    }
    _offset = @1; //undocumented, but starts with 1, not 0
    _mutableGiphyData = [NSMutableOrderedSet orderedSet];
    return self;
}

- (nonnull PMKPromise *)fetchNextPage {
    SUBCLASS_MUST_OVERRIDE;
    return [PMKPromise promiseWithValue:nil];
}

- (void)resetOffset {
    self.offset = @1;
    [self.mutableGiphyData removeAllObjects];
}

- (void)updateOffset:(id)responseObject {
    self.offset = [NSNumber numberWithInteger:[responseObject[@"pagination"][@"offset"] integerValue] + [responseObject[@"pagination"][@"count"] integerValue]];
}

- (NSOrderedSet *)giphyData {
    return [self.mutableGiphyData copy];
}

@end
