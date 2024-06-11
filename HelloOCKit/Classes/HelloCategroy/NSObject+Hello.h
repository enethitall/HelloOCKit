//
//  NSObject+Hello.h
//  HelloOCKit
//
//  Created by Weiyan  Li  on 2024/6/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Hello)

@property (nonatomic, strong, class, readonly) NSArray<NSString *> *csj_invarList;
@property (nonatomic, strong, class, readonly) NSArray<NSString *> *csj_methodList;
@property (nonatomic, strong, class, readonly) NSArray<NSString *> *csj_propertyList;
@property (nonatomic, strong, class, readonly) NSArray<NSString *> *csj_protocolList;
@property (nonatomic, strong, class, readonly) NSArray<NSString *> *csj_invarTypeList;

@end

NS_ASSUME_NONNULL_END
