//
//  HungrySnakeTests.m
//  HungrySnakeTests
//
//  Created by Tingwei Hsu on 2018/8/16.
//  Copyright © 2018年 Tingwei Hsu. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "HSSnake.h"

@interface HSSnake (Testing)

@property (nonatomic,strong) HSCoordinate *wallPoint;
@property (nonatomic) enum HSDirection movedDirection;
@property (nonatomic) NSInteger minimumLengh;
- (void)privateSetupPositionWithWallPoint:(HSCoordinate*)point;

@end


@interface HSSnakeInitTests : XCTestCase

@property (nonatomic,strong) HSSnake *snake;
@property (nonatomic,strong) HSCoordinate *stubAllValidField;
@property (nonatomic,strong) HSCoordinate *stubXInvalidField;
@property (nonatomic,strong) HSCoordinate *stubYInvalidField;
@property (nonatomic,strong) HSCoordinate *stubAllInvalidField;

@end

@implementation HSSnakeInitTests

- (void)setUp {
    [super setUp];
    self.stubAllValidField = [[HSCoordinate alloc] initWithCoordinateX:20 withCoordinateY:20];
    self.stubXInvalidField = [[HSCoordinate alloc] initWithCoordinateX:0 withCoordinateY:20];
    self.stubYInvalidField = [[HSCoordinate alloc] initWithCoordinateX:20 withCoordinateY:0];
    self.stubAllInvalidField = [[HSCoordinate alloc] initWithCoordinateX:0 withCoordinateY:0];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    self.snake = nil;
}

- (void)test_initWithFieldSize_withAllValidField_expectEqual {
    self.snake = [[HSSnake alloc] initWithFieldSize:self.stubAllValidField];
    XCTAssertEqual(self.snake.wallPoint.x, self.stubAllValidField.x);
    XCTAssertEqual(self.snake.wallPoint.y, self.stubAllValidField.y);
    XCTAssertEqual([self.snake.bodyPositions count], 2);
    XCTAssertEqual([self.snake.emptySpace count], (self.stubAllValidField
                                                   .x + 1) * (self.stubAllValidField.y + 1) - 2);
}

- (void)test_initWithFieldSize_withXInvalidField_expectEqual {
    self.snake = [[HSSnake alloc] initWithFieldSize:self.stubXInvalidField];
    XCTAssertEqual(self.snake.wallPoint.x, self.snake.minimumLengh);
    XCTAssertEqual(self.snake.wallPoint.y, self.stubXInvalidField.y);
    XCTAssertEqual([self.snake.bodyPositions count], 2);
    XCTAssertEqual([self.snake.emptySpace count], (self.snake.minimumLengh + 1) * (self.stubXInvalidField.y + 1) - 2);
}

- (void)test_initWithFieldSize_withYInvalidField_expectEqual {
    self.snake = [[HSSnake alloc] initWithFieldSize:self.stubYInvalidField];
    XCTAssertEqual(self.snake.wallPoint.x, self.stubYInvalidField.x);
    XCTAssertEqual(self.snake.wallPoint.y, self.snake.minimumLengh);
    XCTAssertEqual([self.snake.bodyPositions count], 2);
}

- (void)test_initWithFieldSize_withAllInvalidField_expectEqual {
    self.snake = [[HSSnake alloc] initWithFieldSize:self.stubAllInvalidField];
    XCTAssertEqual(self.snake.wallPoint.x, self.snake.minimumLengh);
    XCTAssertEqual(self.snake.wallPoint.y, self.snake.minimumLengh);
    XCTAssertEqual([self.snake.bodyPositions count], 2);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
