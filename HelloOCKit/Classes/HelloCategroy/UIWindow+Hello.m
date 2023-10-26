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
//    if([[[UIApplication sharedApplication] delegate] window]){
//        return [[[UIApplication sharedApplication] delegate] window];
//    }else {
//        if (@available(iOS 13.0,*)) {
//            NSArray *arr = [[[UIApplication sharedApplication] connectedScenes] allObjects];
//            UIWindowScene *windowScene =  (UIWindowScene *)arr[0];
//            UIWindow *mainWindow = [windowScene valueForKeyPath:@"delegate.window"];
//            if(mainWindow){
//                return mainWindow;
//            }else{
//                return [UIApplication sharedApplication].windows.lastObject;
//            }
//        }else {
//            return [UIApplication sharedApplication].keyWindow;
//        }
//    }
}

@end
