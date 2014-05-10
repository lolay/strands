//
//  LolayStrandsTests.m
//  LolayStrandsTests
//
//  Created by Bruce Johnson on 5/10/14.
//  Copyright (c) 2014 Lolay. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LolayQueueManager.h"

@interface LolayStrandsTests : XCTestCase

@property (nonatomic, readwrite, strong) LolayQueueManager *queueManager;

@end

@implementation LolayStrandsTests

- (void)setUp
{
    [super setUp];
	self.queueManager = [[LolayQueueManager alloc] init];
}

- (void)tearDown
{
	self.queueManager = nil;
    [super tearDown];
}

- (void)testQueue
{
	XCTAssertNotNil(self.queueManager, @"Queue Manager Nil value.");
}

@end
