//
//  HelloToast.m
//  HelloOCKit
//
//  Created by Weiyan  Li  on 2023/10/27.
//

#import "HelloToast.h"
#import "MBProgressHUD.h"
#import <Masonry/Masonry.h>
#import "HelloPopView.h"

@implementation HelloToast

+ (void)showToast:(NSString *)toast{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:rootWindow() animated:NO];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:rootWindow() animated:NO];
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView = toastView(toast, hud);
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.margin = 0;
        hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        hud.bezelView.layer.cornerRadius = 4;
        hud.bezelView.layer.masksToBounds = NO;
        hud.removeFromSuperViewOnHide = YES;
        [hud hideAnimated:NO afterDelay:2];
    });
//    dispatch_async(dispatch_get_main_queue(), ^{
//        HelloPopView *pop = [HelloPopView getPopViewForKey:@"helloToast"];
//        if(pop){
//            [HelloPopView removePopViewForKey:@"helloToast"];
//            HelloPopView *popView  = [HelloPopView initWithCustomView:ToastPopView(toast)];
//            popView.identifier = @"helloToast";
//            popView.hemStyle = HelloHemStyleBottom;
//            popView.adjustY = -rootWindow().safeAreaInsets.bottom;
//            popView.popStyle = HelloPopStyleSmoothFromBottom;
//            popView.bgAlpha = 0;
//            popView.showTime = 2;
//            [popView pop];
//        }else{
//            HelloPopView *popView  = [HelloPopView initWithCustomView:ToastPopView(toast)];
//            popView.identifier = @"helloToast";
//            popView.hemStyle = HelloHemStyleBottom;
//            popView.adjustY = -rootWindow().safeAreaInsets.bottom;
//            popView.popStyle = HelloPopStyleSmoothFromBottom;
//            popView.bgAlpha = 0;
//            popView.showTime = 2;
//            [popView pop];
//        }
//    });
    
}

+ (void)showGoingToast:(NSString *)toast{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:rootWindow() animated:NO];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:rootWindow() animated:NO];
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView = toastView(toast, hud);
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.margin = 0;
        hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        hud.bezelView.layer.cornerRadius = 4;
        hud.bezelView.layer.masksToBounds = NO;
        hud.removeFromSuperViewOnHide = YES;
    });
}

+ (void)dismiss{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:rootWindow() animated:NO];
    });

}

///获取自定义HelloPopView Toast
UIView *ToastPopView(NSString *title){
    float maxWidth = UIScreen.mainScreen.bounds.size.width-40*2-24*2;
    CGRect rect = [title boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    containerView.center = CGPointMake(UIScreen.mainScreen.bounds.size.height/2.0, UIScreen.mainScreen.bounds.size.width/2.0);
    containerView.bounds = CGRectMake(0, 0, rect.size.width + 24*2, rect.size.height + 13*2);
    containerView.layer.cornerRadius = 4.f;
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [containerView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(maxWidth);
        make.center.offset(0);
    }];
    return containerView;
}

///获取自定义MBProgressHUD Toast
UIView *toastView(NSString *title,MBProgressHUD *superView){
    
    float maxWidth = UIScreen.mainScreen.bounds.size.width-40*2-24*2;
    CGRect rect = [title boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = [UIColor clearColor];
    superView.customView = containerView;
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(rect.size.width + 24*2, rect.size.height + 13*2));
    }];
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [containerView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(maxWidth);
        make.center.offset(0);
    }];
    return containerView;
}

///获取窗口
UIWindow *rootWindow(void){
     
    if([[[UIApplication sharedApplication] delegate] window]){
        return [[[UIApplication sharedApplication] delegate] window];
    }else {
        if (@available(iOS 13.0,*)) {
            NSArray *arr = [[[UIApplication sharedApplication] connectedScenes] allObjects];
            UIWindowScene *windowScene =  (UIWindowScene *)arr[0];
            UIWindow *mainWindow = [windowScene valueForKeyPath:@"delegate.window"];
            if(mainWindow){
                return mainWindow;
            }else{
                return [UIApplication sharedApplication].windows.lastObject;
            }
        }else {
            return [UIApplication sharedApplication].keyWindow;
        }
    }
}

@end
