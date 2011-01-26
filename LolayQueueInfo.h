//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface LolayQueueInfo : NSObject

- (id) initWithQueue:(NSOperationQueue*) inQueue withQueuePriority:(NSOperationQueuePriority) inQueuePriority withThreadPriority:(Float64) inThreadPriority;

- (void) performBlock:(void (^)(void)) block;
- (void) performBlockWithQueuePriority:(NSOperationQueuePriority) inQueuePriority block:(void (^)(void)) block;
- (void) performBlockWithThreadPriority:(Float64) inThreadPriority block:(void (^)(void)) block;
- (void) performBlockWithQueuePriority:(NSOperationQueuePriority) inQueuePriority withThreadPriority:(Float64) inThreadPriority block:(void (^)(void)) block;

- (void) suspend;
- (void) resume;

- (void) cancelAllOperations;

@end