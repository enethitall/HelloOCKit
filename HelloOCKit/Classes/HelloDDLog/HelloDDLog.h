//
//  HelloDDLog.h
//  HelloOCKit
//
//  Created by Weiyan  Li  on 2024/5/16.
//

#import <Foundation/Foundation.h>
#import <CocoaLumberjack/CocoaLumberjack.h>

extern DDLogLevel ddLogLevel;
// 默认的宏，方便使用
#define HLog(frmt, ...)            HelloLogD(frmt, ##__VA_ARGS__)
// 提供不同的宏，对应到特定参数的对外接口
#define HelloLogE(frmt, ...)       DDLogError(frmt, ##__VA_ARGS__)
#define HelloLogW(frmt, ...)       DDLogWarn(frmt, ##__VA_ARGS__)
#define HelloLogI(frmt, ...)       DDLogInfo(frmt, ##__VA_ARGS__)
#define HelloLogD(frmt, ...)       DDLogDebug(frmt, ##__VA_ARGS__)
#define HelloLogV(frmt, ...)       DDLogVerbose(frmt, ##__VA_ARGS__)

NS_ASSUME_NONNULL_BEGIN

@interface HelloDDLog : NSObject

//单例
+ (instancetype)shareInstance;

//开启文件log
- (void)enable:(void(^)(void))touchUpInsideEvent;

//创建新文件写入log
- (void)createAndRollToNewFile;

//当前活跃的log文件路径
- (NSString *)currentFilePath;

//关闭文件log
- (void)close;

//打印项目所有的类
- (void)printAllClass;

@end

NS_ASSUME_NONNULL_END
