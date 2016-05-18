//
//  GISAbstractViewModel.h
//  GiphySearch
//
//  Created by Michael Yau on 5/2/16.
//  Copyright © 2016 Michael Yau. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GISViewModelDelegate;
@class GISGiphyData;
@class GISAbstractCellViewModel;
@class GISViewModel;
@class GISImage;

@interface GISAbstractViewModel : NSObject

@property (readonly, nonatomic, copy, nonnull) NSArray <GISAbstractCellViewModel *> *cellViewModels;
@property (readonly, nonatomic, assign) NSInteger numberOfPages;

- (void)update;
- (nonnull instancetype)initWithDelegate:(nonnull id <GISViewModelDelegate>)delegate;
- (void)setGiphyData:(nullable NSOrderedSet<GISGiphyData *> *)giphyData;
- (void)configureHeader:(nonnull UICollectionReusableView *)header;
- (nonnull NSArray *)activityItemsForItemAtIndex:(NSInteger)index;
- (nonnull GISGiphyData *)giphyDataForItemAtIndex:(NSInteger)index;

@end
