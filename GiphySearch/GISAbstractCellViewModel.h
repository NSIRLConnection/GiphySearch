//
//  GISAbstractCellViewModel.h
//  GiphySearch
//
//  Created by Michael Yau on 5/1/16.
//  Copyright © 2016 Michael Yau. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GISAbstractModel.h"

@interface GISAbstractCellViewModel : GISAbstractModel

@property (readonly, nonatomic, copy, nonnull) NSString *cellIdentifier;
@property (readonly, nonatomic, copy, nonnull) NSURL *imageURL;
@property (readonly, nonatomic, assign) CGFloat height;
@property (readonly, nonatomic, assign) CGFloat width;

- (void)configureCell:(nonnull UICollectionViewCell *)cell;

+ (nonnull instancetype)viewModelWithImageURL:(nonnull NSURL *)imageURL height:(CGFloat)height;

@end
