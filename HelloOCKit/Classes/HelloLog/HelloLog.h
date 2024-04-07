//
//  HelloLog.h
//  AFNetworking
//
//  Created by Weiyan  Li  on 2023/10/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HelloLog : NSObject

+ (instancetype)sharedInstance;
///开启
- (void)enable:(void(^)(void))touchUpInsideEvent;
///关闭
- (void)close;

@end

NS_ASSUME_NONNULL_END
