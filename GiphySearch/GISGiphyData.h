//
//  GISGiphyData.h
//  GiphySearch
//
//  Created by Michael Yau on 4/29/16.
//  Copyright © 2016 Michael Yau. All rights reserved.
//

#import "GISAbstractModel.h"
@class GISImage;

@interface GISGiphyData : GISAbstractModel <NSCopying>

@property (readonly, nonatomic, copy, nonnull) NSString *id;
@property (readonly, nonatomic, copy, nonnull) NSURL *URL;
@property (readonly, nonatomic, copy, nonnull) GISImage *fixedWidthDownsampledImage;
@property (readonly, nonatomic, copy, nonnull) GISImage *originalImage;

+ (nonnull instancetype)giphyDataWithId:(nonnull NSString *)id URL:(nonnull NSURL *)URL fixedWidthDownsampledImage:(nonnull GISImage *)fixedWidthDownsampledImage originalImage:(nonnull GISImage *)originalImage;
- (BOOL)isEqual:(nonnull id)object;

@end
