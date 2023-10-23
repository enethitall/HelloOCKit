//
//  HelloLogViewController.m
//  HelloOCKit
//
//  Created by Weiyan  Li  on 2023/10/23.
//

#import "HelloLogViewController.h"
#import <Masonry/Masonry.h>
#import <YYText/YYTextView.h>
static const NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday;
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
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *logDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Log"];
    NSString *logFilePath = [logDirectory stringByAppendingFormat:[NSString stringWithFormat:@"/%ld-%ld-%ld.txt",[self currentYear],[self currentMonth],[self currentDay]]];
    NSData *data = [NSData dataWithContentsOfFile:logFilePath];
    textView.text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSRange range;
    range.location = 0;
    range.length = textView.text.length;
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

-(void)export{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *logDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Log"];
    NSString *logFilePath = [logDirectory stringByAppendingFormat:[NSString stringWithFormat:@"/%ld-%ld-%ld.txt",[self currentYear],[self currentMonth],[self currentDay]]];
    NSArray *itemsArr = @[[NSURL fileURLWithPath:logFilePath]];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:itemsArr applicationActivities:nil];
    activityViewController.completionWithItemsHandler = ^(UIActivityType __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError) {
        NSLog(@"completion: %@, %d, %@, %@", activityType, completed, returnedItems, activityError);
    };
    [self presentViewController:activityViewController animated:YES completion:nil];
}

-(void)exit{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)currentYear{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *components = [calendar components:unitFlags fromDate:currentDate];
    return components.year;
}

- (NSInteger)currentMonth{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *components = [calendar components:unitFlags fromDate:currentDate];
    return components.month;
}

- (NSInteger)currentDay{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *components = [calendar components:unitFlags fromDate:currentDate];
    return components.day;
}


@end
