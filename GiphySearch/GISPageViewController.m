//
//  GISPageViewController.m
//  GiphySearch
//
//  Created by Michael Yau on 5/6/16.
//  Copyright © 2016 Michael Yau. All rights reserved.
//

#import "GISPageViewController.h"
#import "GISAbstractViewModel.h"
#import "GISDetailViewController.h"

@interface GISPageViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate, UINavigationControllerDelegate>
@property (readonly, nonatomic, strong) GISAbstractViewModel *viewModel;
@property (readonly, nonatomic) NSInteger currentIndex;
@end

@implementation GISPageViewController

- (instancetype)initWithViewModel:(GISAbstractViewModel *)viewModel index:(NSInteger)index {
    self = [super initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    if (!self) {
        return nil;
    }
    _viewModel = viewModel;
    GISDetailViewController *viewController = [[GISDetailViewController alloc] initWithViewModel:viewModel index:index];
    [self setViewControllers:@[viewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    self.delegate = self;
    self.dataSource = self;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [shareButton setTitle:@"Share" forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    [shareButton sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(GISDetailViewController *)viewController {
    if (viewController.index != 0) {
        return [[GISDetailViewController alloc] initWithViewModel:self.viewModel index:viewController.index-1];
    }
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(GISDetailViewController *)viewController {
    if ((viewController.index + 1) != self.viewModel.numberOfPages) {
        return [[GISDetailViewController alloc] initWithViewModel:self.viewModel index:viewController.index+1];
    }
    return nil;
}

- (NSInteger)currentIndex {
    return [[self.viewControllers firstObject] index];
}

- (void)share:(UIButton *)sender {
    NSArray *activities = [self.viewModel activityItemsForItemAtIndex:self.currentIndex];
    UIActivityViewController *viewController = [[UIActivityViewController alloc] initWithActivityItems:activities
                                                                                 applicationActivities:nil];
    viewController.popoverPresentationController.sourceView = sender;
    [self presentViewController:viewController animated:YES completion:nil];
}


@end
