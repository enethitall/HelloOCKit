//
//  HelloDDLog.m
//  HelloOCKit
//
//  Created by Weiyan  Li  on 2024/5/16.
//

#import "HelloDDLog.h"
#import "HelloDDLogFileLogFormatter.h"
#import "HelloDDLogFileManager.h"
#import <objc/message.h>

DDLogLevel ddLogLevel = DDLogLevelVerbose;

#define checkBtnWidth 60.0
#define checkBtnHeight 60.0

@interface HelloDDLog()

@property (nonatomic, strong)DDFileLogger *fileLogger;//文件logger

@property (nonatomic,strong) UIButton *checkButton;

@property (nonatomic,copy) void(^tap)(void);

@end

@implementation HelloDDLog

static HelloDDLog *instance = nil;
static dispatch_once_t helloOnceToken;
+ (instancetype)shareInstance
{
    dispatch_once(&helloOnceToken, ^{
        instance = [[HelloDDLog alloc] init];
        //默认打印控制台
        [DDLog addLogger:[DDOSLogger sharedInstance]];
    });
    return instance;
}

- (void)enable:(void(^)(void))touchUpInsideEvent{
    self.tap = touchUpInsideEvent;
    [UIApplication.sharedApplication.keyWindow addSubview:self.checkButton];
    [self addFileLogger];
}

- (void)close{
    [self.checkButton removeFromSuperview];
    [self removeFileLogger];
}

- (void)addFileLogger{
    [DDLog addLogger:self.fileLogger];
}

- (void)removeFileLogger{
    [DDLog removeLogger:self.fileLogger];
}

- (void)createAndRollToNewFile {
    //achive现在的文件，新生成一个文件，并将以后的log写入新文件
    [_fileLogger rollLogFileWithCompletionBlock:^{
        
    }];
}

//所有log文件路径
- (NSArray *)filePaths {
    return _fileLogger.logFileManager.sortedLogFilePaths;
}

//当前活跃的log文件路径
- (NSString *)currentFilePath {
    
    NSString *filePath = _fileLogger.currentLogFileInfo.filePath;
    return filePath;
}

//文件写入Logger
- (DDFileLogger *)fileLogger {
    if (!_fileLogger) {
        
        //使用自定义的logFileManager
        HelloDDLogFileManager *fileManager = [[HelloDDLogFileManager alloc] init];
        _fileLogger = [[DDFileLogger alloc] initWithLogFileManager:fileManager];
        //使用自定义的Logformatter
        _fileLogger.logFormatter = [[HelloDDLogFileLogFormatter alloc] init];
        
        //重用log文件，不要每次启动都创建新的log文件(默认值是NO)
        _fileLogger.doNotReuseLogFiles = NO;
        //log文件在24小时内有效，超过时间创建新log文件(默认值是24小时)
        _fileLogger.rollingFrequency = 60*60*24;
        //log文件的最大100M(默认值1M)
        _fileLogger.maximumFileSize = 1024*1024*100;
        //最多保存7个log文件(默认值是5)
        _fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
        //log文件夹最多保存1024M(默认值是20M)
        _fileLogger.logFileManager.logFilesDiskQuota = 1014*1024*1024;
    }
    return _fileLogger;
}


-(void)showCheckEnv{
    self.tap();
}

//拖拽悬浮窗（pan移动手势响应）
- (void)locationChange:(UIPanGestureRecognizer*)p {
    CGFloat w = checkBtnWidth;
    CGFloat h = checkBtnWidth;
    CGFloat kw = [UIScreen mainScreen].bounds.size.width;
    CGFloat kh = [UIScreen mainScreen].bounds.size.height;
    CGFloat animateDuration = 0.3;
    
    CGPoint panPoint = [p locationInView:UIApplication.sharedApplication.keyWindow];
    if(p.state == UIGestureRecognizerStateChanged)
    {
        self.checkButton.center = CGPointMake(panPoint.x, panPoint.y);
    }
    else if(p.state == UIGestureRecognizerStateEnded)
    {
        if(panPoint.x <= kw/2)
        {
            CGFloat pointy = panPoint.y;
            if (pointy < 64 + h/2) {
                pointy = 64 + h/2;
            }
            if (pointy > kh - checkBtnWidth - h/2) {
                pointy = kh - checkBtnWidth - h/2;
            }
            [UIView animateWithDuration:animateDuration animations:^{
                self.checkButton.center = CGPointMake(w/2, pointy);
            }];
        }
        else if(panPoint.x > kw/2)
        {
            CGFloat pointy = panPoint.y;
            if (pointy < 64 + h/2) {
                pointy = 64 + h/2;
            }
            if (pointy > kh - checkBtnWidth - h/2) {
                pointy = kh - checkBtnWidth - h/2;
            }
            [UIView animateWithDuration:animateDuration animations:^{
                self.checkButton.center = CGPointMake(kw-w/2, pointy);
            }];
        }
    }
}

- (UIButton *)checkButton {
    if (!_checkButton) {
        _checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _checkButton.frame = CGRectMake(0, UIScreen.mainScreen.bounds.size.width/2, checkBtnWidth, checkBtnHeight);
        _checkButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _checkButton.titleLabel.numberOfLines = 0;
        _checkButton.layer.cornerRadius = checkBtnWidth/2;
        _checkButton.layer.masksToBounds = YES;
        _checkButton.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.4];
        [_checkButton setTitle:@"Log" forState:UIControlStateNormal];
        [_checkButton addTarget:self action:@selector(showCheckEnv) forControlEvents:UIControlEventTouchUpInside];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(locationChange:)];
        pan.delaysTouchesBegan = NO;
        [_checkButton addGestureRecognizer:pan];
    }
    return _checkButton;
}

- (void)destory{
    helloOnceToken = 0;
    instance = nil;
}

-(void)printAllClass{
    
    const char *main = NSBundle.mainBundle.bundlePath.UTF8String;
    NSLog(@"main = %s",main);
    unsigned int image_count;
    const char **images = objc_copyImageNames(&image_count);
    for(int i = 0; i < image_count;i++)
    {
        const char *image = images[i];
        if ( !strstr(image, main) ) continue;
        NSLog(@"image_%i:%s",i,image);
        unsigned int cls_count = 0;
        const char **names = objc_copyClassNamesForImage(image, &cls_count);
        for ( unsigned int i = 0 ; i < cls_count ; ++ i ) {
            const char *cls_name = names[i];
            Class _Nullable cls = objc_getClass(cls_name);
            NSLog(@"cls_%i:%@",i,cls);
        }
        if ( names ) free(names);
    }
    if( images ) free(images);
}


@end
