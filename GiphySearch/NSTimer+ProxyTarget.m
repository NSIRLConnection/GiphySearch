//
//  NSTimer+ProxyTarget.m
//  GiphySearch
//
//  Created by Michael Yau on 4/29/16.
//  Copyright © 2016 Michael Yau. All rights reserved.
//

#import "NSTimer+ProxyTarget.h"
#import "GISTimerProxyTarget.h"

@implementation NSTimer (ProxyTarget)

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval weakTarget:(id)target selector:(SEL)selector userInfo:(id)userInfo repeats:(BOOL)repeats {
    return [self scheduledTimerWithTimeInterval:timeInterval
                                         target:[[GISTimerProxyTarget alloc] initWithTarget:target
                                                                                 selector:selector]
                                       selector:@selector(timerDidFire:)
                                       userInfo:userInfo
                                        repeats:repeats];
}

@end
