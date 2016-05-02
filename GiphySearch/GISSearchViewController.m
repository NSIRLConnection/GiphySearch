//
//  GISSearchViewController.m
//  GiphySearch
//
//  Created by Michael Yau on 5/2/16.
//  Copyright © 2016 Michael Yau. All rights reserved.
//

#import "GISSearchViewController.h"
#import "GISSearchViewModel.h"

@interface GISWaterfallCollectionViewController ()
@property (readwrite, nonatomic, strong, nonnull) GISSearchViewModel *viewModel;
@end

@implementation GISSearchViewController

- (instancetype)initWithSearchString:(NSString *)searchString {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.viewModel = [[GISSearchViewModel alloc] initWithDelegate:self searchString:searchString];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.viewModel update];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
