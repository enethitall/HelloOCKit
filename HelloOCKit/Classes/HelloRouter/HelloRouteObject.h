

#import <Foundation/Foundation.h>
#import "HelloRouteHandler.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^HelloCreateInstanceBlock)(HelloRouteRequest *request, HelloCompletionHandler _Nullable completionHandler);
typedef enum : NSUInteger {
    /// push
    HelloViewControllerTransitionModeNavigation,
    /// present
    HelloViewControllerTransitionModeModal,
} HelloViewControllerTransitionMode;

@interface HelloRouteObject : NSObject
- (nullable instancetype)initWithPath:(NSString *)path transitionMode:(HelloViewControllerTransitionMode)mode createInstanceBlock:(nonnull HelloCreateInstanceBlock)createInstanceBlock;
- (nullable instancetype)initWithPaths:(NSArray<NSString *> *)paths transitionMode:(HelloViewControllerTransitionMode)mode createInstanceBlock:(HelloCreateInstanceBlock)createInstanceBlock transitionAnimated:(BOOL)animated;

@property (nonatomic) HelloViewControllerTransitionMode mode;
@property (nonatomic) BOOL animated; // transitionAnimated
@end
NS_ASSUME_NONNULL_END
