//
//  HelloLogViewController.m
//  HelloOCKit
//
//  Created by Weiyan  Li  on 2023/10/23.
//

#import "HelloLogViewController.h"
#import <Masonry/Masonry.h>
#import <YYText/YYTextView.h>

@interface HelloLogViewController ()
@property (nonatomic,strong) YYTextView *textView;
@end

@implementation HelloLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    YYTextView *textView = [[YYTextView alloc]init];
    [self.view addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.offset(0);
    }];
    [textView becomeFirstResponder];
    textView.attributedText = [self logText];
    NSRange range;
    range.location = 0;
    range.length = textView.attributedText.length;
    [textView scrollRangeToVisible:range];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [textView resignFirstResponder];
        textView.editable = NO;
    });
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"导出" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(export) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [backButton setTitle:@"退出" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(exit) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
}

- (NSMutableAttributedString *)logText{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *logDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"HelloLogs"];
    NSString *logFilePath = [logDirectory stringByAppendingFormat:@"%@", [NSString stringWithFormat:@"/%ld-%ld-%ld.txt",[self currentYear],[self currentMonth],[self currentDay]]];
    NSData *data = [NSData dataWithContentsOfFile:logFilePath];
    NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString *sub= [NSNumber numberWithInteger:[self currentYear]].stringValue;
    NSMutableArray *locationArr = [self calculateSubStringCount:text str:sub];
    NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc] initWithString:text];
    for (int i=0; i<locationArr.count; i++) {
        NSNumber *location = locationArr[i];
        [attstr addAttribute:NSForegroundColorAttributeName value:[UIColor systemBlueColor] range:NSMakeRange(location.integerValue, @"xxxx-xx-xx xx:xx:xx.xxx".length)];
    }
    return attstr;
}

- (NSMutableArray*)calculateSubStringCount:(NSString *)content str:(NSString *)tab {
    
    NSMutableArray *locationArr = [NSMutableArray new];
    NSRange range = [content rangeOfString:tab];
    if (range.location == NSNotFound){
        return locationArr;
    }
    NSString *temp = @"";
    for (int i=0; i<tab.length; i++) {
        temp = [NSString stringWithFormat:@"%@x",temp];
    }
    NSString * subStr = content;
    while (range.location != NSNotFound) {
        //记录位置
        NSNumber *number = [NSNumber numberWithUnsignedInteger:range.location];
        [locationArr addObject:number];
        //每次记录之后,把找到的字符串替换成不符合规则的字符串，避免重复记录
        subStr = [subStr stringByReplacingCharactersInRange:range withString:temp];
        
        range = [subStr rangeOfString:tab];
    }
    return locationArr;
}

-(void)export{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *logDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"HelloLogs"];
    NSString *logFilePath = [logDirectory stringByAppendingFormat:@"%@", [NSString stringWithFormat:@"/%ld-%ld-%ld.txt",[self currentYear],[self currentMonth],[self currentDay]]];
    NSArray *itemsArr = @[[NSURL fileURLWithPath:logFilePath]];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:itemsArr applicationActivities:nil];
    activityViewController.completionWithItemsHandler = ^(UIActivityType __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError) {
        NSLog(@"completion: %@, %d, %@, %@", activityType, completed, returnedItems, activityError);
    };
    [self presentViewController:activityViewController animated:YES completion:nil];
}

-(void)exit{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"quit" object:self];
    }];
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
