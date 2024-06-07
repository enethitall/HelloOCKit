

#import "HelloRouteObject.h"

NS_ASSUME_NONNULL_BEGIN
@interface HelloRouteObject ()
@property (nonatomic, copy, readonly) HelloCreateInstanceBlock createInstanceBlock;
@property (nonatomic, copy, readonly) NSArray<NSString *> *paths;
@end

@implementation HelloRouteObject

///
/// 指定路径, 创建对应的路由处理者
///
/// @param path                     可处理的路径
///
/// @param mode                     决定转场时是调用`pushViewController:`还是`presentViewController:`方法
///
/// @param createInstanceBlock      创建相应的实例对象的block
///
- (nullable instancetype)initWithPath:(NSString *)path transitionMode:(HelloViewControllerTransitionMode)mode createInstanceBlock:(nonnull HelloCreateInstanceBlock)createInstanceBlock {
    if ( path == nil ) return nil;
    return [self initWithPaths:@[path] transitionMode:mode createInstanceBlock:createInstanceBlock transitionAnimated:YES];
}

///
/// 指定路径, 创建对应的路由处理者
///
/// @param paths                    可处理的路径
///
/// @param mode                     决定转场时是调用`pushViewController:`还是`presentViewController:`方法
///
/// @param createInstanceBlock      创建相应的实例对象的block
///
/// @param animated                 转场时, 是否动画
///
- (nullable instancetype)initWithPaths:(NSArray<NSString *> *)paths transitionMode:(HelloViewControllerTransitionMode)mode createInstanceBlock:(HelloCreateInstanceBlock)createInstanceBlock transitionAnimated:(BOOL)animated {
    if ( paths.count == 0 ) return nil;
    self = [super init];
    if ( self ) {
        _paths = paths.copy;
        _mode = mode;
        _createInstanceBlock = createInstanceBlock;
        _animated = animated;
    }
    return self;
}

#pragma mark -

- (void)handleRequest:(HelloRouteRequest *)request topViewController:(UIViewController *)topViewController completionHandler:(nullable HelloCompletionHandler)completionHandler {
    if ( self.createInstanceBlock != nil ) {
        self.createInstanceBlock(request, ^(id  _Nullable result, NSError * _Nullable error) {
            if ( error != nil ) {
                if ( completionHandler ) completionHandler(nil, error);
                return ;
            }
            
            switch ( self.mode ) {
                case HelloViewControllerTransitionModeNavigation: {
                    [topViewController.navigationController pushViewController:result animated:self.animated];
                    if ( completionHandler ) completionHandler(result, nil);
                }
                    break;
                case HelloViewControllerTransitionModeModal: {
                    [topViewController presentViewController:result animated:self.animated completion:nil];
                    if ( completionHandler ) completionHandler(result, nil);
                }
                    break;
            }
        });
    }
}

- (void)instanceWithRequest:(HelloRouteRequest *)request completionHandler:(nullable HelloCompletionHandler)completionHandler {
    if ( _createInstanceBlock != nil ) _createInstanceBlock(request, completionHandler);
}
@end
NS_ASSUME_NONNULL_END
