//
//  GISHomeViewModel.m
//  GiphySearch
//
//  Created by Michael Yau on 5/1/16.
//  Copyright © 2016 Michael Yau. All rights reserved.
//

#import "GISHomeViewModel.h"
#import "GISTrendingGiphyDataManager.h"
#import "GISViewModelDelegate.h"
#import "GISAbstractParser.h"
#import "GISDownsampledImageCellViewModel.h"
#import "GISCollectionViewWaterfallHeader.h"

@interface GISAbstractViewModel (Private)
@property (readonly, nonatomic, weak) id <GISViewModelDelegate> delegate;
@property (readwrite, nonatomic, copy, nonnull) NSOrderedSet <GISGiphyData *> *giphyData;
@property (readwrite, nonatomic, copy, nonnull) NSArray <GISAbstractCellViewModel *> *cellViewModels;
@end

@implementation GISHomeViewModel

- (void)update {
    [[GISTrendingGiphyDataManager sharedManager] fetchNextPage].then(^(NSOrderedSet *giphyData){
        if (giphyData) {
            self.giphyData = giphyData;
            [self.delegate viewModelDidUpdate];
        }
    });
}

- (void)configureHeader:(GISCollectionViewWaterfallHeader *)header {
    [header setTitle:@"Browsing Trending GIFs, ordered by Newest"];
}

- (void)updateCellViewModels {
    self.cellViewModels = [GISAbstractParser resultForResponseObject:self.giphyData targetClass:[GISDownsampledImageCellViewModel class]];
}

@end
