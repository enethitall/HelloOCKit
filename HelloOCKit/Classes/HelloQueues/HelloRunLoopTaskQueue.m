//
//  HelloRunLoopTaskQueue.m
//  HelloOCKit
//
//  Created by Weiyan  Li  on 2024/8/13.
//

#import "HelloRunLoopTaskQueue.h"
#import "HelloQueue.h"
#import <stdlib.h>

@interface HelloRunLoopTaskQueues : NSObject
- (void)addQueue:(HelloRunLoopTaskQueue *)q;
- (void)removeQueue:(NSString *)name;
- (nullable HelloRunLoopTaskQueue *)getQueue:(NSString *)name;
@end

@implementation HelloRunLoopTaskQueues {
    NSMutableDictionary *_m;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _m = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)addQueue:(HelloRunLoopTaskQueue *)q {
    if ( !q ) return;
    [_m setValue:q forKey:q.name];
}

- (void)removeQueue:(NSString *)name {
    [_m removeObjectForKey:name];
}
- (nullable HelloRunLoopTaskQueue *)getQueue:(NSString *)name {
    HelloRunLoopTaskQueue *_Nullable q = _m[name];
    return q;
}
@end

typedef struct {
    CFRunLoopRef rlr;
    CFRunLoopMode mode;
    CFRunLoopObserverRef _Nullable obr;
} HelloRunLoopObserverRef;

static NSString *const kSJRunLoopTaskMainQueue = @"com.SJRunLoopTaskQueue.main";

@interface HelloRunLoopTaskQueue ()
@property (nonatomic, strong, readonly) HelloQueue<dispatch_block_t> *queue;
@property (nonatomic, readonly) HelloRunLoopObserverRef observerRef;
@property (nonatomic) NSUInteger delayNum;
@property (nonatomic) NSUInteger countDown;
@property (nonatomic, weak, readonly) NSThread *onThread;
@end

@implementation HelloRunLoopTaskQueue
static HelloRunLoopTaskQueues *_queues;
/// 在当前的RunLoop中创建一个任务队列
///
/// - 请使用唯一的队列名称, 同名的队列将会被移除
/// - 调用destroy后, 该队列将会被移除
+ (HelloRunLoopTaskQueue * _Nonnull (^)(NSString * _Nonnull))queue {
    return ^HelloRunLoopTaskQueue *(NSString *name) {
        NSParameterAssert(name);
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _queues = [HelloRunLoopTaskQueues new];
        });
        HelloRunLoopTaskQueue *_Nullable q = [_queues getQueue:name];
        if ( !q ) {
            if ( name != kSJRunLoopTaskMainQueue ) {
                q = [[HelloRunLoopTaskQueue alloc] initWithName:name runLoop:CFRunLoopGetCurrent() mode:kCFRunLoopCommonModes];
            }
            else {
                q = [[HelloRunLoopTaskQueue alloc] initWithName:name runLoop:CFRunLoopGetMain() mode:kCFRunLoopCommonModes];
            }
            [_queues addQueue:q];
        }
        return q;
    };
}

/// 在mainRunLoop中创建的任务队列
///
/// - 调用destroy后, 再次获取该队列将会重新创建
+ (HelloRunLoopTaskQueue *)main {
    return self.queue(kSJRunLoopTaskMainQueue);
}

/// 销毁某个队列
+ (void (^)(NSString * _Nonnull))destroy {
    return ^(NSString *name) {
        if ( name.length < 1 )
            return ;
        HelloRunLoopTaskQueue *_Nullable q = [_queues getQueue:name];
        if ( q ) q.destroy();
    };
}

- (instancetype)initWithName:(NSString *)name runLoop:(CFRunLoopRef)runLoop mode:(CFRunLoopMode)mode {
    self = [super init];
    if (self) {
        _name = name;
        _queue = HelloQueue.queue;
        _observerRef = (HelloRunLoopObserverRef){runLoop, mode, NULL};
        _onThread = (runLoop == CFRunLoopGetMain())?NSThread.mainThread:NSThread.currentThread;
    }
    return self;
}

- (void)dealloc {
#ifdef DEBUG
    NSLog(@"%d - -[%@ %s]", (int)__LINE__, NSStringFromClass([self class]), sel_getName(_cmd));
#endif
    [_queue empty];
    [self _removeRunLoopObserver];
}

#pragma mark -

- (HelloRunLoopTaskQueue * _Nullable (^)(CFRunLoopRef _Nonnull, CFRunLoopMode _Nonnull))update {
    return ^HelloRunLoopTaskQueue *(CFRunLoopRef rlr, CFRunLoopMode mode) {
        [self _updateObserverRunLoop:rlr mode:mode];
        return self;
    };
}

- (HelloRunLoopTaskQueue * _Nullable (^)(dispatch_block_t _Nonnull))enqueue {
    return ^HelloRunLoopTaskQueue *(dispatch_block_t task) {
        [self.queue enqueue:task];
        [self _addRunLoopObserverIfNeeded];
        return self;
    };
}

- (HelloRunLoopTaskQueue * _Nullable (^)(void))dequeue {
    return ^HelloRunLoopTaskQueue *(void) {
        [self.queue dequeue];
        return self;
    };
}

- (HelloRunLoopTaskQueue * _Nullable (^)(NSUInteger))delay {
    return ^HelloRunLoopTaskQueue *(NSUInteger num) {
        self.delayNum = num;
        return self;
    };
}

- (HelloRunLoopTaskQueue * _Nullable (^)(void))empty {
    return ^HelloRunLoopTaskQueue *(void) {
        [self.queue empty];
        return self;
    };
}

- (void (^)(void))destroy {
    return ^ {
        [self.queue empty];
        [self _removeRunLoopObserver];
        [_queues removeQueue:self.name];
    };
}

- (NSInteger)count {
    return _queue.size;
}

#pragma mark -

- (void)_removeRunLoopObserver {
    if ( _observerRef.obr != NULL ) {
        CFRunLoopRemoveObserver(_observerRef.rlr, _observerRef.obr, _observerRef.mode);
        _observerRef.obr = NULL;
    }
}

- (void)_updateObserverRunLoop:(CFRunLoopRef)rlr mode:(CFRunLoopMode)mode {
    if ( _observerRef.rlr != rlr || _observerRef.mode != mode ) {
        _observerRef.rlr = rlr;
        _observerRef.mode = mode;
        
        if ( _observerRef.obr != nil ) {
            [self _removeRunLoopObserver];
            [self _addRunLoopObserverIfNeeded];
        }
    }
}

- (void)_addRunLoopObserverIfNeeded {
    if ( !_observerRef.obr && _queue.size != 0 ) {
        __weak typeof(self) _self = self;
        CFRunLoopObserverRef obr = CFRunLoopObserverCreateWithHandler(NULL, kCFRunLoopBeforeWaiting, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
            __strong typeof(_self) self = _self;
            if ( !self ) return;
            if ( self.queue.size == 0 ) {
                return;
            }
            
            if ( self.countDown > 0 ) {
                --self.countDown;
            }
            else {
                self.countDown = self.delayNum;
                __auto_type task = self.queue.dequeue;
                if ( task != nil ) task();
            }
        });
        CFRunLoopAddObserver(_observerRef.rlr, obr, _observerRef.mode);
        CFRelease(obr);
        _observerRef.obr = obr;
    }
}



@end
