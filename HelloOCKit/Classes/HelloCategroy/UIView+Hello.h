

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Hello)

/** 获取/设置view的x坐标 */
@property (nonatomic, assign) CGFloat hl_x;
/** 获取/设置view的x坐标 */
@property (nonatomic, assign) CGFloat hl_y;
/** 获取/设置view的x坐标 */
@property (nonatomic, assign) CGFloat hl_width;
/** 获取/设置view的x坐标 */
@property (nonatomic, assign) CGFloat hl_height;
/** 获取/设置view的x坐标 */
@property (nonatomic, assign) CGFloat hl_centerX;
/** 获取/设置view的x坐标 */
@property (nonatomic, assign) CGFloat hl_centerY;
/** 获取/设置view的x坐标 */
@property (nonatomic, assign) CGFloat hl_top;
/** 获取/设置view的左边坐标 */
@property (nonatomic, assign) CGFloat hl_left;
/** 获取/设置view的底部坐标Y */
@property (nonatomic, assign) CGFloat hl_bottom;
/** 获取/设置view的右边坐标 */
@property (nonatomic, assign) CGFloat hl_right;
/** 获取/设置view的size */
@property (nonatomic, assign) CGSize hl_size;


/** 是否是苹果X系列(刘海屏系列) */
BOOL hl_IsIphoneX(void);
/** 屏幕大小 */
CGSize hl_ScreenSize(void);
/** 屏幕宽度 */
CGFloat hl_ScreenWidth(void);
/** 屏幕高度 */
CGFloat hl_ScreenHeight(void);
/** 窗口*/
UIWindow *hl_Window(void);


@end

NS_ASSUME_NONNULL_END
