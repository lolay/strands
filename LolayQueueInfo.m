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

#import "LolayQueueInfo.h"
#import "LolaySelectorOperation.h"

@interface LolayQueueInfo ()

@property (nonatomic, strong, readwrite) NSOperationQueue* queue;
@property (nonatomic, assign, readwrite) NSOperationQueuePriority queuePriority;
@property (nonatomic, assign, readwrite) Float64 threadPriority;

@end

@implementation LolayQueueInfo

@synthesize queue = queue_;
@synthesize queuePriority = queuePriority_;
@synthesize threadPriority = threadPriority_;

#pragma mark -
#pragma mark Lifecycle

- (id) initWithQueue:(NSOperationQueue*) inQueue withQueuePriority:(NSOperationQueuePriority) inQueuePriority withThreadPriority:(Float64) inThreadPriority {
	self = [super init];
	
	if (self) {
		self.queue = inQueue;
		self.queuePriority = inQueuePriority;
		self.threadPriority = inThreadPriority;
	}
	
	return self;
}

- (NSString*) description {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_4_0
	return [NSString stringWithFormat:@"<LolayQueueInfo queue.name=%@, queue.maxConcurrentOperationCount=%i, queuePriority=%i, threadPriority=%f>",
			self.queue.name, self.queue.maxConcurrentOperationCount, self.queuePriority, self.threadPriority];
#else
	return [NSString stringWithFormat:@"<LolayQueueInfo queue.maxConcurrentOperationCount=%i, queuePriority=%i, threadPriority=%f>",
			self.queue.maxConcurrentOperationCount, self.queuePriority, self.threadPriority];
#endif
}

#pragma mark -
#pragma mark Operations

- (void) performOperation:(NSOperation*) operation {
	[self.queue addOperation:operation];
}

#pragma mark -
#pragma mark Selectors

- (void) performSelectorOnTarget:(id) target selector:(SEL) selector {
	NSOperation* operation = [[LolaySelectorOperation alloc] initWithTarget:target withSelector:selector];
	[self performOperation:operation];
}

- (void) performSelectorOnTarget:(id) target selector:(SEL) selector withObject:(id) argument {
	NSOperation* operation = [[LolaySelectorOperation alloc] initWithTarget:target withSelector:selector withObject:argument];
	[self performOperation:operation];
}

- (void) performSelectorOnTarget:(id) target selector:(SEL) selector withObject:(id) argument1 withObject:(id) argument2 {
	NSOperation* operation = [[LolaySelectorOperation alloc] initWithTarget:target withSelector:selector withObject:argument1 withObject:argument2];
	[self performOperation:operation];
}

#pragma mark -
#pragma mark Blocks

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_4_0

- (void) performBlockWithQueuePriority:(NSOperationQueuePriority) inQueuePriority withThreadPriority:(Float64) inThreadPriority block:(void (^)(void)) block {
	if (block) {
		NSBlockOperation* blockOperation = [NSBlockOperation blockOperationWithBlock:[block copy]];
		blockOperation.queuePriority = self.queuePriority;
		blockOperation.threadPriority = self.threadPriority;
		[self performOperation:blockOperation];
	}
}

- (void) performBlockWithQueuePriority:(NSOperationQueuePriority) inQueuePriority block:(void (^)(void)) block {
	[self performBlockWithQueuePriority:inQueuePriority withThreadPriority:self.threadPriority block:block];
}

- (void) performBlockWithThreadPriority:(Float64) inThreadPriority block:(void (^)(void)) block {
	[self performBlockWithQueuePriority:self.queuePriority withThreadPriority:inThreadPriority block:block];
}

- (void) performBlock:(void (^)(void)) block {
	[self performBlockWithQueuePriority:self.queuePriority withThreadPriority:self.threadPriority block:block];
}

#endif

#pragma mark -
#pragma mark Queue Controls

- (void) suspend {
	[self.queue setSuspended:YES];
}

- (void) resume {
	[self.queue setSuspended:NO];
}

- (void) cancelAllOperations {
	[self.queue cancelAllOperations];
}

#pragma mark - Status

- (NSUInteger) operationCount {
    return [self.queue operationCount];
}

@end