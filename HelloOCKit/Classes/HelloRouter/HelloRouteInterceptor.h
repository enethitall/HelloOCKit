

#import <Foundation/Foundation.h>
#import "HelloRouteHandler.h"

typedef enum : NSUInteger {
    HelloRouterInterceptionPolicyCancel,
    HelloRouterInterceptionPolicyAllow,
} HelloRouterInterceptionPolicy;

NS_ASSUME_NONNULL_BEGIN
typedef void(^HelloRouterInterceptionPolicyDecisionHandler)(HelloRouterInterceptionPolicy policy);
typedef void(^HelloRouteInterceptHandler)(HelloRouteRequest *request, HelloRouterInterceptionPolicyDecisionHandler decisionHandler);


@interface HelloRouteInterceptor : NSObject
+ (instancetype)interceptorWithPaths:(NSArray<NSString *> *)paths handler:(HelloRouteInterceptHandler)handler;
- (instancetype)initWithPaths:(NSArray<NSString *> *)paths handler:(HelloRouteInterceptHandler)handler;

+ (instancetype)interceptorWithPath:(NSString *)path handler:(HelloRouteInterceptHandler)handler;
- (instancetype)initWithPath:(NSString *)path handler:(HelloRouteInterceptHandler)handler;

@property (nonatomic, copy, nullable) NSArray<NSString *> *paths;
@property (nonatomic, copy, nullable) HelloRouteInterceptHandler handler;

@end
NS_ASSUME_NONNULL_END
