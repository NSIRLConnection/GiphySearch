//
//  GISImageParser.m
//  GiphySearch
//
//  Created by Michael Yau on 5/1/16.
//  Copyright © 2016 Michael Yau. All rights reserved.
//

#import "GISImageParser.h"
#import "GISImage.h"

@implementation GISImageParser

- (id)resultForResponseObject:(id)responseObject {
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        NSURL *URL = [NSURL URLWithString:responseObject[@"url"]];
        NSNumber *height = [NSNumber numberWithFloat:[responseObject[@"height"] floatValue]];
        NSNumber *width = [NSNumber numberWithFloat:[responseObject[@"width"] floatValue]];
        return [GISImage imageWithURL:URL height:height width:width];
    }
    return nil;
}

@end
