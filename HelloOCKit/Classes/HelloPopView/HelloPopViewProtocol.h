

#import <Foundation/Foundation.h>
@class HelloPopView;

typedef void (^ _Nullable Hello_Block_Void)(void);
typedef void (^ _Nullable Hello_Block_Point)(CGPoint point);
typedef void (^ _Nullable Hello_Block_AlertCountDown)(HelloPopView * _Nonnull popView,NSTimeInterval timeInterval);
typedef void (^ _Nullable Hello_Block_KeyBoardChange)(CGRect beginFrame,CGRect endFrame,CGFloat duration);
typedef UIView * _Nonnull (^ _Nullable Hello_Block_View_Void)(void);

/** 调试日志类型 */
typedef NS_ENUM(NSInteger, HelloPopViewLogStyle) {
    HelloPopViewLogStyleNO = 0,          // 关闭调试信息(窗口和控制台日志输出)
    HelloPopViewLogStyleWindow,          // 开启左上角小窗
    HelloPopViewLogStyleConsole,         // 开启控制台日志输出
    HelloPopViewLogStyleALL              // 开启小窗和控制台日志
};

/** 显示动画样式 */
typedef NS_ENUM(NSInteger, HelloPopStyle) {
    HelloPopStyleFade = 0,               // 默认 渐变出现
    HelloPopStyleNO,                     // 无动画
    HelloPopStyleScale,                  // 缩放 先放大 后恢复至原大小
    HelloPopStyleSmoothFromTop,          // 顶部 平滑淡入动画
    HelloPopStyleSmoothFromLeft,         // 左侧 平滑淡入动画
    HelloPopStyleSmoothFromBottom,       // 底部 平滑淡入动画
    HelloPopStyleSmoothFromRight,        // 右侧 平滑淡入动画
    HelloPopStyleSpringFromTop,          // 顶部 平滑淡入动画 带弹簧
    HelloPopStyleSpringFromLeft,         // 左侧 平滑淡入动画 带弹簧
    HelloPopStyleSpringFromBottom,       // 底部 平滑淡入动画 带弹簧
    HelloPopStyleSpringFromRight,        // 右侧 平滑淡入动画 带弹簧
    HelloPopStyleCardDropFromLeft,       // 顶部左侧 掉落动画
    HelloPopStyleCardDropFromRight,      // 顶部右侧 掉落动画
};
/** 消失动画样式 */
typedef NS_ENUM(NSInteger, HelloDismissStyle) {
    HelloDismissStyleFade = 0,             // 默认 渐变消失
    HelloDismissStyleNO,                   // 无动画
    HelloDismissStyleScale,                // 缩放
    HelloDismissStyleSmoothToTop,          // 顶部 平滑淡出动画
    HelloDismissStyleSmoothToLeft,         // 左侧 平滑淡出动画
    HelloDismissStyleSmoothToBottom,       // 底部 平滑淡出动画
    HelloDismissStyleSmoothToRight,        // 右侧 平滑淡出动画
    HelloDismissStyleCardDropToLeft,       // 卡片从中间往左侧掉落
    HelloDismissStyleCardDropToRight,      // 卡片从中间往右侧掉落
    HelloDismissStyleCardDropToTop,        // 卡片从中间往顶部移动消失
};
/** 弹窗位置 */
typedef NS_ENUM(NSInteger, HelloHemStyle) {
    HelloHemStyleCenter = 0,   //居中
    HelloHemStyleTop,          //贴顶
    HelloHemStyleLeft,         //贴左
    HelloHemStyleBottom,       //贴底
    HelloHemStyleRight,        //贴右
    HelloHemStyleTopLeft,      //贴顶和左
    HelloHemStyleBottomLeft,   //贴底和左
    HelloHemStyleBottomRight,  //贴底和右
    HelloHemStyleTopRight      //贴顶和右
};
/** 拖拽方向 */
typedef NS_ENUM(NSInteger, HelloDragStyle) {
    HelloDragStyleNO = 0,  //默认 不能拖拽窗口
    HelloDragStyleX_Positive = 1<<0,   //X轴正方向拖拽
    HelloDragStyleX_Negative = 1<<1,   //X轴负方向拖拽
    HelloDragStyleY_Positive = 1<<2,   //Y轴正方向拖拽
    HelloDragStyleY_Negative = 1<<3,   //Y轴负方向拖拽
    HelloDragStyleX = (HelloDragStyleX_Positive|HelloDragStyleX_Negative),   //X轴方向拖拽
    HelloDragStyleY = (HelloDragStyleY_Positive|HelloDragStyleY_Negative),   //Y轴方向拖拽
    HelloDragStyleAll = (HelloDragStyleX|HelloDragStyleY)   //全向拖拽
};
///** 可轻扫消失的方向 */
typedef NS_ENUM(NSInteger, HelloSweepStyle) {
    HelloSweepStyleNO = 0,  //默认 不能拖拽窗口
    HelloSweepStyleX_Positive = 1<<0,   //X轴正方向拖拽
    HelloSweepStyleX_Negative = 1<<1,   //X轴负方向拖拽
    HelloSweepStyleY_Positive = 1<<2,   //Y轴正方向拖拽
    HelloSweepStyleY_Negative = 1<<3,   //Y轴负方向拖拽
    HelloSweepStyleX = (HelloSweepStyleX_Positive|HelloSweepStyleX_Negative),   //X轴方向拖拽
    HelloSweepStyleY = (HelloSweepStyleY_Positive|HelloSweepStyleY_Negative),   //Y轴方向拖拽
    HelloSweepStyleALL = (HelloSweepStyleX|HelloSweepStyleY)   //全向轻扫
};

/**
   可轻扫消失动画类型 对单向横扫 设置有效
   LSTSweepDismissStyleSmooth: 自动适应选择以下其一
   LSTDismissStyleSmoothToTop,
   LSTDismissStyleSmoothToLeft,
   LSTDismissStyleSmoothToBottom ,
   LSTDismissStyleSmoothToRight
 */
typedef NS_ENUM(NSInteger, HelloSweepDismissStyle) {
    HelloSweepDismissStyleVelocity = 0,  //默认加速度 移除
    HelloSweepDismissStyleSmooth = 1     //平顺移除
};


NS_ASSUME_NONNULL_BEGIN

@protocol HelloPopViewProtocol <NSObject>


/** 点击弹窗 回调 */
- (void)hl_PopViewBgClickForPopView:(HelloPopView *)popView;
/** 长按弹窗 回调 */
- (void)hl_PopViewBgLongPressForPopView:(HelloPopView *)popView;




// ****** 生命周期 ******
/** 将要显示 */
- (void)hl_PopViewWillPopForPopView:(HelloPopView *)popView;
/** 已经显示完毕 */
- (void)hl_PopViewDidPopForPopView:(HelloPopView *)popView;
/** 倒计时进行中 timeInterval:时长  */
- (void)hl_PopViewCountDownForPopView:(HelloPopView *)popView forCountDown:(NSTimeInterval)timeInterval;
/** 倒计时倒计时完成  */
- (void)hl_PopViewCountDownFinishForPopView:(HelloPopView *)popView;
/** 将要开始移除 */
- (void)hl_PopViewWillDismissForPopView:(HelloPopView *)popView;
/** 已经移除完毕 */
- (void)hl_PopViewDidDismissForPopView:(HelloPopView *)popView;
//***********************




@end

NS_ASSUME_NONNULL_END
