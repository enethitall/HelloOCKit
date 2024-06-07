

#import "HelloRouteInterceptor.h"

@implementation HelloRouteInterceptor
+ (instancetype)interceptorWithPaths:(NSArray<NSString *> *)paths handler:(HelloRouteInterceptHandler)handler {
    return [HelloRouteInterceptor.alloc initWithPaths:paths handler:handler];
}
- (instancetype)initWithPaths:(NSArray<NSString *> *)paths handler:(HelloRouteInterceptHandler)handler {
    self = [super init];
    if ( self ) {
        _paths = paths;
        _handler = handler;
    }
    return self;
}

+ (instancetype)interceptorWithPath:(NSString *)path handler:(HelloRouteInterceptHandler)handler {
    return [HelloRouteInterceptor.alloc initWithPath:path handler:handler];
}
- (instancetype)initWithPath:(NSString *)path handler:(HelloRouteInterceptHandler)handler {
    return [self initWithPaths:@[path ?: @""] handler:handler];
}
@end
