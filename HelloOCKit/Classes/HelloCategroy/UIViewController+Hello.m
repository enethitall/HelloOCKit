//
//  UIViewController+Hello.m
//  AFNetworking
//
//  Created by Weiyan  Li  on 2023/10/23.
//

#import "UIViewController+Hello.h"
#import "UIWindow+Hello.h"

@implementation UIViewController (Hello)

+ (UIViewController *)hl_currentVC{
    UIViewController *result = nil;
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
    // 取当前展示的控制器
    result = window.rootViewController;
    while (result.presentedViewController) {
        result = result.presentedViewController;
    }
    // 如果为UITabBarController：取选中控制器
    if ([result isKindOfClass:[UITabBarController class]]) {
        result = [(UITabBarController *)result selectedViewController];
    }
    // 如果为UINavigationController：取可视控制器
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [(UINavigationController *)result visibleViewController];
    }
    return result;
}

+ (void)hl_popToViewController:(NSString *)viewController{
    
    UIViewController *currentVC = [self hl_currentVC];
    for (UIViewController *controller in currentVC.navigationController.viewControllers) {
        if ([controller isKindOfClass:NSClassFromString(viewController)]) {
            [currentVC.navigationController popToViewController:controller animated:YES];
        }
    }
    
}

- (void)hl_removeViewController:(UIViewController *)viewController{
    
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:viewController.navigationController.viewControllers];

    for (UIViewController *vc in viewControllers) {
        if (vc == viewController) {
            [viewControllers removeObject:vc];
            break;
        }
    }
    viewController.navigationController.viewControllers = viewControllers;
    
}

@end
