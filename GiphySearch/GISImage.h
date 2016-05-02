//
//  GISImage.h
//  GiphySearch
//
//  Created by Michael Yau on 5/1/16.
//  Copyright © 2016 Michael Yau. All rights reserved.
//

#import "GISAbstractModel.h"

@interface GISImage : GISAbstractModel <NSCopying>

@property (readonly, nonatomic, copy, nonnull) NSURL *URL;
@property (readonly, nonatomic, copy, nonnull) NSNumber *height;
@property (readonly, nonatomic, copy, nonnull) NSNumber *width;

+ (nonnull instancetype)imageWithURL:(nonnull NSURL *)URL height:(nonnull NSNumber *)height width:(nonnull NSNumber *)width;


@end
