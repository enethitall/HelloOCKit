

#import "UIView+Hello.h"

@implementation UIView (Hello)


- (void)setHl_x:(CGFloat)pv_X {
    CGRect frame = self.frame;
    frame.origin.x = pv_X;
    self.frame = frame;
}

- (CGFloat)hl_x {
    return self.frame.origin.x;
}

- (void)setHl_y:(CGFloat)pv_Y {
    CGRect frame = self.frame;
    frame.origin.y = pv_Y;
    self.frame = frame;
}

- (CGFloat)hl_y {
    return self.frame.origin.y;
}

- (void)setHl_width:(CGFloat)pv_Width {
    CGRect frame = self.frame;
    frame.size.width = pv_Width;
    self.frame = frame;
}

- (CGFloat)hl_width {
    return self.frame.size.width;
}

- (void)setHl_height:(CGFloat)pv_Height {
    CGRect frame = self.frame;
    frame.size.height = pv_Height;
    self.frame = frame;
}

- (CGFloat)hl_height {
    return self.frame.size.height;
}

- (void)setHl_size:(CGSize)pv_Size {
    CGRect frame = self.frame;
    frame.size = pv_Size;
    self.frame = frame;
}

- (CGSize)hl_size {
    return self.frame.size;
}

- (void)setHl_centerX:(CGFloat)pv_CenterX {
    CGPoint center = self.center;
    center.x = pv_CenterX;
    self.center = center;
}

- (CGFloat)hl_centerX {
    return self.center.x;
}

- (void)setHl_centerY:(CGFloat)pv_CenterY {
    CGPoint center = self.center;
    center.y = pv_CenterY;
    self.center = center;
}

- (CGFloat)hl_centerY {
    return self.center.y;
}

- (void)setHl_top:(CGFloat)pv_Top {
    CGRect newframe = self.frame;
    newframe.origin.y = pv_Top;
    self.frame = newframe;
}

- (CGFloat)hl_top {
    return self.frame.origin.y;
}

- (void)setHl_left:(CGFloat)pv_Left {
    CGRect newframe = self.frame;
    newframe.origin.x = pv_Left;
    self.frame = newframe;
}

- (CGFloat)hl_left {
    return self.frame.origin.x;
}

- (void)setHl_bottom:(CGFloat)pv_Bottom {
    CGRect newframe = self.frame;
    newframe.origin.y = pv_Bottom - self.frame.size.height;
    self.frame = newframe;
}

- (CGFloat)hl_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setHl_right:(CGFloat)pv_Right {
    CGFloat delta = pv_Right - (self.frame.origin.x + self.frame.size.width);
    CGRect newframe = self.frame;
    newframe.origin.x += delta ;
    self.frame = newframe;
}

- (CGFloat)hl_right {
    return self.frame.origin.x + self.frame.size.width;
}

/** 是否是苹果X系列(刘海屏系列) */
BOOL hl_IsIphoneX(void) {
    if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
       if ( @available(iOS 13.0, *) ) {
           for ( UIScene *scene in UIApplication.sharedApplication.connectedScenes ) {
               if ( [scene isKindOfClass:UIWindowScene.class] ) {
                   UIWindow *window = [(UIWindowScene *)scene windows].firstObject;
                   if ( window.isKeyWindow ) return window.safeAreaInsets.bottom > 0.0;
               }
           }
       }
       if ( @available(iOS 11.0, *) ) {
           UIWindow *window = [UIApplication sharedApplication].delegate.window;
           return window.safeAreaInsets.bottom > 0.0;
       }
    }
    return NO;
}

CGSize hl_ScreenSize(void) {
    CGSize size = [UIScreen mainScreen].bounds.size;
    return size;
}

CGFloat hl_ScreenWidth(void) {
    CGSize size = [UIScreen mainScreen].bounds.size;
    return size.width;
}

CGFloat hl_ScreenHeight(void) {
    CGSize size = [UIScreen mainScreen].bounds.size;
    return size.height;
}

UIWindow *hl_Window(void) {
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
