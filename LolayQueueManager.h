//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//
#import <Foundation/Foundation.h>

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_4_0
#define LolayQueueManagerMainQueue @"main"
#endif

@interface LolayQueueManager : NSObject

- (id) initWithPropertyList:(NSString*) pathForResource;

- (void) performOperationOnQueue:(NSString*) queueName operation:(NSOperation*) operation;

- (void) performSelectorOnQueue:(NSString*) queueName target:(id) target selector:(SEL) selector;
- (void) performSelectorOnQueue:(NSString*) queueName target:(id) target selector:(SEL) selector withObject:(id) argument;
- (void) performSelectorOnQueue:(NSString*) queueName target:(id) target selector:(SEL) selector withObject:(id) argument1 withObject:(id) argument2;

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_4_0
- (void) performBlockOnQueue:(NSString*) queueName block:(void (^)(void)) block;
- (void) performBlockOnQueue:(NSString*) queueName withQueuePriority:(NSOperationQueuePriority) queuePriority block:(void (^)(void)) block;
- (void) performBlockOnQueue:(NSString*) queueName withThreadPriority:(Float32) threadPriority block:(void (^)(void)) block;
- (void) performBlockOnQueue:(NSString*) queueName withQueuePriority:(NSOperationQueuePriority) queuePriority withThreadPriority:(Float32) threadPriority block:(void (^)(void)) block;
#endif

- (void) suspendQueue:(NSString*) queueName;
- (void) resumeQueue:(NSString*) queueName;

- (void) cancelAllOperationsOnQueue:(NSString*) queueName;

- (NSArray*) activeQueues;

@end