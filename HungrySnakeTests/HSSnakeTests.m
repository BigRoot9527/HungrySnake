//
//  HungrySnakeTests.m
//  HungrySnakeTests
//
//  Created by Tingwei Hsu on 2018/8/16.
//  Copyright © 2018年 Tingwei Hsu. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HSSnake.h"
#import "SpySnakeDelegate.h"

@interface HSSnakeTests : XCTestCase
@property (nonatomic,strong) HSSnake *snake;
@property (nonatomic,strong) SpySnakeDelegate *spyDelegate;
@end

@interface HSSnake (Testing)
@end

@implementation HSSnakeTests

- (void)setUp
{
    self.snake = [[HSSnake alloc] initWithGameField:[[HSCoordinate alloc] initWithCoordinateX:10 Y:10]];
    self.spyDelegate = [[SpySnakeDelegate alloc] init];
    self.snake.delegate = self.spyDelegate;
}

- (void)tearDown
{
    self.snake.delegate = nil;
    self.snake = nil;
    self.spyDelegate = nil;
}

- (void)testInitWithEventCoordinate
{
    [self.snake setup];
    HSCoordinate *head = [self.snake getBodyPosition][1];
    HSCoordinate *tail = [self.snake getBodyPosition][0];
    XCTAssertEqual(5, head.x);
    XCTAssertEqual(5, head.y);
    XCTAssertEqual(6, tail.x);
    XCTAssertEqual(5, tail.y);
    XCTAssertTrue(self.spyDelegate.isDelegateCalled);
}


- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
