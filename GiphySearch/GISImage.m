//
//  GISImage.m
//  GiphySearch
//
//  Created by Michael Yau on 5/1/16.
//  Copyright © 2016 Michael Yau. All rights reserved.
//

#import "GISImage.h"

@implementation GISImage

- (instancetype)initWithURL:(NSURL *)URL height:(NSNumber *)height width:(NSNumber *)width {
    self = [super init];
    if (!self) {
        return nil;
    }
    _URL = URL;
    _height = height;
    _width = width;
    return self;
}

+ (instancetype)imageWithURL:(NSURL *)URL height:(NSNumber *)height width:(NSNumber *)width{
    return [[self alloc] initWithURL:URL height:height width:width];
}

- (instancetype)copyWithZone:(NSZone *)zone {
    GISImage *copy = [[[self class] alloc] init];
    copy->_URL = [self.URL copy];
    copy->_width = [self.width copy];
    copy->_height = [self.height copy];
    return copy;
}

+ (Class)parserClass {
    return [super parserClass];
}

@end
