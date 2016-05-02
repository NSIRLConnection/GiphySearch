//
//  UIViewController+TrackLifeCycle.m
//  NSIHackySack
//
//  Created by Michael Yau on 12/7/15.
//  Copyright © 2015 Michael Yau. All rights reserved.
//

#import "UIViewController+TrackLifeCycle.h"

#if DEBUG
#import "GISLog.h"
#import <objc/runtime.h>
#import "NSTimer+ProxyTarget.h"

void swizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    }
    else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

const char kViewControllerWatcherKey;

@interface ViewControllerWatcher : NSObject
@property (nonatomic, copy, readonly) NSString *classString;
@property (nonatomic, copy, readwrite) NSNumber *numberOfAliveTicks;
+ (instancetype)viewControllerWatcherWithClassString:(NSString *)classString;
@end

@implementation ViewControllerWatcher

#pragma mark - Dealloc watcher

+ (instancetype)viewControllerWatcherWithClassString:(NSString *)classString {
    return [[ViewControllerWatcher alloc] initWithClassString:classString];
}

- (id)initWithClassString:(NSString *)classString {
    self = [super init];
    if (!self) {
        return nil;
    }
    _classString = classString;
    _numberOfAliveTicks = @(0);
    return self;
}

- (void)incrementTicks {
    self.numberOfAliveTicks = [NSNumber numberWithInteger:self.numberOfAliveTicks.integerValue + 1];
}

- (void)dealloc {
    GISLog(@"%@ dealloc, was alive for %@ ticks", self.classString, self.numberOfAliveTicks);
}

@end

@implementation UIViewController (TrackLifeCycle)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        swizzleMethod(class, @selector(loadView), @selector(nsi_loadView));
        swizzleMethod(class, @selector(viewDidLoad), @selector(nsi_viewDidLoad));
        swizzleMethod(class, @selector(viewWillAppear:), @selector(nsi_viewWillAppear:));
        swizzleMethod(class, @selector(viewWillDisappear:), @selector(nsi_viewWillDisappear:));
        swizzleMethod(class, @selector(viewDidAppear:), @selector(nsi_viewDidAppear:));
        swizzleMethod(class, @selector(viewDidDisappear:), @selector(nsi_viewDidDisappear:));
    });
}

#pragma mark - Method Swizzling Life Cycle

- (void)nsi_loadView {
    [NSTimer scheduledTimerWithTimeInterval:30 weakTarget:self selector:@selector(confirmAlive) userInfo:nil repeats:YES];
    [self nsi_loadView];
}

- (void)confirmAlive {
    ViewControllerWatcher *watcher =  objc_getAssociatedObject(self, &kViewControllerWatcherKey);
    [watcher incrementTicks];
    GISLog(@"%@, alive for %@ ticks", [watcher classString], [watcher numberOfAliveTicks]);
}

- (void)nsi_viewDidLoad {
    ViewControllerWatcher *watcher = [ViewControllerWatcher viewControllerWatcherWithClassString:[self nsi_classString]];
    objc_setAssociatedObject(self, &kViewControllerWatcherKey, watcher, OBJC_ASSOCIATION_RETAIN);
    [self nsi_viewDidLoad];
}

- (void)nsi_viewWillAppear:(BOOL)animated {
    [self nsi_viewWillAppear:animated];
}

- (void)nsi_viewDidAppear:(BOOL)animated {
    [self logHierarchy];
    [self nsi_viewDidAppear:animated];
}

- (void)nsi_viewWillDisappear:(BOOL)animated {
    [self nsi_viewWillDisappear:animated];
}

- (void)nsi_viewDidDisappear:(BOOL)animated {
    [self nsi_viewDidDisappear:animated];
}

#pragma mark - Hierarchy

- (NSString *)nsi_classString {
    if ([self respondsToSelector:NSSelectorFromString(@"context")]) {
        return [NSString stringWithFormat:@"%@(%@)", NSStringFromClass([self class]),[self valueForKey:@"context"]];
    }
    return NSStringFromClass([self class]);
}

- (void)logHierarchy {
    NSString *viewControllerPath;
    UIViewController *parentViewController = [self parentViewController];
    if (parentViewController == nil) {
        viewControllerPath = [self nsi_classString];
    }
    else {
        viewControllerPath = [parentViewController nsi_classString];
    }
    if ([parentViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)parentViewController;
        for (NSUInteger i = 0; i < navigationController.viewControllers.count; i++) {
            viewControllerPath = [viewControllerPath stringByAppendingString:@"~>"];
            viewControllerPath = [viewControllerPath stringByAppendingString:[navigationController.viewControllers[i] nsi_classString]];
        }
    }
    else if ([parentViewController isKindOfClass:[UITabBarController class]]) {
        viewControllerPath = [viewControllerPath stringByAppendingString:@"~>"];
        viewControllerPath = [viewControllerPath stringByAppendingString:[self nsi_classString]];
    }
    
    GISLog(@"%@", viewControllerPath);
}

@end

#endif