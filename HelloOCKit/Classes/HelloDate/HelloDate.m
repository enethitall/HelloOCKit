//
//  HelloDate.m
//  AFNetworking
//
//  Created by Weiyan  Li  on 2023/10/24.
//

#import "HelloDate.h"

typedef NS_ENUM(NSUInteger, HelloDateUnit) {
    HelloDateUnitYear,
    HelloDateUnitMonth,
    HelloDateUnitDay,
    HelloDateUnitHour,
    HelloDateUnitMinute,
    HelloDateUnitSecond
};

@implementation HelloDate

+ (NSDate *)dateFromTimestamp:(NSString *)timestamp{
    NSTimeInterval time;
    if (timestamp.length == 13) {
        time = [timestamp doubleValue] / 1000;
    } else {
        time = [timestamp doubleValue];
    }
    return [NSDate dateWithTimeIntervalSince1970:time];
}

+ (NSString *)timestampFromDate:(NSDate *)date{
    NSTimeInterval time = [date timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}

+ (NSString *)fromDate:(NSDate *)date format:(NSString *)format{
    if (date == nil) {
        return nil;
    }
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    // 设置24小时制
    NSLocale *zh_CNLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateformatter.locale = zh_CNLocale;
    // 设置成东八区
    [dateformatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8 * 60 * 60]];
    [dateformatter setDateFormat:format];
    
    NSString *strDate = [dateformatter stringFromDate:date];
    return strDate;
}

+ (NSString *)fromTimestamp:(NSString *)timestamp format:(NSString *)format{
    
    NSTimeInterval time;
    if (timestamp.length == 13) {
        time = [timestamp doubleValue] / 1000;
    } else {
        time = [timestamp doubleValue];
    }
    NSDate *detailDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *zh_CNLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.locale = zh_CNLocale;
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8 * 60 * 60]];
    [dateFormatter setDateFormat:format];
    
    NSString *currentDateStr = [dateFormatter stringFromDate:detailDate];
    return currentDateStr;
}

+ (NSString *)yearFromDate:(NSDate *)date{
    return [HelloDate valueForDate:date unit:HelloDateUnitYear];
}
+ (NSString *)monthFromDate:(NSDate *)date{
    return [HelloDate valueForDate:date unit:HelloDateUnitMonth];
}

+ (NSString *)dayFromDate:(NSDate *)date{
    return [HelloDate valueForDate:date unit:HelloDateUnitDay];
}

+ (NSString *)hourFromDate:(NSDate *)date{
    return [HelloDate valueForDate:date unit:HelloDateUnitHour];
}

+ (NSString *)minuteFromDate:(NSDate *)date{
    return [HelloDate valueForDate:date unit:HelloDateUnitMinute];
}

+ (NSString *)secondFromDate:(NSDate *)date{
    return [HelloDate valueForDate:date unit:HelloDateUnitSecond];
}

+ (NSString *)weekdayFromDate:(NSDate *)date{
    NSArray *weekday = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:date];
    return [weekday objectAtIndex:theComponents.weekday];
}

+ (NSString *)valueForDate:(NSDate *)date unit:(HelloDateUnit)unit{
    
    NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:unitFlags fromDate:date];
    switch (unit) {
        case HelloDateUnitYear:
            return [NSNumber numberWithInteger:components.year].stringValue;
            break;
        case HelloDateUnitMonth:
            return [NSNumber numberWithInteger:components.month].stringValue;
            break;
        case HelloDateUnitDay:
            return [NSNumber numberWithInteger:components.day].stringValue;
            break;
        case HelloDateUnitHour:
            return [NSNumber numberWithInteger:components.hour].stringValue;
            break;
        case HelloDateUnitMinute:
            return [NSNumber numberWithInteger:components.minute].stringValue;
            break;
        case HelloDateUnitSecond:
            return [NSNumber numberWithInteger:components.second].stringValue;
            break;
        default:
            return @"-1";
            break;
    }
}

@end
