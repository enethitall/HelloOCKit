//
//  UIWindow+Touch.m
//  LevcRpaCarlinxSDKDemo
//
//  Created by Weiyan  Li  on 2024/3/29.
//

#import "UIWindow+Touch.h"
#import <objc/runtime.h>
static const void*showTapTraceKey = &showTapTraceKey;
@implementation UIWindow (Touch)

//-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
//    NSLog(@"hitTest----------------UIWindow");
//    return [super hitTest:point withEvent:event];
//}
//
//-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
//    NSLog(@"pointInside------------UIWindow");
//    return YES;
//}

-(void)setShowTapTrace:(BOOL)showTapTrace{
    objc_setAssociatedObject(self, showTapTraceKey, @(showTapTrace), OBJC_ASSOCIATION_ASSIGN);
}

-(BOOL)showTapTrace{
    NSNumber *obj = objc_getAssociatedObject(self, showTapTraceKey);
    return obj.boolValue;
}

+ (void)load
{ 
    // 交换方法
    Method m1 = class_getInstanceMethod([self class], @selector(sendEvent:));
    Method m2 = class_getInstanceMethod([self class], @selector(hello_sendEvent:));
    method_exchangeImplementations(m1, m2);
}

- (void)hello_sendEvent:(UIEvent *)event
{
    [self hello_sendEvent:event];
    // 对点击事件进行处理
    if(self.showTapTrace){
        [self dealTouch:event];
    }
}

- (void)dealTouch:(UIEvent *)event
{
    UITouch *touch = event.allTouches.anyObject;
    if (touch.phase == UITouchPhaseEnded) {
        return;
    }
    
    static CGFloat width = 30;
    if (event.type == UIEventTypeTouches) {
        
        CGPoint point = [event.allTouches.anyObject locationInView:self];
        
        CGFloat oringX = point.x - width / 2;
        CGFloat oringY = point.y - width / 2;
        CGRect rect = CGRectMake(oringX, oringY, width, width);
        UIView *blackV = [[UIView alloc] initWithFrame:rect];
        blackV.alpha = 0.3;
        blackV.layer.cornerRadius = width / 2;
        blackV.backgroundColor = [UIColor purpleColor];
        [self addSubview:blackV];
        [self bringSubviewToFront:blackV];
        // 设置动画
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        animation.duration = 0.3;
        animation.fromValue = @1;
        animation.toValue = @2;
        animation.fillMode = @"backwards";
        animation.removedOnCompletion = YES;
        [blackV.layer addAnimation:animation forKey:@"an1"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.27 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [blackV removeFromSuperview];
        });
    }
}

@end
