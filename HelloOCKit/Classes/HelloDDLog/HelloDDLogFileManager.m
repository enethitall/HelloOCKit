//
//  HelloDDLogFileManager.m
//  HelloOCKit
//
//  Created by Weiyan  Li  on 2024/5/16.
//

#import "HelloDDLogFileManager.h"

@implementation HelloDDLogFileManager

//重写方法(log文件名生成规则)
- (NSString *)newLogFileName {
    
    NSString *timeStamp = [self getTimestamp];
    
    return [NSString stringWithFormat:@"%@.log", timeStamp];
}

//重写方法(是否是log文件)
- (BOOL)isLogFile:(NSString *)fileName {
    
    BOOL hasProperSuffix = [fileName hasSuffix:@".log"];
    
    return hasProperSuffix;
}

- (NSString *)getTimestamp {
    static dispatch_once_t onceToken;
    static NSDateFormatter *dateFormatter;
    dispatch_once(&onceToken, ^{
        dateFormatter = [NSDateFormatter new];
        NSLocale *zh_CNLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        dateFormatter.locale = zh_CNLocale;
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8 * 60 * 60]];
        [dateFormatter setDateFormat:@"YYYY-MM-dd-HH:mm:ss"];
    });
    return [dateFormatter stringFromDate:NSDate.date];
}

//重写方法(log文件夹路径)
- (NSString *)defaultLogsDirectory {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *baseDir = paths.firstObject;
    NSString *logsDirectory = [baseDir stringByAppendingPathComponent:@"HelloDDLogs"];

    return logsDirectory;
}

@end
