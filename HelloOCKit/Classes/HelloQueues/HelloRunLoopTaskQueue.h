//
//  HelloRunLoopTaskQueue.h
//  HelloOCKit
//
//  Created by Weiyan  Li  on 2024/8/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HelloRunLoopTaskQueue : NSObject

/// 创建队列
@property (class, nonatomic, copy, readonly) HelloRunLoopTaskQueue *(^queue)(NSString *name);
/// 创建主队列
@property (class, nonatomic, copy, readonly) HelloRunLoopTaskQueue *main;
/// 销毁某个队列
@property (class, nonatomic, copy, readonly) void(^destroy)(NSString *name);

/// 每执行一次任务, 延迟多少次RunLoop
@property (nonatomic, copy, readonly) HelloRunLoopTaskQueue *_Nullable(^delay)(NSUInteger num);
/// 替换RunLoop
@property (nonatomic, copy, readonly) HelloRunLoopTaskQueue *_Nullable(^update)(CFRunLoopRef rlr, CFRunLoopMode mode);
/// 添加任务
@property (nonatomic, copy, readonly) HelloRunLoopTaskQueue *_Nullable(^enqueue)(dispatch_block_t task);
/// 调用一次减少一个任务
@property (nonatomic, copy, readonly) HelloRunLoopTaskQueue *_Nullable(^dequeue)(void);
/// 清空所有任务
@property (nonatomic, copy, readonly) HelloRunLoopTaskQueue *_Nullable(^empty)(void);
/// 销毁所有队列
@property (nonatomic, copy, readonly) void(^destroy)(void);
/// 队列名称
@property (nonatomic, strong, readonly) NSString *name;
/// 未执行任务个数
@property (nonatomic, readonly) NSInteger count;

@end

NS_ASSUME_NONNULL_END
