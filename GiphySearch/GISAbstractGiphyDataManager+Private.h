//
//  GISAbstractGiphyDataManager+Private.h
//  GiphySearch
//
//  Created by Michael Yau on 5/1/16.
//  Copyright © 2016 Michael Yau. All rights reserved.
//

#import "GISAbstractGiphyDataManager.h"

@interface GISAbstractGiphyDataManager (Private)
@property (readwrite, nonatomic, copy, nonnull) NSMutableOrderedSet <GISGiphyData *> *mutableGiphyData;
@property (readwrite, nonatomic, copy, nonnull) NSNumber *offset;
@property (readwrite, nonatomic, assign, getter=isUpdating) BOOL updating;

- (void)resetOffset;
- (void)updateOffset:(nonnull id)responseObject;

@end
