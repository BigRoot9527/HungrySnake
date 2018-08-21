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
@property (nonatomic) enum HSDirection movedDirection;
@property (nonatomic) NSInteger minimumLengh;
@end

@implementation HSSnake

- (id)initWithFieldSize:(HSCoordinate *)farestPoint
{
    self = [super init];
    if (self) {
        self.minimumLengh = 2;
        farestPoint.x = farestPoint.x >= self.minimumLengh ? farestPoint.x : self.minimumLengh;
        farestPoint.y = farestPoint.y >= self.minimumLengh ? farestPoint.y : self.minimumLengh;
        self.bodyPositions = [[NSMutableArray alloc] init];
        self.emptySpace = [[NSMutableArray alloc] init];
        self.wallPoint = farestPoint;
        self.nextDirection = left;
        for (int i = 0; i <= farestPoint.x; i++){
            for (int j = 0; j <= farestPoint.y ; j++) {
                [self.emptySpace addObject: [[HSCoordinate alloc] initWithCoordinateX:i withCoordinateY:j]];
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
        [self privateAteFoodOn:foodLocation];
    } else {
        [self privateMovedTo:newHead];
    }
}

- (void)privateMovedTo:(HSCoordinate *)location
{
    [self privateDequeue];
    BOOL isCrashIntoBody = [self privateCheckIfCrash:location];
    if (isCrashIntoBody) {
        [self.delegate snakeDidCrashIntoBody:true];
        return;
    }
    [self privateEnqueue:location];
}

- (BOOL)privateCheckIfCrash:(HSCoordinate *)location
{
    for (HSCoordinate *points in self.bodyPositions) {
        if (points.x == location.x && points.y == location.y) {
            return true;
        }
    }
    return false;
}

- (void)privateAteFoodOn:(HSCoordinate *)location
{
    [self privateEnqueue:location];
    [self.delegate snakeDidEatFoodWithEmptySpace:self.emptySpace];
}

- (void)privateSetupPositionWithWallPoint:(HSCoordinate*)point
{
    NSInteger middleX = point.x % 2 == 0 ? point.x / 2 : point.x / 2 + 1;
    NSInteger middleY = point.y % 2 == 0 ? point.y / 2 : point.y / 2 + 1;
    //initial tail
    [self privateEnqueue:[[HSCoordinate alloc] initWithCoordinateX:middleX+1 withCoordinateY:middleY]];
    //initail head
    [self privateEnqueue:[[HSCoordinate alloc] initWithCoordinateX:middleX withCoordinateY:middleY]];
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

- (void)privateDequeue
{
    id firstInObject = [self.bodyPositions objectAtIndex: 0];
    if ([firstInObject isKindOfClass:[HSCoordinate class]]) {
        [self.bodyPositions removeObjectAtIndex: 0];
    }
    [self.emptySpace addObject:firstInObject];
}

- (HSCoordinate*)privateGetNewHeadPosition
{
    if ([self.bodyPositions.lastObject isKindOfClass:[HSCoordinate class]]) {
        HSCoordinate *oldHeadPoint = self.bodyPositions.lastObject;
        HSCoordinate *newHead = [[HSCoordinate alloc] initWithCoordinateX:oldHeadPoint.x withCoordinateY:oldHeadPoint.y];
        switch (self.nextDirection) {
            case up:
                newHead.y += 1;
                newHead.y = newHead.y > self.wallPoint.y ? 0 : newHead.y;
                self.movedDirection = up;
                break;
            case down:
                newHead.y -= 1;
                newHead.y = newHead.y < 0 ? self.wallPoint.y : newHead.y;
                self.movedDirection = down;
                break;
            case left:
                newHead.x -= 1;
                newHead.x = newHead.x < 0 ? self.wallPoint.x : newHead.x;
                self.movedDirection = left;
                break;
            case right:
                newHead.x += 1;
                newHead.x = newHead.x > self.wallPoint.x ? 0 : newHead.x;
                self.movedDirection = right;
                break;
            default:
                break;
        }
        return newHead;
    }
    //error occurs here
    return [[HSCoordinate alloc] initWithCoordinateX:0 withCoordinateY:0];
}

- (void)setNextDirection:(enum HSDirection)nextDirection
{
    if (_movedDirection + nextDirection == 3) {
        //do nothing
    } else {
        _nextDirection = nextDirection;
    }
}

@end
