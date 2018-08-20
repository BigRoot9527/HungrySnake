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
@end

@implementation HSSnake

-(id)initWithFieldSize:(HSCoordinate *)farestPoint {
    self = [super init];
    if (self) {
        farestPoint.x = farestPoint.x >= 2 ? farestPoint.x : 2;
        farestPoint.y = farestPoint.y >= 2 ? farestPoint.y : 2;
        self.bodyPositions = [[NSMutableArray alloc] init];
        self.wallPoint = farestPoint;
        self.movingDirection = left;
        [self privateSetupPositionWithWallPoint:self.wallPoint];
    }
    return self;
}

-(void)movingAroundFood:(HSCoordinate *)foodLocation {
    HSCoordinate *newHead = [self privateGetNewHeadPosition];
    if (newHead.x == foodLocation.x && newHead.y == foodLocation.y) {
        [self privateAteFoodOn:foodLocation];
    } else {
        [self privateMovedTo:newHead];
    }
}

-(void)privateMovedTo:(HSCoordinate *)location {
    [self privateDequeue];
    BOOL isCrashIntoBody = [self privateCheckIfCrash:location];
    if (isCrashIntoBody) {
        [self.delegate snakeStateDidEatFood:false didCrashIntoBody:true];
        return;
    }
    [self privateEnqueue:location];
}

-(BOOL)privateCheckIfCrash:(HSCoordinate *)location {
    for (HSCoordinate *points in self.bodyPositions) {
        if (points.x == location.x && points.y == location.y) {
            return true;
        }
    }
    return false;
}

-(void)privateAteFoodOn:(HSCoordinate *)location {
    BOOL isCrashIntoBody = [self.bodyPositions containsObject:location];
    [self privateEnqueue:location];
    [self.delegate snakeStateDidEatFood:true didCrashIntoBody:isCrashIntoBody];
}

-(void)privateSetupPositionWithWallPoint:(HSCoordinate*)point {
    NSInteger middleX = point.x % 2 == 0 ? point.x / 2 : point.x / 2 + 1;
    NSInteger middleY = point.y % 2 == 0 ? point.y / 2 : point.y / 2 + 1;
    //initial tail
    [self privateEnqueue:[[HSCoordinate alloc] initWithCoordinateX:middleX+1 withCoordinateY:middleY]];
    //initail head
    [self privateEnqueue:[[HSCoordinate alloc] initWithCoordinateX:middleX withCoordinateY:middleY]];
}

-(void)privateEnqueue:(HSCoordinate*)point {
    [self.bodyPositions addObject:point];
}

-(void)privateDequeue{
    id firstInObject = [self.bodyPositions objectAtIndex: 0];
    if ([firstInObject isKindOfClass:[HSCoordinate class]]) {
        [self.bodyPositions removeObjectAtIndex: 0];
    }
}

-(HSCoordinate*)privateGetNewHeadPosition {
    if ([self.bodyPositions.lastObject isKindOfClass:[HSCoordinate class]]) {
        HSCoordinate *oldHeadPoint = self.bodyPositions.lastObject;
        HSCoordinate *newHead = [[HSCoordinate alloc] initWithCoordinateX:oldHeadPoint.x withCoordinateY:oldHeadPoint.y];
        switch (self.movingDirection) {
            case up:
                newHead.y += 1;
                newHead.y = newHead.y > self.wallPoint.y ? 0 : newHead.y;
                break;
            case down:
                newHead.y -= 1;
                newHead.y = newHead.y < 0 ? self.wallPoint.y : newHead.y;
                break;
            case left:
                newHead.x -= 1;
                newHead.x = newHead.x < 0 ? self.wallPoint.x : newHead.x;
                break;
            case right:
                newHead.x += 1;
                newHead.x = newHead.x > self.wallPoint.x ? 0 : newHead.x;
                break;
            default:
                break;
        }
        return newHead;
    }
    //error occurs here
    return [[HSCoordinate alloc] initWithCoordinateX:0 withCoordinateY:0];
}

-(void)setMovingDirection:(enum HSDirection)movingDirection {
    
    if (_movingDirection + movingDirection == 3) {
        //do nothing
    } else {
        _movingDirection = movingDirection;
    }
}

@end
