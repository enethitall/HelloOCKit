//
//  HelloToast.h
//  HelloOCKit
//
//  Created by Weiyan  Li  on 2023/10/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HelloToast : NSObject

+ (void)showToast:(NSString *)toast;

+ (void)showGoingToast:(NSString *)toast;

+ (void)hiddenHUDActivity;

@end

NS_ASSUME_NONNULL_END
