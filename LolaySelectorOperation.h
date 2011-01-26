//
//  Created by Lolay, Inc.
//  Copyright 2011 Lolay, Inc. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface LolaySelectorOperation : NSOperation

- (id) initWithTarget:(id) inTarget withSelector:(SEL) inSelector;
- (id) initWithTarget:(id) inTarget withSelector:(SEL) inSelector withObject:(id) inObject;
- (id) initWithTarget:(id) inTarget withSelector:(SEL) inSelector withObject:(id) inObject1 withObject:(id) inObject2;

- (id) initWithTarget:(id) inTarget withSelector:(SEL) inSelector withCallbackTarget:(id) inCallbackTarget withCallbackSelector:(SEL) inCallbackSelector;
- (id) initWithTarget:(id) inTarget withSelector:(SEL) inSelector withObject:(id) inObject withCallbackTarget:(id) inCallbackTarget withCallbackSelector:(SEL) inCallbackSelector;
- (id) initWithTarget:(id) inTarget withSelector:(SEL) inSelector withObject:(id) inObject1 withObject:(id) inObject2 withCallbackTarget:(id) inCallbackTarget withCallbackSelector:(SEL) inCallbackSelector;

@end