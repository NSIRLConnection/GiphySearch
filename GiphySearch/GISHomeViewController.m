//
//  GISHomeViewController.m
//  GiphySearch
//
//  Created by Michael Yau on 5/1/16.
//  Copyright © 2016 Michael Yau. All rights reserved.
//

#import "GISHomeViewController.h"
#import "GISViewModelDelegate.h"
#import "GISHomeViewModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface GISWaterfallCollectionViewController ()
@property (readwrite, nonatomic, strong, nonnull) GISAbstractViewModel *viewModel;
@end

@implementation GISHomeViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewModel = [[GISHomeViewModel alloc] initWithDelegate:self];
    [self.viewModel update];
}

- (void)viewModelDidUpdate {
    [super viewModelDidUpdate];
}

@end