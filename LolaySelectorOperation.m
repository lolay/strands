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
@property (nonatomic, retain, readwrite) id callbackTarget;
@property (nonatomic, assign, readwrite) SEL callbackSelector;

@end

@implementation LolaySelectorOperation

- (id) initWithTarget:(id) inTarget withSelector:(SEL) inSelector {
	return [self initWithTarget:inTarget withSelector:inSelector withObject:nil withObject:nil withCallbackTarget:nil withCallbackSelector:NULL];
}

- (id) initWithTarget:(id) inTarget withSelector:(SEL) inSelector withObject:(id) inObject {
	return [self initWithTarget:inTarget withSelector:inSelector withObject:inObject withObject:nil withCallbackTarget:nil withCallbackSelector:NULL];
}

- (id) initWithTarget:(id) inTarget withSelector:(SEL) inSelector withObject:(id) inObject1 withObject:(id) inObject2 {
	return [self initWithTarget:inTarget withSelector:inSelector withObject:inObject1 withObject:inObject2 withCallbackTarget:nil withCallbackSelector:NULL];
}

- (id) initWithTarget:(id) inTarget withSelector:(SEL) inSelector withCallbackTarget:(id) inCallbackTarget withCallbackSelector:(SEL) inCallbackSelector {
	return [self initWithTarget:inTarget withSelector:inSelector withObject:nil withObject:nil withCallbackTarget:inCallbackTarget withCallbackSelector:inCallbackSelector];
}

- (id) initWithTarget:(id) inTarget withSelector:(SEL) inSelector withObject:(id) inObject withCallbackTarget:(id) inCallbackTarget withCallbackSelector:(SEL) inCallbackSelector {
	return [self initWithTarget:inTarget withSelector:inSelector withObject:inObject withObject:nil withCallbackTarget:inCallbackTarget withCallbackSelector:inCallbackSelector];
}

- (id) initWithTarget:(id) inTarget withSelector:(SEL) inSelector withObject:(id) inObject1 withObject:(id) inObject2 withCallbackTarget:(id) inCallbackTarget withCallbackSelector:(SEL) inCallbackSelector {
	self = [super init];
	
	if (self) {
		self.target = inTarget;
		self.selector = inSelector;
		self.object1 = inObject1;
		self.object2 = inObject2;
		self.callbackTarget = inCallbackTarget;
		self.callbackSelector = inCallbackSelector;
	}
	
	return self;
}

- (void) dealloc {
	self.target = nil;
	self.object1 = nil;
	self.object2 = nil;
	self.callbackTarget = nil;
	
	[super dealloc];
}

- (void) main {
	if ([self isCancelled]) {
		return;
	}
	
	if (self.target == nil || self.selector == NULL) {
		return;
	}
	
	id result = nil;
	if ([self.target respondsToSelector:self.selector]) {
		if (self.object1 == nil && self.object2 == nil) {
			result = [[self.target performSelector:self.selector] retain];
		} else if (self.object2 == nil) {
			result = [[self.target performSelector:self.selector withObject:self.object1] retain];
		} else {
			result = [[self.target performSelector:self.selector withObject:self.object1 withObject:self.object2] retain];
		}
	}
	
	if (self.callbackTarget == nil || self.callbackSelector == NULL) {
		[result release];
		return;
	}
	
	if ([self.callbackTarget respondsToSelector:self.callbackSelector]) {
		[self.callbackTarget performSelector:self.callbackSelector withObject:result];
	}
	[result release];
}

@end