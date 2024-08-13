//
//  HelloQueue.m
//  HelloOCKit
//
//  Created by Weiyan  Li  on 2024/8/13.
//

#import "HelloQueue.h"
#include <stdlib.h>

typedef struct HelloItem {
    CFTypeRef _Nullable obj;//CFTypeRef可以表示CoreFoundation的任何对象
    struct HelloItem *_Nullable next;
} HelloItem;

static inline HelloItem *HelloCreateItem(id obj) {
    HelloItem *item = malloc(sizeof(HelloItem));
    item->next = NULL;
    item->obj = CFBridgingRetain(obj);
    return item;
}

static inline void HelloFreeItem(HelloItem *item) {
    if ( item != NULL ) {
        if ( item->obj != NULL ) {
            CFRelease(item->obj);
            item->obj = NULL;
        }
        free(item);
    }
}

@interface HelloQueue ()
@property (nonatomic, nullable) HelloItem *head;
@property (nonatomic, nullable) HelloItem *tail;
@end

@implementation HelloQueue

+ (instancetype)queue {
    return HelloQueue.alloc.init;
}

- (void)dealloc {
    [self empty];
}

- (nullable id)firstObject {
    return _head != nil ? (__bridge id _Nullable)(_head->obj) : nil;
}

- (nullable id)lastObject {
    return _tail != nil ? (__bridge id _Nullable)(_tail->obj) : nil;
}

- (void)enqueue:(id)obj {
    if ( obj != nil ) {
        HelloItem *item = HelloCreateItem(obj);
        if ( __builtin_expect(_head == NULL, 0) ) {
            _head = item;
        }
        else {
            _tail->next = item;
        }
        _tail = item;
        _size += 1;
    }
}

- (nullable id)dequeue {
    HelloItem *_Nullable item = _head;
    if ( item != NULL ) {
        _head = item->next;
        if ( _head == NULL ) {
            _tail = NULL;
        }
        id _Nullable obj = (__bridge id _Nullable)(item->obj);
        HelloFreeItem(item);
        _size -= 1;
        return obj;
    }
    return nil;
}

- (void)empty {
    while ( _head != NULL ) [self dequeue];
}

@end
