

#import "HelloTimer.h"


#define LSTPopViewTimerPath(name)  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"HelloTimer_%@_Timer",name]]

@interface HelloTimerModel : NSObject

/** 毫秒为单位计算 */
@property (nonatomic, assign) NSTimeInterval time;
/** 原始开始时间 毫秒 */
@property (nonatomic, assign) NSTimeInterval oriTime;
/** 进度单位 */
@property (nonatomic, assign) NSTimeInterval unit;
/** 定时器执行block */

/** 是否本地持久化保存定时数据 */
@property (nonatomic,assign) BOOL isDisk;
/** 是否暂停 */
@property (nonatomic,assign) BOOL isPause;
/** 标识 */
@property (nonatomic, copy) NSString *identifier;
/** 通知名称 */
@property (nonatomic, copy) NSString *NFName;
/** 通知类型 0.不发通知 1.毫秒通知 2.秒通知 */
@property (nonatomic, assign) HelloTimerSecondChangeNFType NFType;


@property (nonatomic, copy) HelloTimerChangeBlock handleBlock;
/** 定时器执行block */
@property (nonatomic, copy) HelloTimerFinishBlock finishBlock;
/** 定时器执行block */
@property (nonatomic, copy) HelloTimerPauseBlock pauseBlock;

+ (instancetype)timeInterval:(NSInteger)timeInterval;

@end

@implementation HelloTimerModel

+ (instancetype)timeInterval:(NSInteger)timeInterval {
    HelloTimerModel *object = [HelloTimerModel new];
    object.time = timeInterval*1000;
    object.oriTime = timeInterval*1000;
    return object;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeDouble:self.time forKey:@"timeInterval"];
    [aCoder encodeDouble:self.oriTime forKey:@"oriTime"];
    [aCoder encodeDouble:self.unit forKey:@"unit"];
    [aCoder encodeBool:self.isDisk forKey:@"isDisk"];
    [aCoder encodeBool:self.isPause forKey:@"isPause"];
    [aCoder encodeObject:self.identifier forKey:@"identifier"];
    [aCoder encodeBool:self.NFType forKey:@"NFType"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.time = [aDecoder decodeDoubleForKey:@"timeInterval"];
        self.oriTime = [aDecoder decodeDoubleForKey:@"oriTime"];
        self.unit = [aDecoder decodeDoubleForKey:@"unit"];
        self.isDisk = [aDecoder decodeBoolForKey:@"isDisk"];
        self.isPause = [aDecoder decodeBoolForKey:@"isPause"];
        self.identifier = [aDecoder decodeObjectForKey:@"identifier"];
        self.NFType = [aDecoder decodeBoolForKey:@"NFType"];
    }
    return self;
}

@end

@interface HelloTimer ()

@property (nonatomic, strong) NSTimer * _Nullable showTimer;
/** 储存多个计时器数据源 */
@property (nonatomic, strong) NSMutableDictionary<NSString *, HelloTimerModel *> *timerMdic;


@end

@implementation HelloTimer

static HelloTimer *_instance;


HelloTimer *HelloTimerM(void) {
    return [HelloTimer sharedInstance];
}

+ (instancetype)sharedInstance {
    if (!_instance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _instance = [[self alloc] init];
        });
    }
    return _instance;
}


+ (id)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

/// 设置倒计时任务的通知回调
/// @param name 通知名
/// @param identifier 倒计时任务的标识
/// @param type 倒计时变化通知类型
+ (void)setNotificationForName:(NSString *)name identifier:(NSString *)identifier changeNFType:(HelloTimerSecondChangeNFType)type  {
    if (identifier.length<=0) {
        NSLog(@"计时器标识不能为空");
        return;
    }
    HelloTimerModel *model = HelloTimerM().timerMdic[identifier];
    if (model) {
        model.NFType = type;
        model.NFName = name;
        return;
    }else {
        NSLog(@"找不到计时器任务");
        return;
    }
}


/** 添加定时器并开启计时 */
+ (void)addTimerForTime:(NSTimeInterval)time handle:(HelloTimerChangeBlock)handle {
    [self initTimerForForTime:time identifier:nil ForIsDisk:NO unit:-1 handle:handle finish:nil pause:nil];
}
/** 添加定时器并开启计时 */
+ (void)addTimerForTime:(NSTimeInterval)time
             identifier:(NSString *)identifier
                 handle:(HelloTimerChangeBlock)handle {
    
     [self initTimerForForTime:time
                    identifier:identifier
                     ForIsDisk:NO
                          unit:-1
                        handle:handle
                        finish:nil
                         pause:nil];
}
/** 添加定时器并开启计时 */
+ (void)addTimerForTime:(NSTimeInterval)time
             identifier:(NSString *)identifier
                 handle:(HelloTimerChangeBlock)handle
                 finish:(HelloTimerFinishBlock)finishBlock
                  pause:(HelloTimerPauseBlock)pauseBlock {
    
     [self initTimerForForTime:time
                    identifier:identifier
                     ForIsDisk:NO
                          unit:-1
                        handle:handle
                        finish:finishBlock
                         pause:pauseBlock];
}

/** 添加定时器并开启计时 */
+ (void)addDiskTimerForTime:(NSTimeInterval)time
                 identifier:(NSString *)identifier
                     handle:(HelloTimerChangeBlock)handle {
    
     [self initTimerForForTime:time
                    identifier:identifier
                     ForIsDisk:YES
                          unit:-1
                        handle:handle
                        finish:nil
                         pause:nil];
}

/** 添加定时器并开启计时 */
+ (void)addDiskTimerForTime:(NSTimeInterval)time
                 identifier:(NSString *)identifier
                     handle:(HelloTimerChangeBlock)handle
                     finish:(HelloTimerFinishBlock)finishBlock
                      pause:(HelloTimerPauseBlock)pauseBlock {
    
     [self initTimerForForTime:time
                    identifier:identifier
                     ForIsDisk:YES
                          unit:-1
                        handle:handle
                        finish:finishBlock
                         pause:pauseBlock];
}


/** 添加定时器并开启计时 */
+ (void)addMinuteTimerForTime:(NSTimeInterval)time handle:(HelloTimerChangeBlock)handle {
     [self initTimerForForTime:time identifier:nil ForIsDisk:NO unit:1000 handle:handle finish:nil pause:nil];
}
/** 添加定时器并开启计时 */
+ (void)addMinuteTimerForTime:(NSTimeInterval)time
                   identifier:(NSString *)identifier
                       handle:(HelloTimerChangeBlock)handle {
    
     [self initTimerForForTime:time
                    identifier:identifier
                     ForIsDisk:NO
                          unit:1000
                        handle:handle
                        finish:nil
                         pause:nil];
}

/** 添加定时器并开启计时 */
+ (void)addMinuteTimerForTime:(NSTimeInterval)time
                   identifier:(NSString *)identifier
                       handle:(HelloTimerChangeBlock)handle
                       finish:(HelloTimerFinishBlock)finishBlock
                        pause:(HelloTimerPauseBlock)pauseBlock {
    
     [self initTimerForForTime:time
                    identifier:identifier
                     ForIsDisk:NO
                          unit:1000
                        handle:handle
                        finish:finishBlock
                         pause:pauseBlock];
}

/** 添加定时器并开启计时 */
+ (void)addDiskMinuteTimerForTime:(NSTimeInterval)time
                       identifier:(NSString *)identifier
                           handle:(HelloTimerChangeBlock)handle
                           finish:(HelloTimerFinishBlock)finishBlock
                            pause:(HelloTimerPauseBlock)pauseBlock {
    
     [self initTimerForForTime:time
                    identifier:identifier
                     ForIsDisk:YES
                          unit:1000
                        handle:handle
                        finish:finishBlock
                         pause:pauseBlock];
}

//总初始化入口
+ (void)initTimerForForTime:(NSTimeInterval)time
                 identifier:(NSString *)identifier
                  ForIsDisk:(BOOL)isDisk
                       unit:(NSTimeInterval)unit
                     handle:(HelloTimerChangeBlock)handle
                     finish:(HelloTimerFinishBlock)finishBlock
                      pause:(HelloTimerPauseBlock)pauseBlock {
    
    if (identifier.length<=0) {
        HelloTimerModel *model = [HelloTimerModel timeInterval:time];
        model.isDisk = isDisk;
        model.identifier = [NSString stringWithFormat:@"%p",model];
        model.unit = unit;
        model.handleBlock = handle;
        model.finishBlock = finishBlock;
        model.pauseBlock = pauseBlock;
        [HelloTimerM().timerMdic setObject:model forKey:model.identifier];
        if (model.handleBlock) {
            NSInteger totalSeconds = model.time/1000.0;
            NSString *days = [NSString stringWithFormat:@"%zd", totalSeconds/60/60/24];
            NSString *hours =  [NSString stringWithFormat:@"%zd", totalSeconds/60/60%24];
            NSString *minute = [NSString stringWithFormat:@"%zd", (totalSeconds/60)%60];
            NSString *second = [NSString stringWithFormat:@"%zd", totalSeconds%60];
            CGFloat sss = ((NSInteger)(model.time))%1000/10;
            NSString *ss = [NSString stringWithFormat:@"%.lf", sss];
            
            if (hours.integerValue < 10) {
                hours = [NSString stringWithFormat:@"0%@", hours];
            }
            if (minute.integerValue < 10) {
                minute = [NSString stringWithFormat:@"0%@", minute];
            }
            if (second.integerValue < 10) {
                second = [NSString stringWithFormat:@"0%@", second];
            }
            if (ss.integerValue < 10) {
                ss = [NSString stringWithFormat:@"0%@", ss];
            }
            model.handleBlock(days,hours,minute,second,ss);
          
        }
        // 发出通知
        if (model.NFType != HelloTimerSecondChangeNFTypeNone) {
            [[NSNotificationCenter defaultCenter] postNotificationName:model.NFName object:nil userInfo:nil];
        }
        if (model.isDisk) {
             [self savaForTimerModel:model];
        }
        [self initTimer];
        return;
    }
    
        
    BOOL isTempDisk = [HelloTimer timerIsExistInDiskForIdentifier:identifier];//磁盘有任务
    BOOL isRAM = HelloTimerM().timerMdic[identifier]?YES:NO;//内存有任务
    
    if (!isRAM && !isTempDisk) {//新任务
        HelloTimerModel *model = [HelloTimerModel timeInterval:time];
        model.handleBlock = handle;
        model.isDisk = isDisk;
        model.identifier = identifier;
        model.unit = unit;
        model.finishBlock = finishBlock;
        model.pauseBlock = pauseBlock;
        [HelloTimerM().timerMdic setObject:model forKey:identifier];
        if (model.handleBlock) {
            
            NSInteger totalSeconds = model.time/1000.0;
            NSString *days = [NSString stringWithFormat:@"%zd", totalSeconds/60/60/24];
            NSString *hours =  [NSString stringWithFormat:@"%zd", totalSeconds/60/60%24];
            NSString *minute = [NSString stringWithFormat:@"%zd", (totalSeconds/60)%60];
            NSString *second = [NSString stringWithFormat:@"%zd", totalSeconds%60];
            CGFloat sss = ((NSInteger)(model.time))%1000/10;
            NSString *ss = [NSString stringWithFormat:@"%.lf", sss];
            
            if (hours.integerValue < 10) {
                hours = [NSString stringWithFormat:@"0%@", hours];
            }
            if (minute.integerValue < 10) {
                minute = [NSString stringWithFormat:@"0%@", minute];
            }
            if (second.integerValue < 10) {
                second = [NSString stringWithFormat:@"0%@", second];
            }
            if (ss.integerValue < 10) {
                ss = [NSString stringWithFormat:@"0%@", ss];
            }
            if (model.isDisk) {
                [self savaForTimerModel:model];
            }
            model.handleBlock(days,hours,minute,second,ss);
            
        }
        // 发出通知
        if (model.NFType != HelloTimerSecondChangeNFTypeNone) {
            [[NSNotificationCenter defaultCenter] postNotificationName:model.NFName object:nil userInfo:nil];
        }
        [self initTimer];
    }
    
    
    if (isRAM && !isTempDisk) {//内存任务
        HelloTimerModel *model = HelloTimerM().timerMdic[identifier];
        model.isPause = NO;
        model.handleBlock = handle;
        model.isDisk = isDisk;
        model.finishBlock = finishBlock;
        model.pauseBlock = pauseBlock;
        if (model.isDisk) {
            [self savaForTimerModel:model];
        }
//         [self initTimer];
    }
    
    if (!isRAM && isTempDisk) {//硬盘的任务
        HelloTimerModel *model = [HelloTimer getTimerModelForIdentifier:identifier];
        if (isDisk == NO) {
            [HelloTimer deleteForIdentifier:identifier];
        }
        model.isPause = NO;
        model.isDisk = isDisk;
        model.handleBlock = handle;
        model.finishBlock = finishBlock;
        model.pauseBlock = pauseBlock;
        [HelloTimerM().timerMdic setObject:model forKey:identifier];
        if (model.handleBlock) {
            NSInteger totalSeconds = model.time/1000.0;
            NSString *days = [NSString stringWithFormat:@"%zd", totalSeconds/60/60/24];
            NSString *hours =  [NSString stringWithFormat:@"%zd", totalSeconds/60/60%24];
            NSString *minute = [NSString stringWithFormat:@"%zd", (totalSeconds/60)%60];
            NSString *second = [NSString stringWithFormat:@"%zd", totalSeconds%60];
            CGFloat sss = ((NSInteger)(model.time))%1000/10;
            NSString *ss = [NSString stringWithFormat:@"%.lf", sss];
            
            if (hours.integerValue < 10) {
                hours = [NSString stringWithFormat:@"0%@", hours];
            }
            if (minute.integerValue < 10) {
                minute = [NSString stringWithFormat:@"0%@", minute];
            }
            if (second.integerValue < 10) {
                second = [NSString stringWithFormat:@"0%@", second];
            }
            if (ss.integerValue < 10) {
                ss = [NSString stringWithFormat:@"0%@", ss];
            }
            model.handleBlock(days,hours,minute,second,ss);
           
        }
        // 发出通知
        if (model.NFType != HelloTimerSecondChangeNFTypeNone) {
            [[NSNotificationCenter defaultCenter] postNotificationName:model.NFName object:nil userInfo:nil];
        }
        if (model.isDisk) {
            [self savaForTimerModel:model];
        }
        [self initTimer];
    }
    
    if (isRAM && isTempDisk) {//硬盘的任务
        HelloTimerModel *model = [HelloTimer getTimerModelForIdentifier:identifier];
        model.isPause = NO;
        if (isDisk == NO) {
            [HelloTimer deleteForIdentifier:identifier];
        }
        model.isDisk = isDisk;
        model.handleBlock = handle;
        model.finishBlock = finishBlock;
        model.pauseBlock = pauseBlock;
        [HelloTimerM().timerMdic setObject:model forKey:identifier];
        if (model.handleBlock) {
            NSInteger totalSeconds = model.time/1000.0;
            NSString *days = [NSString stringWithFormat:@"%zd", totalSeconds/60/60/24];
            NSString *hours =  [NSString stringWithFormat:@"%zd", totalSeconds/60/60%24];
            NSString *minute = [NSString stringWithFormat:@"%zd", (totalSeconds/60)%60];
            NSString *second = [NSString stringWithFormat:@"%zd", totalSeconds%60];
            CGFloat sss = ((NSInteger)(model.time))%1000/10;
            NSString *ss = [NSString stringWithFormat:@"%.lf", sss];
            
            if (hours.integerValue < 10) {
                hours = [NSString stringWithFormat:@"0%@", hours];
            }
            if (minute.integerValue < 10) {
                minute = [NSString stringWithFormat:@"0%@", minute];
            }
            if (second.integerValue < 10) {
                second = [NSString stringWithFormat:@"0%@", second];
            }
            if (ss.integerValue < 10) {
                ss = [NSString stringWithFormat:@"0%@", ss];
            }
            model.handleBlock(days,hours,minute,second,ss);
            
        }
        // 发出通知
        if (model.NFType != HelloTimerSecondChangeNFTypeNone) {
            [[NSNotificationCenter defaultCenter] postNotificationName:model.NFName object:nil userInfo:nil];
        }
        if (model.isDisk) {
            [self savaForTimerModel:model];
        }
//        [self initTimer];
    }
    
}

+ (NSTimeInterval)getTimeIntervalForIdentifier:(NSString *)identifier {
    if (identifier.length<=0) {
        return 0.0;
    }
    
    BOOL isTempDisk = [HelloTimer timerIsExistInDiskForIdentifier:identifier];//磁盘有任务
    BOOL isRAM = HelloTimerM().timerMdic[identifier]?YES:NO;//内存有任务
    
    
    if (isTempDisk) {
        HelloTimerModel *model = [HelloTimer loadTimerForIdentifier:identifier];
        return model.oriTime - model.time;
    }else if (isRAM) {
        HelloTimerModel *model = HelloTimerM().timerMdic[identifier];
        return model.oriTime - model.time;
    }else {
        NSLog(@"找不到计时任务");
        return 0.0;
    }
    
}

+ (BOOL)pauseTimerForIdentifier:(NSString *)identifier {
    if (identifier.length<=0) {
        NSLog(@"计时器标识不能为空");
        return NO;
    }
    HelloTimerModel *model = HelloTimerM().timerMdic[identifier];
    
    if (model) {
        model.isPause = YES;
        if (model.pauseBlock) { model.pauseBlock(model.identifier); }
        return YES;
    }else {
        NSLog(@"找不到计时器任务");
        return NO;
    }
}

+ (void)pauseAllTimer {
    [HelloTimerM().timerMdic enumerateKeysAndObjectsUsingBlock:^(NSString *key, HelloTimerModel *obj, BOOL *stop) {
        obj.isPause = YES;
        if (obj.pauseBlock) { obj.pauseBlock(obj.identifier); }
    }];
}

+ (BOOL)restartTimerForIdentifier:(NSString *)identifier {
    if (identifier.length<=0) {
        NSLog(@"计时器标识不能为空");
        return NO;
    }
    
    //只有内存任务才能重启, 硬盘任务只能调用addTimer系列方法重启
    BOOL isRAM = HelloTimerM().timerMdic[identifier]?YES:NO;//内存有任务
    if (isRAM) {
        HelloTimerModel *model = HelloTimerM().timerMdic[identifier];
        model.isPause = NO;
        return YES;
    }else {
        NSLog(@"找不到计时器任务");
        return NO;
    }
    
    
}
+ (void)restartAllTimer {
    
    if (HelloTimerM().timerMdic.count<=0) {
        return;
    }
    
    [HelloTimerM().timerMdic enumerateKeysAndObjectsUsingBlock:^(NSString *key, HelloTimerModel *obj, BOOL *stop) {
        obj.isPause = NO;
    }];
}

+ (BOOL)resetTimerForIdentifier:(NSString *)identifier {
    if (identifier.length<=0) {
        NSLog(@"计时器标识不能为空");
        return NO;
    }
    
    //只有内存任务才能重启, 硬盘任务只能调用addTimer系列方法重启
    BOOL isRAM = HelloTimerM().timerMdic[identifier]?YES:NO;//内存有任务
    if (isRAM) {
        HelloTimerModel *model = HelloTimerM().timerMdic[identifier];
        model.isPause = NO;
        model.time = model.oriTime;
        if (model.handleBlock) {
            NSInteger totalSeconds = model.time/1000.0;
            NSString *days = [NSString stringWithFormat:@"%zd", totalSeconds/60/60/24];
            NSString *hours =  [NSString stringWithFormat:@"%zd", totalSeconds/60/60%24];
            NSString *minute = [NSString stringWithFormat:@"%zd", (totalSeconds/60)%60];
            NSString *second = [NSString stringWithFormat:@"%zd", totalSeconds%60];
            CGFloat sss = ((NSInteger)(model.time))%1000/10;
            NSString *ss = [NSString stringWithFormat:@"%.lf", sss];
            
            if (hours.integerValue < 10) {
                hours = [NSString stringWithFormat:@"0%@", hours];
            }
            if (minute.integerValue < 10) {
                minute = [NSString stringWithFormat:@"0%@", minute];
            }
            if (second.integerValue < 10) {
                second = [NSString stringWithFormat:@"0%@", second];
            }
            if (ss.integerValue < 10) {
                ss = [NSString stringWithFormat:@"0%@", ss];
            }
            model.handleBlock(days,hours,minute,second,ss);
            
        }
        return YES;
    }else {
        NSLog(@"找不到计时器任务");
        return NO;
    }
}

+ (void)resetAllTimer {
    if (HelloTimerM().timerMdic.count<=0) {
        return;
    }
    
    [HelloTimerM().timerMdic enumerateKeysAndObjectsUsingBlock:^(NSString *key, HelloTimerModel *obj, BOOL *stop) {
        obj.isPause = NO;
        obj.time = obj.oriTime;
        if (obj.handleBlock) {
            NSInteger totalSeconds = obj.time/1000.0;
            NSString *days = [NSString stringWithFormat:@"%zd", totalSeconds/60/60/24];
            NSString *hours =  [NSString stringWithFormat:@"%zd", totalSeconds/60/60%24];
            NSString *minute = [NSString stringWithFormat:@"%zd", (totalSeconds/60)%60];
            NSString *second = [NSString stringWithFormat:@"%zd", totalSeconds%60];
            CGFloat sss = ((NSInteger)(obj.time))%1000/10;
            NSString *ss = [NSString stringWithFormat:@"%.lf", sss];
            
            if (hours.integerValue < 10) {
                hours = [NSString stringWithFormat:@"0%@", hours];
            }
            if (minute.integerValue < 10) {
                minute = [NSString stringWithFormat:@"0%@", minute];
            }
            if (second.integerValue < 10) {
                second = [NSString stringWithFormat:@"0%@", second];
            }
            if (ss.integerValue < 10) {
                ss = [NSString stringWithFormat:@"0%@", ss];
            }
            obj.handleBlock(days,hours,minute,second,ss);
          
        }
    }];
}

+ (BOOL)removeTimerForIdentifier:(NSString *)identifier {
    if (identifier.length<=0) {
        NSLog(@"计时器标识不能为空");
        return NO;
    }
    
    //移除磁盘的
    if([HelloTimer timerIsExistInDiskForIdentifier:identifier]) [HelloTimer deleteForIdentifier:identifier];
    //移除内存的
    [HelloTimerM().timerMdic removeObjectForKey:identifier];
    
    if (HelloTimerM().timerMdic.count<=0) {//如果没有计时任务了 就销毁计时器
        [HelloTimerM().showTimer invalidate];
        HelloTimerM().showTimer = nil;
    }
    return YES;
}

+ (void)removeAllTimer {
    //移除磁盘的
    for (NSString *identifier in HelloTimerM().timerMdic.allKeys) {
        if([HelloTimer timerIsExistInDiskForIdentifier:identifier]) [HelloTimer deleteForIdentifier:identifier];
    }
    //移除内存的
    [HelloTimerM().timerMdic removeAllObjects];
    [HelloTimerM().showTimer invalidate];
    HelloTimerM().showTimer = nil;
}

/** increase YES: 递增 NO: 递减   */
+ (void)initTimer {
    
    if (HelloTimerM().showTimer) {
        return;
    }
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:0.01f target:HelloTimerM() selector:@selector(timerChange) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    HelloTimerM().showTimer = timer;
    
}

- (void)timerChange {
    // 时间差+
    [HelloTimerM().timerMdic enumerateKeysAndObjectsUsingBlock:^(NSString *key, HelloTimerModel *obj, BOOL *stop) {
        if (!obj.isPause) {
            
            obj.time = obj.time-10.0;
            
            if (obj.unit>-1) {
                obj.unit = obj.unit-10.0;
            }
            
            if (obj.time<0) {//计时结束
                obj.time = 0;
                obj.isPause = YES;
            }
            NSInteger totalSeconds = obj.time/1000.0;
            NSString *days = [NSString stringWithFormat:@"%zd", totalSeconds/60/60/24];
            NSString *hours =  [NSString stringWithFormat:@"%zd", totalSeconds/60/60%24];
            NSString *minute = [NSString stringWithFormat:@"%zd", (totalSeconds/60)%60];
            NSString *second = [NSString stringWithFormat:@"%zd", totalSeconds%60];
            CGFloat sss = ((NSInteger)(obj.time))%1000/10;
            NSString *ms = [NSString stringWithFormat:@"%.lf", sss];
            
            if (hours.integerValue < 10) {
                hours = [NSString stringWithFormat:@"0%@", hours];
            }
            if (minute.integerValue < 10) {
                minute = [NSString stringWithFormat:@"0%@", minute];
            }
            if (second.integerValue < 10) {
                second = [NSString stringWithFormat:@"0%@", second];
            }
            if (ms.integerValue < 10) {
                ms = [NSString stringWithFormat:@"0%@", ms];
            }
            
            
            
            if (obj.unit<=-1) {
                if (obj.handleBlock) {obj.handleBlock(days,hours,minute,second,ms);}
                
                if (obj.NFType == HelloTimerSecondChangeNFTypeMS) {
                    // 发出通知
                    [[NSNotificationCenter defaultCenter] postNotificationName:obj.NFName object:nil userInfo:nil];
                }
            }else if (obj.unit == 0) {
                if (obj.handleBlock) {obj.handleBlock(days,hours,minute,second,ms);}
                obj.unit = 1000;
                if (obj.NFType == HelloTimerSecondChangeNFTypeSecond) {
                    // 发出通知
                    [[NSNotificationCenter defaultCenter] postNotificationName:obj.NFName object:nil userInfo:nil];
                }
            }
            
            if (obj.isDisk) {
                [HelloTimer savaForTimerModel:obj];
            }
            
            if (obj.time<=0) {//计时器计时完毕自动移除计时任务
                if (obj.finishBlock) { obj.finishBlock(obj.identifier); }
                [HelloTimerM().timerMdic removeObjectForKey:obj.identifier];
                [HelloTimer deleteForIdentifier:obj.identifier];
            }
            
        }
    }];
  
}

- (NSMutableDictionary<NSString *,HelloTimerModel *> *)timerMdic {
    if(_timerMdic) return _timerMdic;
    _timerMdic = [NSMutableDictionary dictionary];
    return _timerMdic;
}



#pragma mark - ***** other *****

+ (BOOL)timerIsExistInDiskForIdentifier:(NSString *)identifier {
    NSString *filePath = LSTPopViewTimerPath(identifier);
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    return isExist;
}

/** 格式化时间  */
+ (void)formatDateForTime:(NSTimeInterval)time handle:(HelloTimerChangeBlock)handle {
    if (handle) {
        NSInteger totalSeconds = time/1000.0;
        NSString *days = [NSString stringWithFormat:@"%zd", totalSeconds/60/60/24];
        NSString *hours =  [NSString stringWithFormat:@"%zd", totalSeconds/60/60%24];
        NSString *minute = [NSString stringWithFormat:@"%zd", (totalSeconds/60)%60];
        NSString *second = [NSString stringWithFormat:@"%zd", totalSeconds%60];
        CGFloat sss = ((NSInteger)(time))%1000/10;
        NSString *ms = [NSString stringWithFormat:@"%.lf", sss];
        
        if (hours.integerValue < 10) {
            hours = [NSString stringWithFormat:@"0%@", hours];
        }
        if (minute.integerValue < 10) {
            minute = [NSString stringWithFormat:@"0%@", minute];
        }
        if (second.integerValue < 10) {
            second = [NSString stringWithFormat:@"0%@", second];
        }
        if (ms.integerValue < 10) {
            ms = [NSString stringWithFormat:@"0%@", ms];
        }
        
        handle(days,hours,minute,second,ms);
    }
}


+ (BOOL)savaForTimerModel:(HelloTimerModel *)model {
    NSString *filePath = LSTPopViewTimerPath(model.identifier);
    return [NSKeyedArchiver archiveRootObject:model toFile:filePath];
}

+ (HelloTimerModel *)loadTimerForIdentifier:(NSString *)identifier{
    NSString *filePath = LSTPopViewTimerPath(identifier);
    return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
}

+ (BOOL)deleteForIdentifier:(NSString *)identifier {
    NSString *filePath = LSTPopViewTimerPath(identifier);
    NSFileManager* fileManager = [NSFileManager defaultManager];
    BOOL isExist = [fileManager fileExistsAtPath:filePath];
    if (isExist) {
        return [fileManager removeItemAtPath:filePath error:nil];
    }
    return NO;
}

+ (HelloTimerModel *)getTimerModelForIdentifier:(NSString *)identifier {
    if (identifier.length<=0) {
        return nil;
    }
    HelloTimerModel *model = [HelloTimer loadTimerForIdentifier:identifier];
    return model;
    
}


@end
