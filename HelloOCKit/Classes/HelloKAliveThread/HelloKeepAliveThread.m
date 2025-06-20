//
//  HelloKeepAliveThread.m
//  HelloOCKit
//
//  Created by Weiyan  Li  on 2024/8/13.
//

#import "HelloKeepAliveThread.h"
@interface HelloKeepAliveThread () {
    NSThread *_thread;
}
@end

@implementation HelloKeepAliveThread

static HelloKeepAliveThread *instance = nil;
static dispatch_once_t onceToken;
int count = 0;
+ (instancetype)shareInstance
{
    dispatch_once(&onceToken, ^{
        instance = [[HelloKeepAliveThread alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _thread = [[NSThread alloc] initWithTarget:[self class] selector:@selector(_run) object:nil];
        _thread.qualityOfService = NSQualityOfServiceUserInteractive;
        [_thread start];
    }
    return self;
}

+ (void)_run {
    NSLog(@"启动保活线程");
    @autoreleasepool {
        NSThread *thread = [NSThread currentThread];
        [thread setName:@"com.helloOCkit.HelloKeepAliveThread"];
        CFRunLoopRef rl = CFRunLoopGetCurrent();
        CFRunLoopSourceContext context = {0};
        CFRunLoopSourceRef source = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &context);
        CFRunLoopAddSource(rl, source, kCFRunLoopDefaultMode);
        CFRelease(source);
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1.0e10, false);
    }
    NSLog(@"关闭保活线程");
}

+ (void)run_1 {
    @autoreleasepool {
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        NSTimer *timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(handleTimerTask) userInfo:nil repeats:YES];
        [runLoop addTimer:timer forMode:NSDefaultRunLoopMode];
        [runLoop run];
    }
}
+ (void)handleTimerTask{
    NSLog(@"定时任务执行，当前线程: %@", [NSThread currentThread]);
    count++;
    if (count==5) {
        CFRunLoopStop(CFRunLoopGetCurrent());
        [NSThread exit];
    }
}

- (void)performBlock:(void(^)(void))block {
    [self performSelector:@selector(_performBlockOnResidentThread:) onThread:_thread withObject:block waitUntilDone:NO];
}

- (void)_performBlockOnResidentThread:(void(^)(void))block {
    if ( block ) block();
}

- (void)_stop {
    CFRunLoopStop(CFRunLoopGetCurrent());
    [NSThread exit];
}

- (void)dealloc {
    [self performSelector:@selector(_stop) onThread:_thread withObject:nil waitUntilDone:YES];
}

- (void)destory{
    onceToken = 0;
    instance = nil;
}

@end
