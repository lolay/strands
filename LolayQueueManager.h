//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//
#import <Foundation/Foundation.h>

#define LolayQueueManagerMainQueue @"main"

@interface LolayQueueManager : NSObject

- (id) initWithPropertyList:(NSString*) pathForResource;

- (void) performBlockOnQueue:(NSString*) queueName block:(void (^)(void)) block;
- (void) performBlockOnQueue:(NSString*) queueName withQueuePriority:(NSOperationQueuePriority) queuePriority block:(void (^)(void)) block;
- (void) performBlockOnQueue:(NSString*) queueName withThreadPriority:(Float32) threadPriority block:(void (^)(void)) block;
- (void) performBlockOnQueue:(NSString*) queueName withQueuePriority:(NSOperationQueuePriority) queuePriority withThreadPriority:(Float32) threadPriority block:(void (^)(void)) block;

- (void) suspendQueue:(NSString*) queueName;
- (void) resumeQueue:(NSString*) queueName;

- (void) cancelAllOperationsOnQueue:(NSString*) queueName;

@end