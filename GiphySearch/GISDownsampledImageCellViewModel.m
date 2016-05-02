//
//  GISDownsampledImageCellViewModel.m
//  GiphySearch
//
//  Created by Michael Yau on 5/1/16.
//  Copyright © 2016 Michael Yau. All rights reserved.
//

#import "GISDownsampledImageCellViewModel.h"
#import "GISCollectionViewWaterfallCell.h"
#import <SDWebImage/UIImageView+Webcache.h>

@implementation GISDownsampledImageCellViewModel

- (void)configureCell:(nonnull GISCollectionViewWaterfallCell *)cell {
    [cell.imageView sd_setImageWithURL:self.imageURL completed:^(UIImage *image,
                                                                 NSError *error,
                                                                 SDImageCacheType cacheType,
                                                                 NSURL *imageURL) {
        if (cacheType != SDImageCacheTypeMemory) {
            CATransition *transition = [CATransition animation];
            transition.duration = 0.35f;
            transition.type = kCATransitionFade;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            [cell.imageView.layer addAnimation:transition forKey:kCATransition];
        }
    }];
}
- (NSString *)cellIdentifier {
    return @"GISGiphyDownsampledCell";
}

+ (Class)parserClass {
    return [super parserClass];
}

- (CGFloat) width {
    return 200.0f;
}

@end
