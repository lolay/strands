//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//
#import "LolaySelectorOperation.h"

@interface LolaySelectorOperation ()

@property (nonatomic, retain, readwrite) id target;
@property (nonatomic, assign, readwrite) SEL selector;
@property (nonatomic, retain, readwrite) id object1;
@property (nonatomic, retain, readwrite) id object2;

@end

@implementation LolaySelectorOperation

- (id) initWithTarget:(id) inTarget withSelector:(SEL) inSelector {
	return [self initWithTarget:inTarget withSelector:inSelector withObject:nil withObject:nil];
}

- (id) initWithTarget:(id) inTarget withSelector:(SEL) inSelector withObject:(id) inObject {
	return [self initWithTarget:inTarget withSelector:inSelector withObject:inObject withObject:nil];
}

- (id) initWithTarget:(id) inTarget withSelector:(SEL) inSelector withObject:(id) inObject1 withObject:(id) inObject2 {
	self = [super init];
	
	if (self) {
		self.target = inTarget;
		self.selector = inSelector;
		self.object1 = inObject1;
		self.object2 = inObject2;
	}
	
	return self;
}

- (void) dealloc {
	self.target = nil;
	self.object1 = nil;
	self.object2 = nil;
	
	[super dealloc];
}

- (void) main {
	if ([self isCancelled]) {
		return;
	}
	
	if (self.target == nil || self.selector == NULL) {
		return;
	}
	
	if ([self.target respondsToSelector:self.selector]) {
		if (self.object1 == nil && self.object2 == nil) {
			[self.target performSelector:self.selector];
		} else if (self.object2 == nil) {
			[self.target performSelector:self.selector withObject:self.object1];
		} else {
			[self.target performSelector:self.selector withObject:self.object1 withObject:self.object2];
		}
	}
}

@end