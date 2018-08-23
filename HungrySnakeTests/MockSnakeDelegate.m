//
//  SpySnakeDelegate.m
//  HungrySnakeTests
//
//  Created by Tingwei Hsu on 2018/8/22.
//  Copyright © 2018年 Tingwei Hsu. All rights reserved.
//

#import "MockSnakeDelegate.h"

@implementation MockSnakeDelegate

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.callingSnake = nil;
        self.snakeDidCrashIntoBody = NO;
        self.snakeGainedHead = nil;
        self.snakeLostTail = nil;
        self.headGainCount = 0;
        self.tailLostCount = 0;
    }
    return self;
}

- (void)snakeDidCrashIntoBody:(HSSnake *)snake
{
    self.callingSnake = self.callingSnake == nil ? snake : self.callingSnake == snake ? snake : [[HSSnake alloc] init];
    self.snakeDidCrashIntoBody = YES;
}

- (void)snakeDidGainHeadOn:(HSCoordinate *)headPoint snake:(HSSnake *)snake
{
    self.callingSnake = self.callingSnake == nil ? snake : self.callingSnake == snake ? snake : [[HSSnake alloc] init];
    self.snakeGainedHead = headPoint;
    self.headGainCount += 1;
}

- (void)snakeDidLostTailOn:(HSCoordinate *)tailPoint snake:(HSSnake *)snake
{
    self.callingSnake = self.callingSnake == nil ? snake : self.callingSnake == snake ? snake : [[HSSnake alloc] init];
    self.snakeLostTail = tailPoint;
    self.tailLostCount += 1;
}
@end

