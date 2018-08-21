//
//  HSSnake.m
//  HungrySnake
//
//  Created by Tingwei Hsu on 2018/8/16.
//  Copyright © 2018年 Tingwei Hsu. All rights reserved.
//

#import "HSSnake.h"

@interface HSSnake()
@property (nonatomic,strong) NSMutableArray *bodyPositions;
@property (nonatomic,strong) NSMutableArray *emptySpace;
@property (nonatomic,strong) HSCoordinate *wallPoint;
@property (nonatomic) enum HSDirection movedDirection;
@property (nonatomic) NSInteger minimumLengh;
@property (nonatomic) NSInteger growthFactor;
@end

@implementation HSSnake

- (id)initWithFieldSize:(HSCoordinate *)farestPoint
{
    self = [super init];
    if (self) {
        self.minimumLengh = 2;
        self.growthFactor = 0;
        NSAssert(farestPoint.x >= self.minimumLengh, @"Must be larger than minimumLengh");
        NSAssert(farestPoint.y >= self.minimumLengh, @"Must be larger than minimumLengh");
        self.bodyPositions = [[NSMutableArray alloc] init];
        self.emptySpace = [[NSMutableArray alloc] init];
        self.wallPoint = farestPoint;
        self.nextDirection = HSDirectionLeft;
        for (int i = 0; i <= farestPoint.x; i++){
            for (int j = 0; j <= farestPoint.y ; j++) {
                [self.emptySpace addObject: [[HSCoordinate alloc] initWithCoordinateX:i Y:j]];
            }
        }
        [self privateSetupPositionWithWallPoint:self.wallPoint];
    }
    return self;
}

- (void)movingAroundFood:(HSCoordinate *)foodLocation
{
    HSCoordinate *newHead = [self privateGetNewHeadPosition];
    if (newHead.x == foodLocation.x && newHead.y == foodLocation.y) {
        [self _ateFoodOn:foodLocation];
    } else {
        [self _movedTo:newHead];
    }
}

#pragma mark - Private methods

- (void)_movedTo:(HSCoordinate *)location
{
    [self _dequeue];
    BOOL isCrashIntoBody = [self _checkIfCrash:location];
    if (isCrashIntoBody) {
        [self.delegate snakeDidCrashIntoBody:true];
        return;
    }
    [self privateEnqueue:location];
}

- (BOOL)_checkIfCrash:(HSCoordinate *)location
{
    for (HSCoordinate *points in self.bodyPositions) {
        if (points.x == location.x && points.y == location.y) {
            return true;
        }
    }
    return false;
}

- (void)_ateFoodOn:(HSCoordinate *)location
{
    self.growthFactor += 1;
    [self privateEnqueue:location];
    [self.delegate snakeDidEatFoodWithEmptySpace:self.emptySpace];
}

- (void)privateSetupPositionWithWallPoint:(HSCoordinate*)point
{
    NSInteger middleX = point.x % 2 == 0 ? point.x / 2 : point.x / 2 + 1;
    NSInteger middleY = point.y % 2 == 0 ? point.y / 2 : point.y / 2 + 1;
    //initial tail
    [self privateEnqueue:[[HSCoordinate alloc] initWithCoordinateX:middleX+1 Y:middleY]];
    //initail head
    [self privateEnqueue:[[HSCoordinate alloc] initWithCoordinateX:middleX Y:middleY]];
}

- (void)privateEnqueue:(HSCoordinate*)point
{
    [self.bodyPositions addObject:point];
    HSCoordinate *tempPoint;
    for(HSCoordinate *space in self.emptySpace) {
        if (space.x == point.x && space.y == point.y) {
            tempPoint = space;
        }
    }
    [self.emptySpace removeObject:tempPoint];
}

- (void)_dequeue
{
    if (self.growthFactor > 0) {
        self.growthFactor -= 1;
        return;
    }
    id firstInObject = self.bodyPositions.firstObject;
    if (firstInObject) {
        [self.bodyPositions removeObjectAtIndex: 0];
        [self.emptySpace addObject:firstInObject];
    }
}

- (HSCoordinate*)privateGetNewHeadPosition
{
    HSCoordinate *oldHeadPoint = self.bodyPositions.lastObject;
    if (!oldHeadPoint) {
        return [[HSCoordinate alloc] initWithCoordinateX:0 Y:0];
    }
    NSInteger newX = oldHeadPoint.x;
    NSInteger newY = oldHeadPoint.y;
    switch (self.nextDirection) {
        case HSDirectionUp:
            newY += 1;
            newY = newY > self.wallPoint.y ? 0 : newY;
            self.movedDirection = HSDirectionUp;
            break;
        case HSDirectionDown:
            newY -= 1;
            newY = newY < 0 ? self.wallPoint.y : newY;
            self.movedDirection = HSDirectionDown;
            break;
        case HSDirectionLeft:
            newX -= 1;
            newX = newX < 0 ? self.wallPoint.x : newX;
            self.movedDirection = HSDirectionLeft;
            break;
        case HSDirectionRight:
            newX += 1;
            newX = newX > self.wallPoint.x ? 0 : newX;
            self.movedDirection = HSDirectionRight;
            break;
        default:
            break;
    }
    HSCoordinate *newHead = [[HSCoordinate alloc] initWithCoordinateX:newX Y:newY];
    return newHead;
}

#pragma mark -

- (void)setNextDirection:(enum HSDirection)nextDirection
{
    if (_movedDirection + nextDirection == 3) {
        return;
    }
    _nextDirection = nextDirection;
}

@end

