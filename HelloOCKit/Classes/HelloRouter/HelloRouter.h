
//  感谢 @畅三江 changsanjiang@gmail.com
//  源码：https://github.com/changsanjiang/SJRouter

#import <Foundation/Foundation.h>
#import "HelloRouteHandler.h"
#import "HelloRouteObject.h"
#import "HelloRouteInterceptor.h"
@class UIViewController;

NS_ASSUME_NONNULL_BEGIN
@interface HelloRouter : NSObject
+ (instancetype)shared;

/// `-instanceWithRequest:completionHandler:`无对应handler时, 将会回调该block
@property (nonatomic, copy, nullable) HelloRouterUnableToGetAnInstanceCallback unableToGetAnInstanceCallback;
- (void)instanceWithRequest:(HelloRouteRequest *)request completionHandler:(nullable HelloCompletionHandler)completionHandler;

/// `-handleRequest:completionHandler:`无对应handler时, 将会回调该block
@property (nonatomic, copy, nullable) HelloRouterUnhandledCallback unhandledCallback;
- (void)handleRequest:(HelloRouteRequest *)request completionHandler:(nullable HelloCompletionHandler)completionHandler;

- (BOOL)canHandleRoutePath:(NSString *)routePath; 

- (void)addRoute:(HelloRouteObject *)object;
@end


@interface HelloRouter (HelloRouteInterceptorExtended)

- (void)addInterceptor:(HelloRouteInterceptor *)interceptor;

@end
NS_ASSUME_NONNULL_END
