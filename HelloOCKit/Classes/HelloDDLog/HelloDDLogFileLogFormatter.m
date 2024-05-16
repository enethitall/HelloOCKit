//
//  HelloDDLogFileLogFormatter.m
//  HelloOCKit
//
//  Created by Weiyan  Li  on 2024/5/16.
//

#import "HelloDDLogFileLogFormatter.h"

@implementation HelloDDLogFileLogFormatter

//实现方法
- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
    NSString *logLevel = nil;
    switch (logMessage->_flag) {
        case DDLogFlagError:
            logLevel = @"Error";
            break;
        case DDLogFlagWarning:
            logLevel = @"Warn";
            break;
        case DDLogFlagInfo:
            logLevel = @"Info";
            break;
        case DDLogFlagDebug:
            logLevel = @"Debug";
            break;
        default:
            logLevel = @"Verbose";
            break;
    }
    NSString *formatLog = [NSString stringWithFormat:@"%@-[HelloDDLog]-[Method:<%@>Line:%ld]-->\n%@<--",[self getTimeStringWithDate:NSDate.date],logMessage->_function,logMessage->_line,logMessage->_message];
    return formatLog;
}

- (NSString *)getTimeStringWithDate:(NSDate *)date {
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [NSDateFormatter new];
        NSLocale *zh_CNLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        dateFormatter.locale = zh_CNLocale;
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8 * 60 * 60]];
        [dateFormatter setDateFormat:@"YYYY-MM-dd-HH:mm:ss.SSS"];
    });
    return [dateFormatter stringFromDate:date];
}

@end
