//
//  HungrySnakeTests.m
//  HungrySnakeTests
//
//  Created by Tingwei Hsu on 2018/8/16.
//  Copyright © 2018年 Tingwei Hsu. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HSSnake.h"
#import "MockSnakeDelegate.h"

@interface HSSnakeTests : XCTestCase
@property (nonatomic,strong) HSSnake *snake;
@property (nonatomic,strong) MockSnakeDelegate *mock;
@end

@interface HSSnake (Testing)
@property (nonatomic,strong) HSCoordinate *wallPoint;
@property (nonatomic) enum HSDirection oldDirection;
@property (nonatomic) enum HSDirection nextDirection;
@property (nonatomic,strong) NSMutableArray *bodyPositions;
@property (nonatomic) NSInteger growthCount;
@end

@implementation HSSnakeTests

- (void)setUp
{
    [super setUp];
    self.snake = [[HSSnake alloc] initWithGameField:[[HSCoordinate alloc] initWithCoordinateX:9 Y:9]];
    self.mock = [[MockSnakeDelegate alloc] init];
    self.snake.delegate = self.mock;
}

- (void)tearDown
{
    self.snake = nil;
    self.mock = nil;
    [super tearDown];
}

- (void)testSnakeInitWithEventCoordinate
{
    [self.snake setup];
    HSCoordinate *head = [[self.snake getBodyPosition] lastObject];
    HSCoordinate *tail = [[self.snake getBodyPosition] firstObject];
    XCTAssertEqual(self.snake.nextDirection,HSDirectionLeft);
    XCTAssertEqual(4, head.x);
    XCTAssertEqual(4, head.y);
    XCTAssertEqual(5, tail.x);
    XCTAssertEqual(4, tail.y);
    XCTAssertFalse(self.mock.snakeDidCrashIntoBody);
    XCTAssertEqual(self.mock.callingSnake, self.snake);
    XCTAssertEqual(self.mock.headGainCount, 2);
    XCTAssertEqual(self.mock.tailLostCount, 0);
}

- (void)testSnakeMove
{
    [self.snake setup];
    [self.snake move];
    [self.snake move];
    HSCoordinate *head = [[self.snake getBodyPosition] lastObject];
    HSCoordinate *tail = [[self.snake getBodyPosition] firstObject];
    XCTAssertEqual(self.snake.nextDirection,HSDirectionLeft);
    XCTAssertEqual(2, head.x);
    XCTAssertEqual(4, head.y);
    XCTAssertEqual(3, tail.x);
    XCTAssertEqual(4, tail.y);
    XCTAssertFalse(self.mock.snakeDidCrashIntoBody);
    XCTAssertEqual(self.mock.callingSnake, self.snake);
    XCTAssertEqual(self.mock.headGainCount, 4);
    XCTAssertEqual(self.mock.tailLostCount, 2);
}

- (void)testSnakeValidTurn
{
    [self.snake setup];
    [self.snake move];
    [self.snake changeDirectionTo:HSDirectionDown];
    [self.snake move];
    [self.snake changeDirectionTo:HSDirectionRight];
    [self.snake move];
    HSCoordinate *head = [[self.snake getBodyPosition] lastObject];
    HSCoordinate *tail = [[self.snake getBodyPosition] firstObject];
    XCTAssertEqual(self.snake.nextDirection,HSDirectionRight);
    XCTAssertEqual(4, head.x);
    XCTAssertEqual(3, head.y);
    XCTAssertEqual(3, tail.x);
    XCTAssertEqual(3, tail.y);
    XCTAssertFalse(self.mock.snakeDidCrashIntoBody);
    XCTAssertEqual(self.mock.callingSnake, self.snake);
    XCTAssertEqual(self.mock.headGainCount, 5);
    XCTAssertEqual(self.mock.tailLostCount, 3);
}

- (void)testSnakeInValidTurn
{
    [self.snake setup];
    [self.snake move];
    [self.snake changeDirectionTo:HSDirectionLeft];
    [self.snake move];
    [self.snake changeDirectionTo:HSDirectionRight];
    [self.snake move];
    [self.snake changeDirectionTo:HSDirectionRight];
    [self.snake move];
    HSCoordinate *head = [[self.snake getBodyPosition] lastObject];
    HSCoordinate *tail = [[self.snake getBodyPosition] firstObject];
    XCTAssertEqual(self.snake.nextDirection,HSDirectionLeft);
    XCTAssertEqual(0, head.x);
    XCTAssertEqual(4, head.y);
    XCTAssertEqual(1, tail.x);
    XCTAssertEqual(4, tail.y);
    XCTAssertFalse(self.mock.snakeDidCrashIntoBody);
    XCTAssertEqual(self.mock.callingSnake, self.snake);
    XCTAssertEqual(self.mock.headGainCount, 6);
    XCTAssertEqual(self.mock.tailLostCount, 4);
}

- (void)testSnakeGrowth
{
    [self.snake setup];
    [self.snake growth:2];
    [self.snake move];
    [self.snake move];
    [self.snake move];
    HSCoordinate *head = [[self.snake getBodyPosition] lastObject];
    HSCoordinate *tail = [[self.snake getBodyPosition] firstObject];
    XCTAssertEqual(self.snake.nextDirection,HSDirectionLeft);
    XCTAssertEqual(1, head.x);
    XCTAssertEqual(4, head.y);
    XCTAssertEqual(4, tail.x);
    XCTAssertEqual(4, tail.y);
    XCTAssertFalse(self.mock.snakeDidCrashIntoBody);
    XCTAssertEqual(self.mock.callingSnake, self.snake);
    XCTAssertEqual(self.mock.headGainCount, 5);
    XCTAssertEqual(self.mock.tailLostCount, 1);
}

- (void)testSnakePassedWall
{
    [self.snake setup];
    for(NSInteger x=0; x<5; x++){
        [self.snake move];
    }
    XCTAssertEqual(self.snake.nextDirection,HSDirectionLeft);
    XCTAssertEqual(9, [[self.snake getBodyPosition] lastObject].x);
    XCTAssertEqual(4, [[self.snake getBodyPosition] lastObject].y);
    XCTAssertEqual(0, [[self.snake getBodyPosition] firstObject].x);
    XCTAssertEqual(4, [[self.snake getBodyPosition] firstObject].y);
    [self.snake changeDirectionTo:HSDirectionUp];
    for(NSInteger y=0; y<6; y++){
        [self.snake move];
    }
    XCTAssertEqual(self.snake.nextDirection,HSDirectionUp);
    XCTAssertEqual(9, [[self.snake getBodyPosition] lastObject].x);
    XCTAssertEqual(0, [[self.snake getBodyPosition] lastObject].y);
    XCTAssertEqual(9, [[self.snake getBodyPosition] firstObject].x);
    XCTAssertEqual(9, [[self.snake getBodyPosition] firstObject].y);
    XCTAssertFalse(self.mock.snakeDidCrashIntoBody);
    XCTAssertEqual(self.mock.callingSnake, self.snake);
    XCTAssertEqual(self.mock.headGainCount, 13);
    XCTAssertEqual(self.mock.tailLostCount, 11);
}

- (void)testSnakeCrashed
{
    [self.snake setup];
    [self.snake growth:5];
    [self.snake move];
    [self.snake changeDirectionTo:HSDirectionDown];
    [self.snake move];
    [self.snake changeDirectionTo:HSDirectionRight];
    [self.snake move];
    [self.snake changeDirectionTo:HSDirectionUp];
    [self.snake move];
    HSCoordinate *head = [[self.snake getBodyPosition] lastObject];
    HSCoordinate *tail = [[self.snake getBodyPosition] firstObject];
    XCTAssertEqual(self.snake.nextDirection,HSDirectionUp);
    XCTAssertEqual(4, head.x);
    XCTAssertEqual(3, head.y);
    XCTAssertEqual(5, tail.x);
    XCTAssertEqual(4, tail.y);
    XCTAssertTrue(self.mock.snakeDidCrashIntoBody);
    XCTAssertEqual(self.mock.callingSnake, self.snake);
    XCTAssertEqual(self.mock.headGainCount, 5);
    XCTAssertEqual(self.mock.tailLostCount, 0);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
