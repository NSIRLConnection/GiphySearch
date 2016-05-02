//
//  GISGiphyDataParser.m
//  GiphySearch
//
//  Created by Michael Yau on 5/1/16.
//  Copyright © 2016 Michael Yau. All rights reserved.
//

#import "GISGiphyDataParser.h"
#import "GISGiphyData.h"
#import "GISImage.h"
#import "GISLog.h"

@implementation GISGiphyDataParser

- (id)resultForResponseObject:(id)responseObject {
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        NSString *id = responseObject[@"id"];
        NSURL *URL = [NSURL URLWithString:responseObject[@"url"]];
        NSDictionary *images = responseObject[@"images"];
        GISImage *fixedWidthDownsampledImage = [[self class] resultForResponseObject:images[@"fixed_width_downsampled"] targetClass:[GISImage class]];
        GISImage *originalImage = [[self class] resultForResponseObject:images[@"fixed_width_downsampled"] targetClass:[GISImage class]];
        return [GISGiphyData giphyDataWithId:id URL:URL fixedWidthDownsampledImage:fixedWidthDownsampledImage originalImage:originalImage];
    }
    else if ([responseObject isKindOfClass:[NSArray class]]) {
        NSMutableArray <GISGiphyData *> *array = [NSMutableArray array];
        for (NSDictionary *dictionary in responseObject) {
            [array addObject:[self resultForResponseObject:dictionary]];
        }
        return array;
    }
    GISLog(@"Could not parse GISGiphyData.");
    return nil;
}

@end
