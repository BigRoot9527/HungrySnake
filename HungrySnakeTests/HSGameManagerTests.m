//
//  HSGameManagerTests.m
//  HungrySnakeTests
//
//  Created by Tingwei Hsu on 2018/8/23.
//  Copyright © 2018年 Tingwei Hsu. All rights reserved.
//

#import <XCTest/XCTest.h>
#include "HSGameManager.h"
#include "HSSnake.h"
#include "HSFoodProvider.h"
#include "MockGameManagerDelegate.h"

@interface HSGameManagerTests : XCTestCase
@property (nonatomic,strong) HSGameManager *manager;
@property (nonatomic,strong) MockGameManagerDelegate *mock;
@property (nonatomic,strong) HSCoordinate *stubGameFiledSize;
@end

@interface HSGameManager(Testing)
@property (nonatomic,strong) HSCoordinate *gameFildSize;
@property (nonatomic,strong) NSMutableArray *emptySpace;
@property (nonatomic) NSInteger score;
@property (nonatomic) BOOL snakeCrashed;
@property (nonatomic,strong) NSTimer *snakeTimer;
@property (nonatomic,strong) HSSnake *snake;
@property (nonatomic,strong) HSFoodProvider *foodProvider;
- (void)_moveSnake;
- (void)_snakeEatFood;
- (void)_gameStop;
- (void)_snakeWin;
- (void)snakeDidGainHeadOn:(HSCoordinate *)headPoint snake:(HSSnake *)snake;
- (void)snakeDidLostTailOn:(HSCoordinate *)tailPoint snake:(HSSnake *)snake;
- (void)snakeDidCrashIntoBody:(HSSnake *)snake;
@end

@interface HSSnake(Testing)
@property (nonatomic) enum HSDirection nextDirection;
@property (nonatomic,strong) NSMutableArray *bodyPositions;
@property (nonatomic) NSInteger growthCount;
@end

@implementation HSGameManagerTests

- (void)setUp {
    [super setUp];
    self.manager = [[HSGameManager alloc] init];
    self.mock = [[MockGameManagerDelegate alloc] init];
    self.manager.delegate = self.mock;
    self.stubGameFiledSize = [[HSCoordinate alloc] initWithCoordinateX:10 Y:10];
}

- (void)tearDown {
    self.manager = nil;
    self.mock = nil;
    self.stubGameFiledSize = nil;
    [super tearDown];
}

- (void)testGameManagerInit
{
    XCTAssertNil(self.manager.snakeTimer);
    XCTAssertNil(self.manager.snake);
    XCTAssertNotNil(self.manager.foodProvider);
    XCTAssertNil(self.manager.gameFildSize);
    XCTAssertEqual(self.manager.score, 0);
    XCTAssertNotNil(self.manager.emptySpace);
    XCTAssertEqual(self.manager.emptySpace.count, 0);
}

- (void)testGameManagerStartNewGame
{
    [self.manager startNewGameWithFieldSize:self.stubGameFiledSize snakeSpeed:10];
    XCTAssertNotNil(self.manager.snake);
    XCTAssertNotNil([self.manager getFoodLocation]);
    XCTAssertNotNil([self.manager getSnakeBody]);
    XCTAssertEqual([self.manager getFarestPoint].x, self.stubGameFiledSize.x - 1);
    XCTAssertEqual([self.manager getFarestPoint].y, self.stubGameFiledSize.y - 1);
    XCTAssertEqual([self.manager.snakeTimer timeInterval], 1-(0.09*10));
}

- (void)testGameManagerStopGame
{
    [self.manager startNewGameWithFieldSize:self.stubGameFiledSize snakeSpeed:10];
    [self.manager _gameStop];
    XCTAssertNil(self.manager.snakeTimer);
}

- (void)testGameManagerDirectionControl
{
    [self.manager startNewGameWithFieldSize:self.stubGameFiledSize snakeSpeed:10];
    [self.manager snakeDirectionControl:HSDirectionDown];
    XCTAssertEqual(self.manager.snake.nextDirection, HSDirectionDown);
}

- (void)testGameManagerMoveSnake
{
    [self.manager startNewGameWithFieldSize:self.stubGameFiledSize snakeSpeed:10];
    [self.manager.snakeTimer invalidate];
    [self.manager _moveSnake];
    HSCoordinate *head = [[self.manager getSnakeBody] lastObject];
    HSCoordinate *tail = [[self.manager getSnakeBody] firstObject];
    XCTAssertEqual(3, head.x);
    XCTAssertEqual(4, head.y);
    XCTAssertEqual(4, tail.x);
    XCTAssertEqual(4, tail.y);
    XCTAssertTrue(self.mock.delegateDidUpdateGame);
    XCTAssertEqual(self.mock.callingManager, self.manager);
    for (HSCoordinate *point in self.manager.emptySpace){
        if (point.y == 4 && (point.x == 3 || point.x ==4)) {
            XCTFail("Empty space must no contains snake body.");
        }
    }
}

- (void)testGameManagerTellSnakeEatFood
{
    [self.manager startNewGameWithFieldSize:self.stubGameFiledSize snakeSpeed:10];
    [self.manager.snakeTimer invalidate];
    [self.manager _snakeEatFood];
    XCTAssertGreaterThan(self.manager.score, 0);
    XCTAssertGreaterThan(self.manager.snake.growthCount, 0);
    XCTAssertTrue(self.mock.delegateDidUpdateGame);
    XCTAssertEqual(self.manager, self.mock.callingManager);
}

- (void)testGameManagerGetSnakeBody
{
    [self.manager startNewGameWithFieldSize:self.stubGameFiledSize snakeSpeed:10];
    [self.manager.snakeTimer invalidate];
    [self.manager _moveSnake];
    for(HSCoordinate *output in [self.manager getSnakeBody]) {
        BOOL isEqual = NO;
        for(HSCoordinate *point in self.manager.snake.bodyPositions) {
            if (output.x == point.x && output.y == point.y) {
                isEqual = YES;
            }
        }
        XCTAssertTrue(isEqual,"getSnakeBody must return Real Snake Body.");
    }
}

- (void)testGameManagerGetFoodLocation
{
    [self.manager startNewGameWithFieldSize:self.stubGameFiledSize snakeSpeed:10];
    XCTAssertEqual([self.manager getFoodLocation],[self.manager.foodProvider getFoodLocation]);
}

- (void)testGameManagerGetFarestPoint
{
    [self.manager startNewGameWithFieldSize:self.stubGameFiledSize snakeSpeed:10];
    XCTAssertEqual([self.manager getFarestPoint].x, self.stubGameFiledSize.x - 1, "Manager must handle Coordinate Transform.");
    XCTAssertEqual([self.manager getFarestPoint].y, self.stubGameFiledSize.y - 1, "Manager must handle Coordinate Transform.");
}

- (void)testGameManagerSnakeWin
{
    [self.manager startNewGameWithFieldSize:self.stubGameFiledSize snakeSpeed:10];
    self.manager.score = 100;
    [self.manager _snakeWin];
    XCTAssertEqual(self.mock.callingManager, self.manager);
    XCTAssertTrue(self.mock.delegateDidCallSnakeWin);
    XCTAssertEqual(self.mock.delegateSendScore, 100);
    XCTAssertNil(self.manager.snakeTimer);
}

- (void)testGameManagerGotSnakeGainHead
{
    [self.manager startNewGameWithFieldSize:self.stubGameFiledSize snakeSpeed:10];
    [self.manager.snakeTimer invalidate];
    HSSnake *stubSnake = [[HSSnake alloc] init];
    HSCoordinate *stubSnakeHead = [[HSCoordinate alloc] initWithCoordinateX:3 Y:3];
    [self.manager snakeDidGainHeadOn:stubSnakeHead snake:stubSnake];
    for (HSCoordinate *point in self.manager.emptySpace) {
        if(point.x == stubSnakeHead.x && point.y == stubSnakeHead.y) {
            XCTFail("Gained Head must not in the empty space");
        }
    }
}

- (void)testGameManagerGotSnakeDidLostTail
{
    [self.manager startNewGameWithFieldSize:self.stubGameFiledSize snakeSpeed:10];
    [self.manager.snakeTimer invalidate];
    HSSnake *fakeSnake = [[HSSnake alloc] init];
    HSCoordinate *stubSnakeTail = [[HSCoordinate alloc] initWithCoordinateX:6 Y:5];
    [self.manager snakeDidLostTailOn:stubSnakeTail snake:fakeSnake];
    BOOL isEqaul = NO;
    for (HSCoordinate *point in self.manager.emptySpace) {
        if(point == stubSnakeTail) {
            isEqaul = !isEqaul;
        }
    }
    XCTAssertTrue(isEqaul);
}

- (void)testGameManagerGotSnakeCrashed
{
    [self.manager startNewGameWithFieldSize:self.stubGameFiledSize snakeSpeed:10];
    self.manager.score = 100;
    HSSnake *fakeSnake = [[HSSnake alloc] init];
    [self.manager snakeDidCrashIntoBody:fakeSnake];
    XCTAssertEqual(self.mock.callingManager, self.manager);
    XCTAssertTrue(self.mock.delegateDidCallSnakeCrash);
    XCTAssertEqual(self.mock.delegateSendScore, 100);
    XCTAssertNil(self.manager.snakeTimer);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
