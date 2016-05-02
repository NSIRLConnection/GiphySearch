//
//  GISTimerProxyTarget.h
//  GiphySearch
//
//  Created by Michael Yau on 4/29/16.
//  Copyright © 2016 Michael Yau. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GISTimerProxyTarget : NSObject

- (instancetype)initWithTarget:(id)target selector:(SEL)selector;

- (void)timerDidFire:(NSTimer *)timer;

@end

