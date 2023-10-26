//
//  HelloMacro.h
//  Pods
//
//  Created by Weiyan  Li  on 2023/10/26.
//

#import "HelloDate.h"

#define currentTime [HelloDate fromDate:NSDate.date format:@"yyyy-MM-dd HH:mm:ss.SSS"]

#ifdef DEBUG
#define HelloLog(format, ...) printf("\n%s <%s:%s(第%d行)>\n%s\n", [currentTime UTF8String], [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __PRETTY_FUNCTION__,__LINE__, [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String] )
#else
#define HelloLog(format, ...)
#endif
