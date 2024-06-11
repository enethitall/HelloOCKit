

#import "HelloRouter.h"
#import <objc/message.h>
#import "HelloRouteObject+Private.h"

NS_ASSUME_NONNULL_BEGIN
static UIViewController *hello_get_top_view_controller(void) {
    UIViewController *vc = UIApplication.sharedApplication.keyWindow.rootViewController;
    while (  [vc isKindOfClass:[UINavigationController class]] ||
             [vc isKindOfClass:[UITabBarController class]] ||
              vc.presentedViewController ) {
        if ( [vc isKindOfClass:[UINavigationController class]] )
            vc = [(UINavigationController *)vc topViewController];
        if ( [vc isKindOfClass:[UITabBarController class]] )
            vc = [(UITabBarController *)vc selectedViewController];
        if ( vc.presentedViewController )
            vc = vc.presentedViewController;
    }
    return vc;
}

@interface HelloRouter()
@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, id<HelloRouteHandler>> *handlersM;
@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, HelloRouteInterceptor *> *interceptors;
@end

@implementation HelloRouter
static SEL sel_handler_v2;
static SEL sel_instance;

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sel_handler_v2 = @selector(handleRequest:topViewController:completionHandler:);
        sel_instance = @selector(instanceWithRequest:completionHandler:);
    });
}

+ (instancetype)shared {
    static id _instace;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [[self alloc] init];
    });
    return _instace;
}

- (instancetype)init {
    self = [super init];
    if ( !self ) return nil;
    _handlersM = [NSMutableDictionary new];
    _interceptors = [NSMutableDictionary new];
    
    /// https://www.jianshu.com/p/534eccb63974
    /// https://github.com/changsanjiang/SJRouter/pull/1
    /// objc_copyImageNames(获取所 有objc的框架和动态库)
    /// objc_copyClassNamesForImage(获取指定库或框架中的所有类 的名称)
    unsigned int img_count = 0;
    const char **imgs = objc_copyImageNames(&img_count);
    const char *main = NSBundle.mainBundle.bundlePath.UTF8String;
    SEL sel_path = @selector(routePath);
    SEL sel_multiPath = @selector(multiRoutePath);
    SEL sel_add_route = @selector(addRoutesToRouter:);
    Protocol *protocol = @protocol(HelloRouteHandler);
    for ( unsigned int i = 0 ; i < img_count ; ++ i ) {
        const char *image = imgs[i];
        if ( !strstr(image, main) ) continue;
        unsigned int cls_count = 0;
        const char **names = objc_copyClassNamesForImage(image, &cls_count);
        for ( unsigned int i = 0 ; i < cls_count ; ++ i ) {
            const char *cls_name = names[i];
            Class _Nullable cls = objc_getClass(cls_name);
            Class _Nullable supercls = cls;
            while ( supercls && !class_conformsToProtocol(supercls, protocol) )
                supercls = class_getSuperclass(supercls);
            if ( !supercls ) continue;
            
            Class metaClass = (Class)object_getClass(cls);
            if ( class_respondsToSelector(metaClass, sel_path) ) {
                IMP func = class_getMethodImplementation(metaClass, sel_path);
                NSString *routePath = ((NSString *(*)(id, SEL))func)(cls, sel_path);
                if ( routePath.length > 0 ) {
                    self->_handlersM[routePath] = (id)cls;
                }
            }
            else if ( class_respondsToSelector(metaClass, sel_multiPath) ) {
                IMP func = class_getMethodImplementation(metaClass, sel_multiPath);
                for ( NSString *routePath in ((NSArray<NSString *> *(*)(id, SEL))func)(cls, sel_multiPath) ) {
                    if ( routePath.length > 0 ) {
                        self->_handlersM[routePath] = (id)cls;
                    }
                }
            }
            if ( class_respondsToSelector(metaClass, sel_add_route) ) {
                IMP func = class_getMethodImplementation(metaClass, sel_add_route);
                ((void(*)(id, SEL, HelloRouter *))func)(cls, sel_add_route, self);
            }
        }
        if ( names ) free(names);
    }
    if ( imgs ) free(imgs);
    return self;
}

- (void)instanceWithRequest:(HelloRouteRequest *)request completionHandler:(nullable HelloCompletionHandler)completionHandler {
    if ( request == nil ) return;
    HelloRouteInterceptor *interceptor = [self _interceptorForRoutePath:request.requestPath];
    if ( interceptor != nil ) {
        interceptor.handler(request, ^(HelloRouterInterceptionPolicy policy) {
            if ( policy == HelloRouterInterceptionPolicyAllow ) {
                [self _instanceWithRequest:request completionHandler:completionHandler];
            }
        });
    }
    else {
        [self _instanceWithRequest:request completionHandler:completionHandler];
    }
}

- (void)handleRequest:(HelloRouteRequest *)request completionHandler:(nullable HelloCompletionHandler)completionHandler {
    if ( request == nil ) return;
    HelloRouteInterceptor *interceptor = [self _interceptorForRoutePath:request.requestPath];
    if ( interceptor != nil ) {
        interceptor.handler(request, ^(HelloRouterInterceptionPolicy policy) {
            if ( policy == HelloRouterInterceptionPolicyAllow ) {
                [self _handleRequest:request completionHandler:completionHandler];
            }
        });
    }
    else {
        [self _handleRequest:request completionHandler:completionHandler];
    }
}

///
/// 是否可以处理某个路径
///
- (BOOL)canHandleRoutePath:(NSString *)routePath {
    return [self _handlerForRoutePath:routePath] != nil;
}

///
/// 手动添加路由
///
///     注意: 为保证线程安全应该总是在`+addRoutesToRouter:`中调用该方法
///
- (void)addRoute:(HelloRouteObject *)object {
    if ( object != nil ) {
        for ( NSString *path in object.paths ) {
            _handlersM[path] = (id)object;
        }
    }
}

///
/// 添加拦截器
///
///     注意: 每个`routePath`只能创建单个拦截器. 重复设置, 会被替换.
///
///     注意: 为保证线程安全应该总是在`+addRoutesToRouter:`中调用该方法
///
- (void)addInterceptor:(HelloRouteInterceptor *)interceptor {
    if ( interceptor != nil ) {
        for ( NSString *path in interceptor.paths ) {
#ifdef DEBUG
            __auto_type oldValue = self.interceptors[path];
            if ( oldValue != nil ) {
                printf("\n(-_-) The interceptor was replaced: \"%s\" => ([%p] to [%p])\n", path.UTF8String, oldValue, interceptor);
            }
#endif
            self.interceptors[path] = interceptor;
        }
    }
}

#pragma mark -

- (nullable id)_handlerForRoutePath:(NSString *)path {
    id handler = nil;
    if ( path.length != 0 ) {
        handler = _handlersM[path];
    }
    return handler;
}

- (HelloRouteInterceptor *)_interceptorForRoutePath:(NSString *)path {
    id interceptor = nil;
    if ( path.length != 0 ) {
        interceptor = _interceptors[path];
    }
    return interceptor;
}

- (void)_instanceWithRequest:(HelloRouteRequest *)request completionHandler:(nullable HelloCompletionHandler)completionHandler {
    id _Nullable handler = [self _handlerForRoutePath:request.requestPath];
    if ( [handler respondsToSelector:sel_instance] ) {
        [handler instanceWithRequest:request completionHandler:completionHandler];
    }
    else {
#ifdef DEBUG
        printf("\n(-_-) unable to get an instance: [%s]\n", request.description.UTF8String);
#endif
        if ( self->_unableToGetAnInstanceCallback ) self->_unableToGetAnInstanceCallback(request, completionHandler);
    }
}

- (void)_handleRequest:(HelloRouteRequest *)request completionHandler:(nullable HelloCompletionHandler)completionHandler {
    if ( request == nil ) return;
    id _Nullable handler = [self _handlerForRoutePath:request.requestPath];
    if      ( [handler respondsToSelector:sel_handler_v2] ) {
        [handler handleRequest:request topViewController:hello_get_top_view_controller() completionHandler:completionHandler];
    }
    else {
#ifdef DEBUG
        printf("\n(-_-) Unhandled request: [%s]\n", request.description.UTF8String);
#endif
        if ( self->_unhandledCallback ) self->_unhandledCallback(request, hello_get_top_view_controller(), completionHandler);
    }
}
@end
NS_ASSUME_NONNULL_END
