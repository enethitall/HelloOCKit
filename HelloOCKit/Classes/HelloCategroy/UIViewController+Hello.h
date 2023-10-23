//
//  UIViewController+Hello.h
//  AFNetworking
//
//  Created by Weiyan  Li  on 2023/10/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Hello)

/**
 *  获取当前控制器
 *
 *  @return 当前控制器
 */
+ (UIViewController *)hl_currentVC;

/**
 *  返回指定控制器
 *
 *  @return 指定控制器
 */
+ (void)hl_popToViewController:(NSString *)viewController;

/**
 *  移除指定控制器
 *
 *  @return 指定控制器
 */
- (void)hl_removeViewController:(UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
