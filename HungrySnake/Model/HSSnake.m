//
//  HSSnake.m
//  HungrySnake
//
//  Created by Tingwei Hsu on 2018/8/16.
//  Copyright © 2018年 Tingwei Hsu. All rights reserved.
//

#import "HSSnake.h"

@interface HSSnake()
@property (nonatomic,strong) HSCoordinate *wallPoint;
@property (nonatomic) enum HSDirection oldDirection;
@property (nonatomic,strong) NSMutableArray *bodyPositions;
@property (nonatomic) NSInteger growthCount;
@end

@implementation HSSnake

- (instancetype)initWithGameField:(HSCoordinate *)farestPoint
{
    self = [super init];
    if (self) {
        self.bodyPositions = [[NSMutableArray alloc] init];
        self.wallPoint = farestPoint;
        self.oldDirection = 0;
        self.growthCount = 0;
        [self privateSetupPositionWithWallPoint:self.wallPoint];
    }
    return self;
}

- (void)move
{
    HSCoordinate *newHead = [self privateGetNewHeadPosition];
    HSCoordinate *foodLocation = [self.dataSource foodLocationForSnake:self];
    if (newHead.x == foodLocation.x && newHead.y == foodLocation.y) {
        [self _ateFoodOn:foodLocation];
    } else {
        [self _movedTo:newHead];
    }
    [self.delegate snakeDidUpdateBody:[self.bodyPositions copy] snake:self];
}

#pragma mark - Private methods

- (void)_movedTo:(HSCoordinate *)location
{
    [self _dequeue];
    BOOL isCrashIntoBody = [self _checkIfCrash:location];
    if (isCrashIntoBody) {
        [self.delegate snakeDidCrashIntoBody:self];
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
    self.growthCount += 1;
    [self privateEnqueue:location];
    [self.delegate snakeDidEatFood:self];
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
    [self.delegate snakeDidGainHeadOn:point snake:self];
}

- (void)_dequeue
{
    if (self.growthCount > 0) {
        self.growthCount -= 1;
        return;
    }
    HSCoordinate *firstInObject = self.bodyPositions.firstObject;
    if (firstInObject) {
        [self.bodyPositions removeObjectAtIndex: 0];
        [self.delegate snakeDidLostTailOn:firstInObject snake:self];
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
    HSDirection nextDirection = [self privateGetNextDirection];
    switch (nextDirection) {
        case HSDirectionUp:
            newY += 1;
            newY = newY > self.wallPoint.y ? 0 : newY;
            self.oldDirection = HSDirectionUp;
            break;
        case HSDirectionDown:
            newY -= 1;
            newY = newY < 0 ? self.wallPoint.y : newY;
            self.oldDirection = HSDirectionDown;
            break;
        case HSDirectionLeft:
            newX -= 1;
            newX = newX < 0 ? self.wallPoint.x : newX;
            self.oldDirection = HSDirectionLeft;
            break;
        case HSDirectionRight:
            newX += 1;
            newX = newX > self.wallPoint.x ? 0 : newX;
            self.oldDirection = HSDirectionRight;
            break;
        default:
            break;
    }
    HSCoordinate *newHead = [[HSCoordinate alloc] initWithCoordinateX:newX Y:newY];
    return newHead;
}

- (HSDirection)privateGetNextDirection
{
    //initial
    if (self.oldDirection == 0) {
        return HSDirectionLeft;
    }
    
    HSDirection newDirection = [self.dataSource userDirectionForSnake:self];
    if (self.oldDirection + newDirection == 5) {
        return self.oldDirection;
    }
    return newDirection;
}
@end

