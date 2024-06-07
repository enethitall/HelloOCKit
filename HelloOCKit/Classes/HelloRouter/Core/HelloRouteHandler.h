

#import "HelloRouteRequest.h"
@class UIViewController, HelloRouter;

NS_ASSUME_NONNULL_BEGIN
typedef void(^HelloCompletionHandler)(id _Nullable result, NSError *_Nullable error);
typedef void(^HelloRouterUnhandledCallback)(HelloRouteRequest *request, UIViewController *topViewController, HelloCompletionHandler _Nullable completionHandler);
typedef void(^HelloRouterUnableToGetAnInstanceCallback)(HelloRouteRequest *request, HelloCompletionHandler _Nullable completionHandler);

@protocol HelloRouteHandler
@optional
///
/// 添加路由
///     第一步 遵守协议: <SJRouteHandler>
///     第二步 实现协议方法:`addRoutesToRouter:`, SJRouter 将在初始化期间调用它
///
+ (void)addRoutesToRouter:(HelloRouter *)router;

#pragma mark - 以下为第二种添加路由的方式

+ (NSArray<NSString *> *)multiRoutePath; // 多路径 可以从这个方法返回
+ (NSString *)routePath;                 // 单路径 可以用这个方法返回

///
/// 处理某个请求
///
///     当调用SJRouter的`-handleRequest:completionHandler:`时, SJRouter将通过对应的`handler`调用到此方法
///
+ (void)handleRequest:(HelloRouteRequest *)request topViewController:(UIViewController *)topViewController completionHandler:(nullable HelloCompletionHandler)completionHandler;

///
/// 获取某个实例
///
///     当调用SJRouter的`-instanceWithRequest:completionHandler:`时, SJRouter将通过对应的`handler`调用到此方法
///
+ (void)instanceWithRequest:(HelloRouteRequest *)request completionHandler:(nullable HelloCompletionHandler)completionHandler;
@end
NS_ASSUME_NONNULL_END


#endif /* SJRouteHandler_h */
