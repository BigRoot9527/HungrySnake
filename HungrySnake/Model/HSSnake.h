//
//  HSSnake.h
//  HungrySnake
//
//  Created by Tingwei Hsu on 2018/8/16.
//  Copyright © 2018年 Tingwei Hsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSCoordinate.h"
#import "HSDirection.h"

@class HSSnake;

@protocol HSSnakeDelegate
- (void)snakeDidGainHeadOn:(HSCoordinate *)headPoint snake:(HSSnake *)snake;
- (void)snakeDidLostTailOn:(HSCoordinate *)tailPoint snake:(HSSnake *)snake;
- (void)snakeDidCrashIntoBody:(HSSnake *)snake;
- (void)snakeDidEatFood:(HSSnake *)snake;
@end

@protocol HSSnakeDataSource
- (HSDirection)userDirectionForSnake:(HSSnake *)snake;
- (HSCoordinate *)foodLocationForSnake:(HSSnake *)snake;
@end

@interface HSSnake : NSObject
- (instancetype)initWithGameField:(HSCoordinate *)farestPoint;
@property (nonatomic,weak) id<HSSnakeDelegate> delegate;
@property (nonatomic,weak) id<HSSnakeDataSource> dataSource;
- (void)setup;
- (void)move;
- (NSArray<HSCoordinate *> *)getBodyPosition;
@end
