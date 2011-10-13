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

@synthesize queues = queues_;

#pragma mark -
#pragma mark Lifecycle

- (id) initWithPropertyList:(NSString*) pathForResource {
	DLog(@"enter");
	self = [super init];
	
	if (self) {
		NSString* filePath = [[NSBundle mainBundle] pathForResource:pathForResource ofType:@"plist"];
		NSArray* configQueues = [NSArray arrayWithContentsOfFile:filePath];
		
		self.queues = [NSMutableDictionary dictionaryWithCapacity:configQueues.count];
		
		Float64 defaultThreadPriority = 0.5; //[[NSBlockOperation blockOperationWithBlock:NULL] threadPriority];
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_4_0
		NSOperationQueue* mainQueue = [NSOperationQueue mainQueue];
		LolayQueueInfo* mainQueueInfo = [[LolayQueueInfo alloc] initWithQueue:mainQueue withQueuePriority:NSOperationQueuePriorityNormal withThreadPriority:defaultThreadPriority];
		[self.queues setObject:mainQueueInfo forKey:@"main"];
#endif		
		for (NSDictionary* configQueue in configQueues) {
			NSString* name = [configQueue objectForKey:@"name"];
			NSNumber* maxConcurrentOperationCount = [configQueue objectForKey:@"maxConcurrentOperationCount"];
			NSNumber* queuePriority = [configQueue objectForKey:@"queuePriority"];
			NSNumber* threadPriority = [configQueue objectForKey:@"threadPriority"];

			if (name) {
				NSOperationQueue* queue = [NSOperationQueue new];
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_4_0
				queue.name = name;
#endif		
				if (maxConcurrentOperationCount) {
					queue.maxConcurrentOperationCount = [maxConcurrentOperationCount integerValue];
				}
				
				LolayQueueInfo* queueInfo = [[LolayQueueInfo alloc] initWithQueue:queue
																withQueuePriority:queuePriority ? [queuePriority integerValue] : NSOperationQueuePriorityNormal
															   withThreadPriority:threadPriority ? [threadPriority doubleValue] : defaultThreadPriority];
			
				[self.queues setObject:queueInfo forKey:name];
				
				DLog(@"loaded queue=%@", queueInfo);
			}
		}
	}
	
	return self;
}

#pragma mark -
#pragma mark Operations

- (void) performOperationOnQueue:(NSString*) queueName operation:(NSOperation*) operation {
	LolayQueueInfo* queue = [self.queues objectForKey:queueName];
	[queue performOperation:operation];
}

#pragma mark -
#pragma mark Selectors

- (void) performSelectorOnQueue:(NSString*) queueName target:(id) target selector:(SEL) selector {
	LolayQueueInfo* queue = [self.queues objectForKey:queueName];
	[queue performSelectorOnTarget:target selector:selector];
}

- (void) performSelectorOnQueue:(NSString*) queueName target:(id) target selector:(SEL) selector withObject:(id) argument {
	LolayQueueInfo* queue = [self.queues objectForKey:queueName];
	[queue performSelectorOnTarget:target selector:selector withObject:argument];
}

- (void) performSelectorOnQueue:(NSString*) queueName target:(id) target selector:(SEL) selector withObject:(id) argument1 withObject:(id) argument2 {
	LolayQueueInfo* queue = [self.queues objectForKey:queueName];
	[queue performSelectorOnTarget:target selector:selector withObject:argument1 withObject:argument2];
}

#pragma mark -
#pragma mark Blocks

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_4_0

- (void) performBlockOnQueue:(NSString*) queueName block:(void (^)(void)) block {
	LolayQueueInfo* queue = [self.queues objectForKey:queueName];
	[queue performBlock:block];
}

- (void) performBlockOnQueue:(NSString*) queueName withQueuePriority:(NSOperationQueuePriority) queuePriority block:(void (^)(void)) block {
	LolayQueueInfo* queue = [self.queues objectForKey:queueName];
	[queue performBlockWithQueuePriority:queuePriority block:block];
}

- (void) performBlockOnQueue:(NSString*) queueName withThreadPriority:(float) threadPriority block:(void (^)(void)) block {
	LolayQueueInfo* queue = [self.queues objectForKey:queueName];
	[queue performBlockWithThreadPriority:threadPriority block:block];
}

- (void) performBlockOnQueue:(NSString*) queueName withQueuePriority:(NSOperationQueuePriority) queuePriority withThreadPriority:(float) threadPriority block:(void (^)(void)) block {
	LolayQueueInfo* queue = [self.queues objectForKey:queueName];
	[queue performBlockWithQueuePriority:queuePriority withThreadPriority:threadPriority block:block];
}

#endif

#pragma mark -
#pragma mark Queue Controls

- (void) suspendQueue:(NSString*) queueName {
	LolayQueueInfo* queue = [self.queues objectForKey:queueName];
	[queue suspend];
}

- (void) resumeQueue:(NSString*) queueName {
	LolayQueueInfo* queue = [self.queues objectForKey:queueName];
	[queue resume];
}

- (void) cancelAllOperationsOnQueue:(NSString*) queueName {
	LolayQueueInfo* queue = [self.queues objectForKey:queueName];
	[queue cancelAllOperations];
}

- (NSArray*) activeQueues {
    NSMutableArray* activeQueueNames = [[NSMutableArray alloc] initWithCapacity:0];
    if (self.queues && self.queues.count > 0) {
        NSString* queueName = nil;
        NSEnumerator* queueEnumerator = self.queues.keyEnumerator;
        while (queueName = [queueEnumerator nextObject]) {
            LolayQueueInfo* queue = [self.queues objectForKey:queueName];      
            if (queue.operationCount > 0) {
                [activeQueueNames addObject:queue];
            }
        }
    }
    return activeQueueNames;
}

@end