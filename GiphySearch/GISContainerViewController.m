//
//  GISContainerViewController.m
//  GiphySearch
//
//  Created by Michael Yau on 5/2/16.
//  Copyright © 2016 Michael Yau. All rights reserved.
//

#import "GISContainerViewController.h"
#import "GISSearchViewController.h"
#import "GISSearchViewModel.h"

@interface GISContainerViewController () <UISearchBarDelegate>
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *searchBarBottomSpace;
@property (readwrite, nonatomic, strong, nonnull) UINavigationController *navigationController;
@end

@implementation GISContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self observeKeyboard];
    [self addTapGestureRecognizer];
    // Do any additional setup after loading the view.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    self.navigationController = segue.destinationViewController;
}

- (void)observeKeyboard {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}


- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    NSValue *kbFrame = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardFrame = [kbFrame CGRectValue];
    CGFloat height = keyboardFrame.size.height;
    self.searchBarBottomSpace.constant = height;
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];

}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    self.searchBarBottomSpace.constant = 0;
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}


- (void)addTapGestureRecognizer {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}

- (void)dismissKeyboard {
    self.searchBar.text = @"";
    [self.searchBar endEditing:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self dismissKeyboard];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *searchString = [searchBar.text copy];
    [self dismissKeyboard];
    [self showSearchCollectionView:searchString];
}

- (void)showSearchCollectionView:(NSString *)searchString {
    GISSearchViewController *viewController = [[GISSearchViewController alloc] initWithSearchString:searchString];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
