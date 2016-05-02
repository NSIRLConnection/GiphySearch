//
//  GISTimerProxyTarget.m
//  GiphySearch
//
//  Created by Michael Yau on 4/29/16.
//  Copyright © 2016 Michael Yau. All rights reserved.
//

#import "GISTimerProxyTarget.h"
#import "GISLog.h"

@interface GISTimerProxyTarget ()

@property (nonatomic, weak) id target;
@property (nonatomic) SEL selector;

@end

@implementation GISTimerProxyTarget

#pragma mark - Initialization

- (instancetype)initWithTarget:(id)target selector:(SEL)selector {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _target = target;
    _selector = selector;
    
    return self;
}

- (id)init {
    return [self initWithTarget:nil selector:nil];
}


- (void)timerDidFire:(NSTimer *)timer {
    id strongTarget = self.target;
    if (strongTarget) {
        [strongTarget performSelectorOnMainThread:self.selector withObject:nil waitUntilDone:NO];
    }
    else {
        GISLog(@"Skipped timer selector, target was deallocated without invalidating timer");
        [timer invalidate];
    }
}

@end
