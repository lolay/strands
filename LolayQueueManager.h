//
//  Copyright 2012 Lolay, Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import <Foundation/Foundation.h>

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_4_0
#define LolayQueueManagerMainQueue @"LolayQueueManagerMainQueue"
#endif

@interface LolayQueueManager : NSObject

- (id)initWithPropertyList:(NSString *)pathForResource inBundle:(NSBundle *)bundle;

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