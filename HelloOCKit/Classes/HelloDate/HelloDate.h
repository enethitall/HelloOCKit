//
//  HelloDate.h
//  AFNetworking
//
//  Created by Weiyan  Li  on 2023/10/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HelloDate : NSObject
/**
 *  时间戳转日期
 *
 *  @param timestamp     时间戳
 *
 *  @return 日期
 */
+ (NSDate *)dateFromTimestamp:(NSString *)timestamp;
/**
 *  日期转时间戳
 *
 *  @param date     日期
 *
 *  @return 时间戳
 */
+ (NSString *)timestampFromDate:(NSDate *)date;
/**
 *  日期转字符串
 *
 *  @param date     待转换日期
 *  @param format      转换格式
 *
 *  @return 转换后字符串
 */
+ (NSString *)fromDate:(NSDate *)date format:(NSString *)format;

/**
 *  时间戳转字符串
 *
 *  @param date     待转换时间戳
 *  @param format      转换格式
 *
 *  @return 转换后字符串
 */
+ (NSString *)fromTimestamp:(NSString *)timestamp format:(NSString *)format;

/**
 *  获取指定日期的年份
 *
 *  @param date     指定日期
 *
 *  @return 指定日期的年份
 */
+ (NSString *)yearFromDate:(NSDate *)date;

/**
 *  获取指定日期的月份
 *
 *  @param date     指定日期
 *
 *  @return 指定日期的月份
 */
+ (NSString *)monthFromDate:(NSDate *)date;

/**
 *  获取指定日期的日份

 *  @param date     指定日期
 *
 *  @return 指定日期的日份
 */
+ (NSString *)dayFromDate:(NSDate *)date;

/**
 *  获取指定日期的时
 *
 *  @param date     指定日期
 *
 *  @return 指定日期的时
 */
+ (NSString *)hourFromDate:(NSDate *)date;

/**
 *  获取指定日期的分钟
 *
 *  @param date     指定日期
 *
 *  @return 指定日期的分钟
 */
+ (NSString *)minuteFromDate:(NSDate *)date;

/**
 *  获取指定日期的秒
 *
 *  @param date     指定日期
 *
 *  @return 指定日期的秒
 */
+ (NSString *)secondFromDate:(NSDate *)date;

/**
 *  根据日期计算星期几
 *
 *  @param date     指定日期
 *
 *  @return 星期几
 */
+ (NSString *)weekdayFromDate:(NSDate *)date;


@end

NS_ASSUME_NONNULL_END
