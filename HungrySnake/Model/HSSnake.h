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
@end

@interface HSSnake : NSObject
@property (nonatomic,weak) id<HSSnakeDelegate> delegate;
- (instancetype)initWithGameField:(HSCoordinate *)farestPoint;
- (void)changeDirectionTo:(HSDirection)direction;
- (void)setup;
- (void)move;
- (void)growth:(NSUInteger)count;
- (NSArray<HSCoordinate *> *)getBodyPosition;
@end
