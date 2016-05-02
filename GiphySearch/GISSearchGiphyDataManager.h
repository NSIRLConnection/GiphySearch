//
//  GISSearchGiphyDataManager.h
//  GiphySearch
//
//  Created by Michael Yau on 5/1/16.
//  Copyright © 2016 Michael Yau. All rights reserved.
//

#import "GISAbstractGiphyDataManager.h"

@interface GISSearchGiphyDataManager : GISAbstractGiphyDataManager

- (nonnull instancetype)initWithSearchString:(nonnull NSString *)searchString;

//- (nonnull PMKPromise *)fetchGiphyData:(nonnull NSString *)searchString;

@end
