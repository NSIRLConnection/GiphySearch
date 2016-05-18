//
//  GISAbstractViewModel.m
//  GiphySearch
//
//  Created by Michael Yau on 5/2/16.
//  Copyright © 2016 Michael Yau. All rights reserved.
//

#import "GISAbstractViewModel.h"
#import "MustOverride.h"
#import "GISGiphyData.h"

@interface GISAbstractViewModel ()
@property (readonly, nonatomic, weak) id <GISViewModelDelegate> delegate;
@property (readwrite, nonatomic, copy, nonnull) NSOrderedSet <GISGiphyData *> *giphyData;
@property (readwrite, nonatomic, copy, nonnull) NSArray <GISAbstractCellViewModel *> *cellViewModels;
@end

@implementation GISAbstractViewModel

- (instancetype)initWithDelegate:(nonnull id <GISViewModelDelegate>)delegate {
    self = [super init];
    if (!self) {
        return nil;
    }
    _delegate = delegate;
    _cellViewModels = @[];
    return self;
}

- (void)update {
    SUBCLASS_MUST_OVERRIDE;
}

- (void)configureHeader:(UICollectionReusableView *)header {
    SUBCLASS_MUST_OVERRIDE;
}

- (void)setGiphyData:(NSOrderedSet<GISGiphyData *> *)giphyData {
    _giphyData = giphyData;
    [self updateCellViewModels];
}

- (void)updateCellViewModels {
    SUBCLASS_MUST_OVERRIDE;
}

- (GISGiphyData *)giphyDataForItemAtIndex:(NSInteger)index {
    return self.giphyData[index];
}

- (NSArray *)activityItemsForItemAtIndex:(NSInteger)index {
    GISGiphyData *giphyData = self.giphyData[index];
    return @[giphyData.URL];
}

- (NSInteger)numberOfPages {
    return self.giphyData.count;
}

@end
