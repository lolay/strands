//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface LolayQueueInfo : NSObject

- (id) initWithQueue:(NSOperationQueue*) inQueue withQueuePriority:(NSOperationQueuePriority) inQueuePriority withThreadPriority:(Float64) inThreadPriority;

- (void) performOperation:(NSOperation*) operation;

#if __IPHONE_OS_VERSION_MIN_REQUIRED > __IPHONE_3_1
- (void) performBlock:(void (^)(void)) block;
- (void) performBlockWithQueuePriority:(NSOperationQueuePriority) inQueuePriority block:(void (^)(void)) block;
- (void) performBlockWithThreadPriority:(Float64) inThreadPriority block:(void (^)(void)) block;
- (void) performBlockWithQueuePriority:(NSOperationQueuePriority) inQueuePriority withThreadPriority:(Float64) inThreadPriority block:(void (^)(void)) block;
#endif

- (void) performSelectorOnTarget:(id) target selector:(SEL) selector;
- (void) performSelectorOnTarget:(id) target selector:(SEL) selector withObject:(id) argument;
- (void) performSelectorOnTarget:(id) target selector:(SEL) selector withObject:(id) argument1 withObject:(id) argument2;

- (void) performSelectorOnTarget:(id) target selector:(SEL) selector callbackTarget:(id) callbackTarget callbackSelector:(SEL) callbackSelector;
- (void) performSelectorOnTarget:(id) target selector:(SEL) selector withObject:(id) argument callbackTarget:(id) callbackTarget callbackSelector:(SEL) callbackSelector;
- (void) performSelectorOnTarget:(id) target selector:(SEL) selector withObject:(id) argument1 withObject:(id) argument2 callbackTarget:(id) callbackTarget callbackSelector:(SEL) callbackSelector;

- (void) suspend;
- (void) resume;

- (void) cancelAllOperations;

@end