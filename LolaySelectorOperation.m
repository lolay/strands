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

#import <objc/message.h>
#import "LolaySelectorOperation.h"

@interface LolaySelectorOperation ()

@property (nonatomic, strong, readwrite) id target;
@property (nonatomic, assign, readwrite) SEL selector;
@property (nonatomic, strong, readwrite) id object1;
@property (nonatomic, strong, readwrite) id object2;

@end

@implementation LolaySelectorOperation

@synthesize target = target_;
@synthesize selector = selector_;
@synthesize object1 = object1_;
@synthesize object2 = object2_;

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

- (void) main {
	if ([self isCancelled]) {
		return;
	}
	
	if (self.target == nil || self.selector == NULL) {
		return;
	}
	
	if ([self.target respondsToSelector:self.selector]) {
		if (self.object1 == nil && self.object2 == nil) {
            // TODO when Apple has a better mechanism for masking the "PerformSelector may cause a leak because its selector is unknown" warning, use it
            objc_msgSend(self.target, self.selector);
		} else if (self.object2 == nil) {
            // TODO when Apple has a better mechanism for masking the "PerformSelector may cause a leak because its selector is unknown" warning, use it
            objc_msgSend(self.target, self.selector, self.object1);
		} else {
            // TODO when Apple has a better mechanism for masking the "PerformSelector may cause a leak because its selector is unknown" warning, use it
            objc_msgSend(self.target, self.selector, self.object1, self.object2);
		}
	}
}

@end