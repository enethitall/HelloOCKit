//
//  HelloQueue.h
//  HelloOCKit
//
//  Created by Weiyan  Li  on 2024/8/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HelloQueue<__covariant ObjectType>: NSObject

+ (instancetype)queue;

@property (nonatomic, readonly) NSInteger size;

@property (nonatomic, strong, readonly, nullable) ObjectType firstObject;
@property (nonatomic, strong, readonly, nullable) ObjectType lastObject;

- (void)enqueue:(ObjectType)obj;
- (nullable ObjectType)dequeue;
- (void)empty;

@end

NS_ASSUME_NONNULL_END
