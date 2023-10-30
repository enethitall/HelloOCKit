//
//  HelloMacro.h
//  Pods
//
//  Created by Weiyan  Li  on 2023/10/26.
//



#define HelloCurrentTime _HelloLogTime()

#ifdef DEBUG
#define HelloLog(format, ...) NSLog((@"\n%s <%s:%s(第%d行)>\n" format), [HelloCurrentTime UTF8String], [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __PRETTY_FUNCTION__,__LINE__,##__VA_ARGS__)
#else
#define HelloLog(format, ...)
#endif

static inline NSString *_HelloLogTime(void) {
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    NSLocale *zh_CNLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateformatter.locale = zh_CNLocale;
    [dateformatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8 * 60 * 60]];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    NSString *strDate = [dateformatter stringFromDate:NSDate.date];
    return strDate;
}
