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
    }
    return self;
}

- (void)setup
{
    [self _setupPositionWithWallPoint:self.wallPoint];
}

- (void)move
{
    HSCoordinate *newHead = [self _getNewHeadPosition];
    HSCoordinate *foodLocation = [self.dataSource foodLocationForSnake:self];
    if (newHead.x == foodLocation.x && newHead.y == foodLocation.y) {
        [self _ateFoodOn:foodLocation];
    } else {
        [self _movedTo:newHead];
    }
}

- (NSArray<HSCoordinate *> *)getBodyPosition
{
    return [self.bodyPositions copy];
}

#pragma mark - Private methods

- (void)_movedTo:(HSCoordinate *)location
{
    BOOL isCrashIntoBody = [self _checkIfCrash:location];
    if (isCrashIntoBody) {
        [self.delegate snakeDidCrashIntoBody:self];
        return;
    }
    [self _dequeue];
    [self _enqueue:location];
}

- (BOOL)_checkIfCrash:(HSCoordinate *)location
{
    //Tail (Fist Object) don't need check
    for (NSInteger i = 1; i < self.bodyPositions.count; i++) {
        HSCoordinate *point = self.bodyPositions[i];
        if (point.x == location.x && point.y == location.y) {
            return true;
        }
    }
    return false;
}

- (void)_ateFoodOn:(HSCoordinate *)location
{
    self.growthCount += 1;
    [self _enqueue:location];
    [self.delegate snakeDidEatFood:self];
}

- (void)_setupPositionWithWallPoint:(HSCoordinate*)point
{
    NSInteger middleX = point.x % 2 == 0 ? point.x / 2 : point.x / 2 + 1;
    NSInteger middleY = point.y % 2 == 0 ? point.y / 2 : point.y / 2 + 1;
    //initial tail
    [self _enqueue:[[HSCoordinate alloc] initWithCoordinateX:middleX+1 Y:middleY]];
    //initail head
    [self _enqueue:[[HSCoordinate alloc] initWithCoordinateX:middleX Y:middleY]];
}

- (void)_enqueue:(HSCoordinate*)point
{
    [self.delegate snakeDidGainHeadOn:point snake:self];
    [self.bodyPositions addObject:point];
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

- (HSCoordinate*)_getNewHeadPosition
{
    HSCoordinate *oldHeadPoint = self.bodyPositions.lastObject;
    if (!oldHeadPoint) {
        return [[HSCoordinate alloc] initWithCoordinateX:0 Y:0];
    }
    NSInteger newX = oldHeadPoint.x;
    NSInteger newY = oldHeadPoint.y;
    HSDirection nextDirection = [self _getNextDirection];
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

- (HSDirection)_getNextDirection
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

