//
//  GISAbstractParser.m
//  GiphySearch
//
//  Created by Michael Yau on 4/29/16.
//  Copyright © 2016 Michael Yau. All rights reserved.
//

#import "GISAbstractParser.h"
#import "GISLog.h"
#import "GISAbstractModel.h"
#import "MustOverride.h"

@implementation GISAbstractParser

+ (id)resultForResponseObject:(id)responseObject targetClass:(Class)targetClass {
    GISAbstractParser *parser;
    
    if ([targetClass isSubclassOfClass:[GISAbstractModel class]]) {
        parser = [[[targetClass parserClass] alloc] init];
    }
    else {
        GISLog(@"No parser found for %@!", NSStringFromClass(targetClass));
    }
    
    return [parser resultForResponseObject:responseObject];
}

- (id)resultForResponseObject:(id)responseObject {
    SUBCLASS_MUST_OVERRIDE;
    return nil;
}


@end
