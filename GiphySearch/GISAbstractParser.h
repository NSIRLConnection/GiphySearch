//
//  GISAbstractParser.h
//  GiphySearch
//
//  Created by Michael Yau on 4/29/16.
//  Copyright © 2016 Michael Yau. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GISAbstractParser : NSObject

+ (id)resultForResponseObject:(id)responseObject targetClass:(Class)targetClass;

- (id)resultForResponseObject:(id)responseObject;

@end
