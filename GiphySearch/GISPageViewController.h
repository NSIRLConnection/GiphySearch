//
//  GISPageViewController.h
//  GiphySearch
//
//  Created by Michael Yau on 5/6/16.
//  Copyright © 2016 Michael Yau. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GISAbstractViewModel;

@interface GISPageViewController : UIPageViewController

- (instancetype)initWithViewModel:(GISAbstractViewModel *)viewModel index:(NSInteger)index;

@end
