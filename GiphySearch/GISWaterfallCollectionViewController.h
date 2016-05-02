//
//  GISWaterfallCollectionViewController.h
//  GiphySearch
//
//  Created by Michael Yau on 5/2/16.
//  Copyright © 2016 Michael Yau. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GISViewModelDelegate.h"
@class GISAbstractViewModel;

@interface GISWaterfallCollectionViewController : UIViewController <GISViewModelDelegate>

@property (readonly, nonatomic, strong, nonnull) GISAbstractViewModel *viewModel;

@end
