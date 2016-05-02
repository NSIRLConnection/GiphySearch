//
//  GISDownsampledImageCellViewModelParser.m
//  GiphySearch
//
//  Created by Michael Yau on 5/1/16.
//  Copyright © 2016 Michael Yau. All rights reserved.
//

#import "GISDownsampledImageCellViewModelParser.h"
#import "GISGiphyData.h"
#import "GISDownsampledImageCellViewModel.h"
#import "GISImage.h"

@implementation GISDownsampledImageCellViewModelParser

- (id)resultForResponseObject:(NSOrderedSet <GISGiphyData *> *)responseObject {
    NSMutableArray *result = [NSMutableArray array];
    for (GISGiphyData *giphyData in responseObject) {
        [result addObject:[GISDownsampledImageCellViewModel viewModelWithImageURL:giphyData.fixedWidthDownsampledImage.URL height:giphyData.fixedWidthDownsampledImage.height.floatValue]];
    }
    return result;
}

@end
