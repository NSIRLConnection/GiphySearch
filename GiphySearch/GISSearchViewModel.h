//
//  GISSearchViewModel.h
//  GiphySearch
//
//  Created by Michael Yau on 5/2/16.
//  Copyright © 2016 Michael Yau. All rights reserved.
//

#import "GISAbstractViewModel.h"

@interface GISSearchViewModel : GISAbstractViewModel

- (instancetype)initWithDelegate:(id<GISViewModelDelegate>)delegate searchString:(NSString *)searchString;

@end
