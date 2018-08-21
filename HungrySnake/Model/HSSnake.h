//
//  HSSnake.h
//  HungrySnake
//
//  Created by Tingwei Hsu on 2018/8/16.
//  Copyright © 2018年 Tingwei Hsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSCoordinate.h"

typedef NS_ENUM(NSInteger, HSDirection) {
    HSDirectionUp = 1,
    HSDirectionLeft = 2,
    HSDirectionRight = 3,
    HSDirectionDown = 4
};

@class HSSnake;

@protocol HSSnakeDelegate
- (void)snakeDidGainHeadOn:(HSCoordinate *)headPoint snake:(HSSnake *)snake;
- (void)snakeDidLostTailOn:(HSCoordinate *)tailPoint snake:(HSSnake *)snake;
- (void)snakeDidCrashIntoBody:(HSSnake *)snake;
- (void)snakeDidEatFood:(HSSnake *)snake;
- (void)snakeDidUpdateBody:(NSArray<HSCoordinate *> *)body snake:(HSSnake *)snake;
@end

@protocol HSSnakeDataSource
- (HSDirection)userDirectionForSnake:(HSSnake *)snake;
- (HSCoordinate *)foodLocationForSnake:(HSSnake *)snake;
@end

@interface HSSnake : NSObject
- (instancetype)initWithGameField:(HSCoordinate *)farestPoint;
@property (nonatomic,weak) id<HSSnakeDelegate> delegate;
@property (nonatomic,weak) id<HSSnakeDataSource> dataSource;
- (void)move;

@end
