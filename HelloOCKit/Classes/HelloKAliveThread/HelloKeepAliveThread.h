//
//  HelloKeepAliveThread.h
//  HelloOCKit
//
//  Created by Weiyan  Li  on 2024/8/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HelloKeepAliveThread : NSObject

+ (instancetype)shareInstance;

//添加任务
- (void)performBlock:(void(^)(void))block;

- (void)destory;

@end

NS_ASSUME_NONNULL_END
