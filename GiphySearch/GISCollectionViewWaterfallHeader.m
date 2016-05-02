//
//  GISCollectionViewWaterfallHeader.m
//  GiphySearch
//
//  Created by Michael Yau on 5/1/16.
//  Copyright © 2016 Michael Yau. All rights reserved.
//

#import "GISCollectionViewWaterfallHeader.h"

@interface GISCollectionViewWaterfallHeader ()

@property (readonly, nonatomic, strong, nonnull) UILabel *titleLabel;

@end

@implementation GISCollectionViewWaterfallHeader

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    self.backgroundColor = [UIColor darkGrayColor];
    _titleLabel = [[UILabel alloc] initWithFrame:frame];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:14];
    [self addSubview:_titleLabel];
    return self;
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (void)layoutSubviews {
    self.titleLabel.frame = self.bounds;
}

@end
