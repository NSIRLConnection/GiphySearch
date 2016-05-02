//
//  GISAbstractCellViewModel.m
//  GiphySearch
//
//  Created by Michael Yau on 5/1/16.
//  Copyright © 2016 Michael Yau. All rights reserved.
//

#import "GISAbstractCellViewModel.h"
#import "MustOverride.h"

@implementation GISAbstractCellViewModel

- (instancetype)initWithImageURL:(NSURL *)imageURL height:(CGFloat)height {
    self = [super init];
    if (!self) {
        return nil;
    }
    _imageURL = imageURL;
    _height = height;
    return self;
}

+ (instancetype)viewModelWithImageURL:(NSURL *)imageURL height:(CGFloat)height {
    return [[self alloc] initWithImageURL:imageURL height:height];
}

- (NSString *)cellIdentifier {
    SUBCLASS_MUST_OVERRIDE;
    return nil;
}

- (void)configureCell:(nonnull UITableViewCell *)cell {
    SUBCLASS_MUST_OVERRIDE;
}

+ (Class)parserClass {
    return [super parserClass];
}

@end
