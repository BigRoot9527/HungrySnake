//
//  HSSnake.h
//  HungrySnake
//
//  Created by Tingwei Hsu on 2018/8/16.
//  Copyright © 2018年 Tingwei Hsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSCoordinate.h"

@class HSSnake;

@protocol HSSnakeDelegate
-(void) snakeDidEatFoodWithEmptySpace:(NSMutableArray *)emptySpace;
-(void) snakeDidCrashIntoBody:(BOOL)isCrashed;
@end

@interface HSSnake : NSObject
enum HSDirection {
    up = 0,
    left,
    right,
    down
};
@property (nonatomic,strong) NSMutableArray* bodyPositions;
@property (nonatomic,strong) NSMutableArray *emptySpace;
@property (nonatomic) enum HSDirection nextDirection;
@property (nonatomic,weak) id<HSSnakeDelegate> delegate;
-(id)initWithFieldSize:(HSCoordinate *)farestPoint;
-(void)movingAroundFood:(HSCoordinate *)foodLocation;
- (void)setNextDirection:(enum HSDirection)nextDirection;
@end
