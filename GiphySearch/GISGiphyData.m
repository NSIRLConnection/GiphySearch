//
//  GISGiphyData.m
//  GiphySearch
//
//  Created by Michael Yau on 4/29/16.
//  Copyright © 2016 Michael Yau. All rights reserved.
//

#import "GISGiphyData.h"
#import "GISImage.h"

@implementation GISGiphyData

- (instancetype)initWithId:(NSString *)id URL:(NSURL *)URL slug:(NSString *)slug fixedWidthDownsampledImage:(GISImage *)fixedWidthDownsampledImage originalImage:(GISImage *)originalImage {
    self = [super init];
    if (!self) {
        return nil;
    }
    _id = id;
    _URL = URL;
    _slug = slug;
    _fixedWidthDownsampledImage = fixedWidthDownsampledImage;
    _originalImage = originalImage;
    return self;
}

+ (instancetype)giphyDataWithId:(NSString *)id URL:(NSURL *)URL slug:(NSString *)slug fixedWidthDownsampledImage:(GISImage *)fixedWidthDownsampledImage originalImage:(GISImage *)originalImage {
    return [[self alloc] initWithId:id URL:URL slug:(NSString *)slug fixedWidthDownsampledImage:fixedWidthDownsampledImage originalImage:originalImage];
}

+ (Class)parserClass {
    return [super parserClass];
}

- (BOOL)isEqual:(GISGiphyData *)object {
    return [self.id isEqualToString:object.id];
}

- (instancetype)copyWithZone:(NSZone *)zone {
    GISGiphyData *copy = [[[self class] alloc] init];
    copy->_id = [self.id copy];
    copy->_URL = [self.URL copy];
    copy->_originalImage = [self.originalImage copy];
    copy->_fixedWidthDownsampledImage = [self.fixedWidthDownsampledImage copy];
    return copy;
}

@end
