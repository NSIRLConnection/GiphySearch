//
//  GISLog.h
//  GiphySearch
//
//  Created by Michael Yau on 4/29/16.
//  Copyright © 2016 Michael Yau. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu-zero-variadic-macro-arguments"
extern void GISDebugLog(NSString *format, ...);
#define GISLog(fmt, ...) GISDebugLog((@"[Line: %d] %s: " fmt), __LINE__, __PRETTY_FUNCTION__, ##__VA_ARGS__);
#pragma clang diagnostic pop
#else
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu-zero-variadic-macro-arguments"
#define GISLog(fmt, ...)
#pragma clang diagnostic pop
#endif