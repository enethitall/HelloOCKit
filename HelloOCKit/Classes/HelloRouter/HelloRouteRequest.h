

#import <Foundation/Foundation.h>
typedef id HelloParameters;

NS_ASSUME_NONNULL_BEGIN
@interface HelloRouteRequest : NSObject
- (nullable instancetype)initWithPath:(NSString *)requestPath parameters:(nullable HelloParameters)parameters;
@property (nonatomic, strong, readonly, nullable) NSString *requestPath;
@property (nonatomic, strong, readonly, nullable) HelloParameters prts; // 请求的参数
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new  NS_UNAVAILABLE;
@end


@interface HelloRouteRequest(CreateByURL)
- (nullable instancetype)initWithURL:(NSURL *)URL;
@property (nonatomic, strong, readonly, nullable) NSURL *originalURL;

/// 追加参数
- (void)setValue:(nullable id)value forParameterKey:(NSString *)key;
- (void)addParameters:(NSDictionary *)parameters;
@end
NS_ASSUME_NONNULL_END
