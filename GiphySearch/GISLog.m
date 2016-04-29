//
//  GISLog.m
//  GiphySearch
//
//  Created by Michael Yau on 4/29/16.
//  Copyright © 2016 Michael Yau. All rights reserved.
//

#import "GISLog.h"

#ifdef DEBUG
#import <objc/runtime.h>
void GISDebugLog(NSString *format, ...) {
    if (format == nil) {
        printf("nil\n");
        return;
    }
    va_list argList;
    va_start(argList, format);
    NSString *s = [[NSString alloc] initWithFormat:format arguments:argList];
    printf("%s\n", [[s stringByReplacingOccurrencesOfString:@"%%" withString:@"%%%%"] UTF8String]);
    va_end(argList);
}
#endif