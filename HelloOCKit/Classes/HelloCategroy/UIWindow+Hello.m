//
//  UIWindow+Hello.m
//  HelloOCKit
//
//  Created by Weiyan  Li  on 2023/10/23.
//

#import "UIWindow+Hello.h"

@implementation UIWindow (Hello)

+ (UIWindow *)hl_window{
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (UIWindow *temp in windows) {
            if (temp.windowLevel == UIWindowLevelNormal) {
                window = temp;
                break;
            }
        }
    }
    return window;
}

@end
