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

@interface GISDetailViewController ()

@property (readwrite, nonatomic, strong, nonnull) UIImageView *imageView;
@property (readonly, nonatomic, strong, nonnull) GISAbstractViewModel *viewModel;
@property (readwrite, nonatomic, strong, nonnull) UIProgressView *progressView;

@end

@implementation GISDetailViewController

- (instancetype)initWithViewModel:(GISAbstractViewModel *)viewModel index:(NSInteger)index {
    self = [super init];
    if (!self) {
        return nil;
    }
    _viewModel = viewModel;
    _index = index;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self loadImage];
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.progressView];
}

- (void)loadImage {
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.imageView];
    SDImageCache *cache = [SDImageCache sharedImageCache];
    GISGiphyData *giphyData = [self.viewModel giphyDataForItemAtIndex:self.index];
    UIImage *image = [cache imageFromDiskCacheForKey:giphyData.fixedWidthDownsampledImage.URL.absoluteString];
    if (image) {
        [self loadOriginalImage];
    }
    else {
        [self loadDownsampledImage];
    }
}

- (void)loadOriginalImage {
    SDImageCache *cache = [SDImageCache sharedImageCache];
    GISGiphyData *giphyData = [self.viewModel giphyDataForItemAtIndex:self.index];
    UIImage *image = [cache imageFromDiskCacheForKey:giphyData.fixedWidthDownsampledImage.URL.absoluteString];
    @weakify(self);
    [self.imageView sd_setImageWithURL:giphyData.originalImage.URL
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
    GISGiphyData *giphyData = [self.viewModel giphyDataForItemAtIndex:self.index];
    @weakify(self);
    [self.imageView sd_setImageWithURL:giphyData.fixedWidthDownsampledImage.URL
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
    self.imageView.frame = self.view.bounds;
    self.progressView.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame)-4, CGRectGetWidth(self.view.frame), 4);
}

@end
