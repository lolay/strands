//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//
#import "LolayQueueInfo.h"
#import "LolaySelectorOperation.h"

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
#pragma mark Operations

- (void) performOperation:(NSOperation*) operation {
	[self.queue addOperation:operation];
}

#pragma mark -
#pragma mark Selectors

- (void) performSelectorOnTarget:(id) target selector:(SEL) selector {
	NSOperation* operation = [[LolaySelectorOperation alloc] initWithTarget:target withSelector:selector];
	[self performOperation:operation];
	[operation release];
}

- (void) performSelectorOnTarget:(id) target selector:(SEL) selector withObject:(id) argument {
	NSOperation* operation = [[LolaySelectorOperation alloc] initWithTarget:target withSelector:selector withObject:argument];
	[self performOperation:operation];
	[operation release];
}

- (void) performSelectorOnTarget:(id) target selector:(SEL) selector withObject:(id) argument1 withObject:(id) argument2 {
	NSOperation* operation = [[LolaySelectorOperation alloc] initWithTarget:target withSelector:selector withObject:argument1 withObject:argument2];
	[self performOperation:operation];
	[operation release];
}

- (void) performSelectorOnTarget:(id) target selector:(SEL) selector callbackTarget:(id) callbackTarget callbackSelector:(SEL) callbackSelector {
	NSOperation* operation = [[LolaySelectorOperation alloc] initWithTarget:target withSelector:selector withCallbackTarget:callbackTarget withCallbackSelector:callbackSelector];
	[self performOperation:operation];
	[operation release];
}

- (void) performSelectorOnTarget:(id) target selector:(SEL) selector withObject:(id) argument callbackTarget:(id) callbackTarget callbackSelector:(SEL) callbackSelector {
	NSOperation* operation = [[LolaySelectorOperation alloc] initWithTarget:target withSelector:selector withObject:argument withCallbackTarget:callbackTarget withCallbackSelector:callbackSelector];
	[self performOperation:operation];
	[operation release];
}

- (void) performSelectorOnTarget:(id) target selector:(SEL) selector withObject:(id) argument1 withObject:(id) argument2 callbackTarget:(id) callbackTarget callbackSelector:(SEL) callbackSelector {
	NSOperation* operation = [[LolaySelectorOperation alloc] initWithTarget:target withSelector:selector withObject:argument1 withObject:argument2 withCallbackTarget:callbackTarget withCallbackSelector:callbackSelector];
	[self performOperation:operation];
	[operation release];
}

#pragma mark -
#pragma mark Blocks

- (void) performBlockWithQueuePriority:(NSOperationQueuePriority) inQueuePriority withThreadPriority:(Float64) inThreadPriority block:(void (^)(void)) block {
	if (block) {
		NSBlockOperation* blockOperation = [NSBlockOperation blockOperationWithBlock:[[block copy] autorelease]];
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