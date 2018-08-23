//
//  HSFoodProviderTests.m
//  HungrySnakeTests
//
//  Created by Tingwei Hsu on 2018/8/23.
//  Copyright © 2018年 Tingwei Hsu. All rights reserved.
//

#import <XCTest/XCTest.h>
#include "HSFoodProvider.h"

@interface HSFoodProviderTests : XCTestCase
@property HSFoodProvider *foodProvider;
@property NSArray *stubNoEmptySpace;
@property NSArray *stubOnlyOneEmptySpace;
@property NSArray *stubMultipleEmptySpace;
@end

@implementation HSFoodProviderTests

- (void)setUp {
    [super setUp];
    self.foodProvider = [[HSFoodProvider alloc] init];
}

- (void)tearDown {
    self.foodProvider = nil;
    [super tearDown];
}

- (void)testFoodProviderGenerateFoodWithNoEmptySpace {
    self.stubNoEmptySpace = [[NSArray alloc] init];
    HSCoordinate *newLocation = [self.foodProvider generateNewFoodWithEmptySpace:self.stubNoEmptySpace];
    XCTAssertNil(newLocation);
    XCTAssertEqual(newLocation, [self.foodProvider getFoodLocation]);
}

- (void)testFoodProviderGenerateFoodWithOneEmptySpace {
    self.stubOnlyOneEmptySpace = [[NSArray alloc] initWithObjects:[[HSCoordinate alloc] initWithCoordinateX:2 Y:3] , nil];
    HSCoordinate *newLocation = [self.foodProvider generateNewFoodWithEmptySpace:self.stubOnlyOneEmptySpace];
    XCTAssertEqual(newLocation.x, 2);
    XCTAssertEqual(newLocation.y, 3);
    XCTAssertEqual(newLocation, [self.foodProvider getFoodLocation]);
}

- (void)testFoodProviderGenerateFoodWithMultipleEmptySpace {
    self.stubMultipleEmptySpace = [[NSArray alloc] initWithObjects:[[HSCoordinate alloc] initWithCoordinateX:1 Y:2], [[HSCoordinate alloc] initWithCoordinateX:3 Y:4], [[HSCoordinate alloc] initWithCoordinateX:5 Y:6] , nil];
    HSCoordinate *newLocation = [self.foodProvider generateNewFoodWithEmptySpace:self.stubMultipleEmptySpace];
    BOOL isEqual = NO;
    for (HSCoordinate *point in self.stubMultipleEmptySpace) {
        if (point.x == newLocation.x && point.y == newLocation.y){
            isEqual = YES;
        }
    }
    XCTAssertTrue(isEqual);
    XCTAssertEqual(newLocation, [self.foodProvider getFoodLocation]);
}



- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
