//
//  GISDetailViewController.m
//  GiphySearch
//
//  Created by Michael Yau on 5/5/16.
//  Copyright © 2016 Michael Yau. All rights reserved.
//

#import "GISDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/SDImageCache.h>
#import "GISImage.h"
#import "GISGiphyData.h"
#import "GISAbstractViewModel.h"
#import <libextobjc/EXTScope.h>
#import "GISPageViewController.h"
#import "GISSearchViewModel.h"
#import "GISViewModelDelegate.h"
#import "GISSearchViewController.h"

@interface GISDetailViewController ()

@property (readwrite, nonatomic, strong, nonnull) UIImageView *imageView;
@property (readonly, nonatomic, strong, nonnull) GISAbstractViewModel *viewModel;
@property (readwrite, nonatomic, strong, nonnull) UIProgressView *progressView;
@property (readonly, nonatomic, copy, nonnull) GISGiphyData *giphyData;
@property (readonly, nonatomic, strong, nonnull) GISSearchViewController *searchViewController;

@end

@implementation GISDetailViewController

- (instancetype)initWithViewModel:(GISAbstractViewModel *)viewModel index:(NSInteger)index {
    self = [super init];
    if (!self) {
        return nil;
    }
    _viewModel = viewModel;
    _index = index;
    _searchViewController = [[GISSearchViewController alloc] initWithSearchString:[_viewModel giphyDataForItemAtIndex:_index].slug];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self loadImage];
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.progressView];
    [self.view addSubview:self.searchViewController.view];
//    [self.relatedViewModel update];
}

- (void)viewModelDidUpdate {
    
}

- (GISGiphyData *)giphyData {
    return [self.viewModel giphyDataForItemAtIndex:self.index];
}

- (void)loadImage {
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.imageView];
    SDImageCache *cache = [SDImageCache sharedImageCache];
    UIImage *image = [cache imageFromDiskCacheForKey:self.giphyData.fixedWidthDownsampledImage.URL.absoluteString];
    if (image) {
        [self loadOriginalImage];
    }
    else {
        [self loadDownsampledImage];
    }
}

- (void)loadOriginalImage {
    SDImageCache *cache = [SDImageCache sharedImageCache];
    UIImage *image = [cache imageFromDiskCacheForKey:self.giphyData.fixedWidthDownsampledImage.URL.absoluteString];
    @weakify(self);
    [self.imageView sd_setImageWithURL:self.giphyData.originalImage.URL
                      placeholderImage:image
                               options:SDWebImageHighPriority
                              progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                  dispatch_async(dispatch_get_main_queue(), ^(void) {
                                      self.progressView.progress = (float)receivedSize/(float)expectedSize;
                                  });
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (cacheType != SDImageCacheTypeMemory) {
            @strongify(self);
            CATransition *transition = [CATransition animation];
            transition.duration = 0.35f;
            transition.type = kCATransitionFade;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            [self.imageView.layer addAnimation:transition forKey:kCATransition];
        }
        self.progressView.hidden = YES;
    }];
}

- (void)loadDownsampledImage {
    @weakify(self);
    [self.imageView sd_setImageWithURL:self.giphyData.fixedWidthDownsampledImage.URL
                             completed:^(UIImage *image,
                                         NSError *error,
                                         SDImageCacheType cacheType,
                                         NSURL *imageURL) {
                                 if (cacheType != SDImageCacheTypeMemory) {
                                     @strongify(self);
                                     CATransition *transition = [CATransition animation];
                                     transition.duration = 0.35f;
                                     transition.type = kCATransitionFade;
                                     transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                                     [self.imageView.layer addAnimation:transition forKey:kCATransition];
                                 }
                                 [self loadOriginalImage];
                             }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
//    self.imageView.frame = self.view.bounds;
    CGFloat width = CGRectGetWidth(self.view.frame);
    CGFloat multiplier = width/self.giphyData.originalImage.width.floatValue;
    CGFloat height = self.giphyData.originalImage.height.floatValue * multiplier;
    self.imageView.frame = CGRectMake(0, 64, width, height);
    self.progressView.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame)-4, width, 4);
    self.searchViewController.view.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame), width, CGRectGetMaxY(self.view.frame));
}

@end
