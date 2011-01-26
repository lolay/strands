//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//
#import "LolayQueueInfo.h"

@interface LolayQueueInfo ()

@property (nonatomic, retain, readwrite) NSOperationQueue* queue;
@property (nonatomic, assign, readwrite) NSOperationQueuePriority queuePriority;
@property (nonatomic, assign, readwrite) Float64 threadPriority;

@end

@implementation LolayQueueInfo

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

- (void) dealloc {
	self.queue = nil;
	
	[super dealloc];
}

- (NSString*) description {
	return [NSString stringWithFormat:@"<LolayQueueInfo queue.name=%@, queue.maxConcurrentOperationCount=%i, queuePriority=%i, threadPriority=%f>",
			self.queue.name, self.queue.maxConcurrentOperationCount, self.queuePriority, self.threadPriority];
}

#pragma mark -
#pragma mark Blocks

- (void) performBlockWithQueuePriority:(NSOperationQueuePriority) inQueuePriority withThreadPriority:(Float64) inThreadPriority block:(void (^)(void)) block {
	if (block) {
		NSBlockOperation* blockOperation = [NSBlockOperation blockOperationWithBlock:[[block copy] autorelease]];
		blockOperation.queuePriority = self.queuePriority;
		blockOperation.threadPriority = self.threadPriority;
		[self.queue addOperation:blockOperation];
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

@end