//
//  GISCollectionViewWaterfallFooter.m
//  GiphySearch
//
//  Created by Michael Yau on 5/1/16.
//  Copyright © 2016 Michael Yau. All rights reserved.
//

#import "GISCollectionViewWaterfallFooter.h"

@interface GISCollectionViewWaterfallFooter ()
@property (readonly, nonatomic, strong, nonnull) UIActivityIndicatorView *activityIndicatorView;
@end

@implementation GISCollectionViewWaterfallFooter

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    self.backgroundColor = [UIColor darkGrayColor];
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:frame];
    [self addSubview:_activityIndicatorView];
    [_activityIndicatorView startAnimating];
    return self;
}

- (void)prepareForReuse {
    self.activityIndicatorView.frame = self.bounds;
}

@end
