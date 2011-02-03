//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//
#import "LolayQueueManager.h"
#import "LolayQueueInfo.h"

@interface LolayQueueManager ()

@property (nonatomic, retain, readwrite) NSMutableDictionary* queues; // LolayQueueInfo by queue name

@end

@implementation LolayQueueManager

#pragma mark -
#pragma mark Lifecycle

- (id) initWithPropertyList:(NSString*) pathForResource {
	NSLog(@"[LolayQueueManager initWithPropertyList] enter");
	self = [super init];
	
	if (self) {
		NSString* filePath = [[[NSBundle mainBundle] pathForResource:pathForResource ofType:@"plist"] retain];
		NSArray* configQueues = [[NSArray arrayWithContentsOfFile:filePath] retain];
		[filePath release];
		
		self.queues = [NSMutableDictionary dictionaryWithCapacity:configQueues.count];
		
		Float64 defaultThreadPriority = 0.5; //[[NSBlockOperation blockOperationWithBlock:NULL] threadPriority];
#if __IPHONE_OS_VERSION_MIN_REQUIRED > __IPHONE_3_1
		NSOperationQueue* mainQueue = [[NSOperationQueue mainQueue] retain];
		LolayQueueInfo* mainQueueInfo = [[LolayQueueInfo alloc] initWithQueue:mainQueue withQueuePriority:NSOperationQueuePriorityNormal withThreadPriority:defaultThreadPriority];
		[self.queues setObject:mainQueueInfo forKey:@"main"];
		[mainQueueInfo release];
		[mainQueue release];
#endif		
		for (NSDictionary* configQueue in configQueues) {
			NSString* name = [[configQueue objectForKey:@"name"] retain];
			NSNumber* maxConcurrentOperationCount = [[configQueue objectForKey:@"maxConcurrentOperationCount"] retain];
			NSNumber* queuePriority = [[configQueue objectForKey:@"queuePriority"] retain];
			NSNumber* threadPriority = [[configQueue objectForKey:@"threadPriority"] retain];

			if (name) {
				NSOperationQueue* queue = [NSOperationQueue new];
#if __IPHONE_OS_VERSION_MIN_REQUIRED > __IPHONE_3_1
				queue.name = name;
#endif		
				if (maxConcurrentOperationCount) {
					queue.maxConcurrentOperationCount = [maxConcurrentOperationCount integerValue];
				}
				
				LolayQueueInfo* queueInfo = [[LolayQueueInfo alloc] initWithQueue:queue
																withQueuePriority:queuePriority ? [queuePriority integerValue] : NSOperationQueuePriorityNormal
															   withThreadPriority:threadPriority ? [threadPriority doubleValue] : defaultThreadPriority];
			
				[self.queues setObject:queueInfo forKey:name];
				
				NSLog(@"[LolayQueueManager initWithPropertyList] loaded queue=%@", queueInfo);
				
				[queue release];
				[queueInfo release];
			}
			
			[name release];
			[maxConcurrentOperationCount release];
			[queuePriority release];
			[threadPriority release];
		}
		
		[configQueues release];
	}
	
	return self;
}

- (void) dealloc {
	self.queues = nil;
	
	[super dealloc];
}

#pragma mark -
#pragma mark Operations

- (void) performOperationOnQueue:(NSString*) queueName operation:(NSOperation*) operation {
	LolayQueueInfo* queue = [[queues objectForKey:queueName] retain];
	[queue performOperation:operation];
	[queue release];
}

#pragma mark -
#pragma mark Selectors

- (void) performSelectorOnQueue:(NSString*) queueName target:(id) target selector:(SEL) selector {
	LolayQueueInfo* queue = [[queues objectForKey:queueName] retain];
	[queue performSelectorOnTarget:target selector:selector];
	[queue release];
}

- (void) performSelectorOnQueue:(NSString*) queueName target:(id) target selector:(SEL) selector withObject:(id) argument {
	LolayQueueInfo* queue = [[queues objectForKey:queueName] retain];
	[queue performSelectorOnTarget:target selector:selector withObject:argument];
	[queue release];
}

- (void) performSelectorOnQueue:(NSString*) queueName target:(id) target selector:(SEL) selector withObject:(id) argument1 withObject:(id) argument2 {
	LolayQueueInfo* queue = [[queues objectForKey:queueName] retain];
	[queue performSelectorOnTarget:target selector:selector withObject:argument1 withObject:argument2];
	[queue release];
}

- (void) performSelectorOnQueue:(NSString*) queueName target:(id) target selector:(SEL) selector callbackTarget:(id) callbackTarget callbackSelector:(SEL) callbackSelector {
	LolayQueueInfo* queue = [[queues objectForKey:queueName] retain];
	[queue performSelectorOnTarget:target selector:selector callbackTarget:callbackTarget callbackSelector:callbackSelector];
	[queue release];
}

- (void) performSelectorOnQueue:(NSString*) queueName target:(id) target selector:(SEL) selector withObject:(id) argument callbackTarget:(id) callbackTarget callbackSelector:(SEL) callbackSelector {
	LolayQueueInfo* queue = [[queues objectForKey:queueName] retain];
	[queue performSelectorOnTarget:target selector:selector withObject:argument callbackTarget:callbackTarget callbackSelector:callbackSelector];
	[queue release];
}

- (void) performSelectorOnQueue:(NSString*) queueName target:(id) target selector:(SEL) selector withObject:(id) argument1 withObject:(id) argument2 callbackTarget:(id) callbackTarget callbackSelector:(SEL) callbackSelector {
	LolayQueueInfo* queue = [[queues objectForKey:queueName] retain];
	[queue performSelectorOnTarget:target selector:selector withObject:argument1 withObject:argument2 callbackTarget:callbackTarget callbackSelector:callbackSelector];
	[queue release];
}

#pragma mark -
#pragma mark Blocks

#if __IPHONE_OS_VERSION_MIN_REQUIRED > __IPHONE_3_1

- (void) performBlockOnQueue:(NSString*) queueName block:(void (^)(void)) block {
	LolayQueueInfo* queue = [[queues objectForKey:queueName] retain];
	[queue performBlock:block];
	[queue release];
}

- (void) performBlockOnQueue:(NSString*) queueName withQueuePriority:(NSOperationQueuePriority) queuePriority block:(void (^)(void)) block {
	LolayQueueInfo* queue = [[queues objectForKey:queueName] retain];
	[queue performBlockWithQueuePriority:queuePriority block:block];
	[queue release];
}

- (void) performBlockOnQueue:(NSString*) queueName withThreadPriority:(float) threadPriority block:(void (^)(void)) block {
	LolayQueueInfo* queue = [[queues objectForKey:queueName] retain];
	[queue performBlockWithThreadPriority:threadPriority block:block];
	[queue release];
}

- (void) performBlockOnQueue:(NSString*) queueName withQueuePriority:(NSOperationQueuePriority) queuePriority withThreadPriority:(float) threadPriority block:(void (^)(void)) block {
	LolayQueueInfo* queue = [[queues objectForKey:queueName] retain];
	[queue performBlockWithQueuePriority:queuePriority withThreadPriority:threadPriority block:block];
	[queue release];
}

#endif

#pragma mark -
#pragma mark Queue Controls

- (void) suspendQueue:(NSString*) queueName {
	LolayQueueInfo* queue = [[queues objectForKey:queueName] retain];
	[queue suspend];
	[queue release];
}

- (void) resumeQueue:(NSString*) queueName {
	LolayQueueInfo* queue = [[queues objectForKey:queueName] retain];
	[queue resume];
	[queue release];
}

- (void) cancelAllOperationsOnQueue:(NSString*) queueName {
	LolayQueueInfo* queue = [[queues objectForKey:queueName] retain];
	[queue cancelAllOperations];
	[queue release];
}

@end