//
//  HelloLog.m
//  AFNetworking
//
//  Created by Weiyan  Li  on 2023/10/23.
//

#import "HelloLog.h"
#import "UIWindow+Hello.h"
#import "UIViewController+Hello.h"
#import "HelloLogViewController.h"

#define checkBtnWidth 60.0
#define checkBtnHeight 60.0

@interface HelloLog()

@property (nonatomic,strong) UIButton *checkButton;

@end

@implementation HelloLog
static HelloLog *_instance;
+ (instancetype)sharedInstance {
    if (!_instance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _instance = [[self alloc] init];
            [[NSNotificationCenter defaultCenter] addObserver:_instance selector:@selector(change) name:UIWindowDidBecomeHiddenNotification object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:_instance selector:@selector(quit) name:@"quit" object:nil];
        });
    }
    return _instance;
}

- (void)change{
    self.checkButton.hidden = YES;
}

- (void)quit{
    self.checkButton.hidden = NO;
}

- (void)enable{
    
    UIWindow *window = UIWindow.hl_window;
    [window addSubview:self.checkButton];
    
    NSDictionary *environment = [[NSProcessInfo processInfo] environment];
    BOOL isXcodeLaunch = NO;
    if([environment[@"OS_ACTIVITY_DT_MODE"] boolValue]) {
        //xcode启动
        isXcodeLaunch = YES;
    }
    
    if(!isXcodeLaunch){
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *logDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"HelloLogs"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL fileExists = [fileManager fileExistsAtPath:logDirectory];
        if (!fileExists) {
            [fileManager createDirectoryAtPath:logDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSString *logFilePath = [logDirectory stringByAppendingFormat:@"%@", [NSString stringWithFormat:@"/%ld-%ld-%ld.txt",[self currentYear],[self currentMonth],[self currentDay]]];
        // freopen 重定向输出流,将log输入到文件
        freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
        freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
    }
}

- (void)close{
    [self.checkButton removeFromSuperview];
}

//拖拽悬浮窗（pan移动手势响应）
- (void)locationChange:(UIPanGestureRecognizer*)p {
    CGFloat w = checkBtnWidth;
    CGFloat h = checkBtnWidth;
    CGFloat kw = [UIScreen mainScreen].bounds.size.width;
    CGFloat kh = [UIScreen mainScreen].bounds.size.height;
    CGFloat animateDuration = 0.3;
    
    CGPoint panPoint = [p locationInView:UIWindow.hl_window];
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

-(void)showCheckEnv{
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:HelloLogViewController.new];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [UIViewController.hl_currentVC presentViewController:nav animated:YES completion:nil];
}

- (NSInteger)currentYear{
    NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *components = [calendar components:unitFlags fromDate:currentDate];
    return components.year;
}

- (NSInteger)currentMonth{
    NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *components = [calendar components:unitFlags fromDate:currentDate];
    return components.month;
}

- (NSInteger)currentDay{
    NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *components = [calendar components:unitFlags fromDate:currentDate];
    return components.day;
}

@end
