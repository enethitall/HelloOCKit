

#import "HelloRouteObject.h"

NS_ASSUME_NONNULL_BEGIN
@interface HelloRouteObject (Private)
@property (nonatomic, copy, readonly) NSArray<NSString *> *paths;
- (void)handleRequest:(HelloRouteRequest *)request topViewController:(UIViewController *)topViewController completionHandler:(nullable HelloCompletionHandler)completionHandler;
- (void)instanceWithRequest:(HelloRouteRequest *)request completionHandler:(nullable HelloCompletionHandler)completionHandler;
@end
NS_ASSUME_NONNULL_END
