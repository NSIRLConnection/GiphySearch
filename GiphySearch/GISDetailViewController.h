//
//  GISDetailViewController.h
//  GiphySearch
//
//  Created by Michael Yau on 5/5/16.
//  Copyright © 2016 Michael Yau. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GISImage;
@class GISAbstractViewModel;

@interface GISDetailViewController : UIViewController

@property (readonly, nonatomic, assign) NSInteger index;

- (instancetype)initWithViewModel:(GISAbstractViewModel *)viewModel index:(NSInteger)index;

@end
