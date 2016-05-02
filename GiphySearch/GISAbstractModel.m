//
//  GISAbstractModel.m
//  GiphySearch
//
//  Created by Michael Yau on 4/29/16.
//  Copyright © 2016 Michael Yau. All rights reserved.
//

#import "GISAbstractModel.h"
#import "MustOverride.h"

#define DEBUG_MODELS 0

#if DEBUG_MODELS
#import "GISLog.h"
#import "NSTimer+ProxyTarget.h"

@interface GISAbstractModel ()
@property (nonatomic, copy, readwrite) NSNumber *numberOfAliveTicks;
@end

#endif

@implementation GISAbstractModel

+ (Class)parserClass {
    SUBCLASS_MUST_OVERRIDE;
    NSString *modelClassString = NSStringFromClass([self class]);
    NSString *parserClassString = [modelClassString stringByAppendingString:@"Parser"];
    return NSClassFromString(parserClassString);
}

#if DEBUG_MODELS

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    _numberOfAliveTicks = @(0);
    [NSTimer scheduledTimerWithTimeInterval:30 weakTarget:self selector:@selector(confirmAlive) userInfo:nil repeats:YES];
    
    return self;
}

- (void)incrementTicks {
    self.numberOfAliveTicks = [NSNumber numberWithInteger:self.numberOfAliveTicks.integerValue + 1];
}

- (void)confirmAlive {
    [self incrementTicks];
    GISLog(@"%@, alive for %@ ticks", NSStringFromClass([self class]), self.numberOfAliveTicks);
}

- (void)dealloc {
    GISLog(@"%@ dealloc, was alive for %@ ticks", NSStringFromClass([self class]), self.numberOfAliveTicks);
}
#endif

@end
