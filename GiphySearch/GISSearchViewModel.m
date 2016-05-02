//
//  GISSearchViewModel.m
//  GiphySearch
//
//  Created by Michael Yau on 5/2/16.
//  Copyright © 2016 Michael Yau. All rights reserved.
//

#import "GISSearchViewModel.h"
#import "GISSearchGiphyDataManager.h"
#import "GISViewModelDelegate.h"
#import "GISCollectionViewWaterfallHeader.h"
#import "GISDownsampledImageCellViewModel.h"

@interface GISAbstractViewModel (Private)
@property (readonly, nonatomic, weak) id <GISViewModelDelegate> delegate;
@property (readwrite, nonatomic, copy, nonnull) NSArray <GISAbstractCellViewModel *> *cellViewModels;
@property (readwrite, nonatomic, copy, nonnull) NSOrderedSet <GISGiphyData *> *giphyData;
@end

@interface GISSearchViewModel ()

@property (readonly, nonatomic, copy, nonnull) GISSearchGiphyDataManager *manager;
@property (readonly, nonatomic, copy, nonnull) NSString *searchString;

@end

@implementation GISSearchViewModel

- (instancetype)initWithDelegate:(id<GISViewModelDelegate>)delegate searchString:(NSString *)searchString {
    self = [super initWithDelegate:delegate];
    if (!self) {
        return nil;
    }
    _searchString = searchString;
    _manager = [[GISSearchGiphyDataManager alloc] initWithSearchString:searchString];
    return self;
}


- (void)update {
    [self.manager fetchNextPage].then(^(NSOrderedSet *giphyData){
        if (giphyData) {
            self.giphyData = giphyData;
            [self.delegate viewModelDidUpdate];
        }
    });
}

- (void)configureHeader:(GISCollectionViewWaterfallHeader *)header {
    [header setTitle:[NSString stringWithFormat:@"Browsing results for %@", self.searchString]];
}

- (void)updateCellViewModels {
    self.cellViewModels = [GISAbstractParser resultForResponseObject:self.giphyData targetClass:[GISDownsampledImageCellViewModel class]];
}


@end
