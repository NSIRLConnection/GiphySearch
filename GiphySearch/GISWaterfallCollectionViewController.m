//
//  GISWaterfallCollectionViewController.m
//  GiphySearch
//
//  Created by Michael Yau on 5/2/16.
//  Copyright © 2016 Michael Yau. All rights reserved.
//

#import "GISWaterfallCollectionViewController.h"
#import "GISCollectionViewWaterfallCell.h"
#import "GISCollectionViewWaterfallHeader.h"
#import "GISCollectionViewWaterfallFooter.h"
#import <CHTCollectionViewWaterfallLayout/CHTCollectionViewWaterfallLayout.h>
#import "GISViewModelDelegate.h"
#import "GISHomeViewModel.h"
#import "GISAbstractCellViewModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define CELL_IDENTIFIER @"WaterfallCell"
#define HEADER_IDENTIFIER @"WaterfallHeader"
#define FOOTER_IDENTIFIER @"WaterfallFooter"

@interface GISWaterfallCollectionViewController () <CHTCollectionViewDelegateWaterfallLayout, UICollectionViewDataSource>
@property (readwrite, nonatomic, strong, nonnull) GISAbstractViewModel *viewModel;
@property (readwrite, nonatomic, strong) UICollectionView *collectionView;
@property (readwrite, nonatomic, copy, nonnull) NSArray <GISAbstractCellViewModel *> *cellViewModels;
@end

@implementation GISWaterfallCollectionViewController

#pragma mark - Accessors

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        
        layout.sectionInset = UIEdgeInsetsMake(2, 2, 2, 2);
        layout.headerHeight = 44;
        layout.footerHeight = 44;
        layout.minimumColumnSpacing = 4;
        layout.minimumInteritemSpacing = 4;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor blackColor];
        [_collectionView registerClass:[GISCollectionViewWaterfallCell class]
            forCellWithReuseIdentifier:CELL_IDENTIFIER];
        [_collectionView registerClass:[GISCollectionViewWaterfallHeader class]
            forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader
                   withReuseIdentifier:HEADER_IDENTIFIER];
        [_collectionView registerClass:[GISCollectionViewWaterfallFooter class]
            forSupplementaryViewOfKind:CHTCollectionElementKindSectionFooter
                   withReuseIdentifier:FOOTER_IDENTIFIER];
    }
    return _collectionView;
}

#pragma mark - Life Cycle

- (void)dealloc {
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateLayoutForOrientation:[UIApplication sharedApplication].statusBarOrientation];
}

- (void)viewModelDidUpdate {
    [self.collectionView performBatchUpdates:^(){
        NSMutableArray <NSIndexPath *> *oldIndexPaths = [NSMutableArray array];
        NSMutableArray <NSIndexPath *> *newIndexPaths = [NSMutableArray array];
        for (int i = 0; i < self.cellViewModels.count; i++) {
            [oldIndexPaths addObject:[NSIndexPath indexPathForItem:i inSection:0]];
        }
        for (int i = 0; i < self.viewModel.cellViewModels.count; i++) {
            [newIndexPaths addObject:[NSIndexPath indexPathForItem:i inSection:0]];
        }
        [newIndexPaths removeObjectsInArray:oldIndexPaths];
        [self.collectionView insertItemsAtIndexPaths:newIndexPaths];
        self.cellViewModels = self.viewModel.cellViewModels;
    } completion:nil];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self updateLayoutForOrientation:toInterfaceOrientation];
}

- (void)updateLayoutForOrientation:(UIInterfaceOrientation)orientation {
    CHTCollectionViewWaterfallLayout *layout = (CHTCollectionViewWaterfallLayout *)self.collectionView.collectionViewLayout;
    layout.columnCount = UIInterfaceOrientationIsPortrait(orientation) ? 2 : 3;
}

#pragma mark - UICollectionViewDataSource

- (GISAbstractCellViewModel *)cellViewModelForIndexPath:(NSIndexPath *)indexPath {
    return self.cellViewModels[indexPath.row];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.cellViewModels.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GISCollectionViewWaterfallCell *cell =
    (GISCollectionViewWaterfallCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER
                                                                                forIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    GISAbstractCellViewModel *cellViewModel = [self cellViewModelForIndexPath:indexPath];
    [cellViewModel configureCell:cell];
    if (indexPath.row > ([self collectionView:collectionView numberOfItemsInSection:0] - 10)) {
        [self.viewModel update];
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView;
    
    if ([kind isEqualToString:CHTCollectionElementKindSectionHeader]) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                          withReuseIdentifier:HEADER_IDENTIFIER
                                                                 forIndexPath:indexPath];
        [self.viewModel configureHeader:reusableView];
    }
    else if ([kind isEqualToString:CHTCollectionElementKindSectionFooter]) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                          withReuseIdentifier:FOOTER_IDENTIFIER
                                                                 forIndexPath:indexPath];
    }
    
    return reusableView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *activities = [self.viewModel activityItemsForItemAtIndex:indexPath.row];
    UIActivityViewController *viewController = [[UIActivityViewController alloc] initWithActivityItems:activities
                                                                                 applicationActivities:nil];
    [self presentViewController:viewController animated:YES completion:nil];
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    GISAbstractCellViewModel *cellViewModel = [self cellViewModelForIndexPath:indexPath];
    return CGSizeMake(cellViewModel.width, cellViewModel.height);
}

@end
