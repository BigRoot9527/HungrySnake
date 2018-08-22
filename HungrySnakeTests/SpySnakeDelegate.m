//
//  SpySnakeDelegate.m
//  HungrySnakeTests
//
//  Created by Tingwei Hsu on 2018/8/22.
//  Copyright © 2018年 Tingwei Hsu. All rights reserved.
//

#import "SpySnakeDelegate.h"
#import "HSSnake.h"

@interface SpySnakeDelegate(HSSnakeDelegate)<HSSnakeDelegate>
@end

@implementation SpySnakeDelegate

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isDelegateCalled = NO;
        self.snakeDidCrashIntoBody = NO;
        self.snakeGainedHead = nil;
        self.snakeLostTail = nil;
    }
    return self;
}
@end

@implementation SpySnakeDelegate(HSSnakeDelegate)

- (void)snakeDidCrashIntoBody:(HSSnake *)snake {
    self.isDelegateCalled = YES;
    self.snakeDidCrashIntoBody = YES;
}

- (void)snakeDidGainHeadOn:(HSCoordinate *)headPoint snake:(HSSnake *)snake {
    self.isDelegateCalled = YES;
    self.snakeGainedHead = headPoint;
}

- (void)snakeDidLostTailOn:(HSCoordinate *)tailPoint snake:(HSSnake *)snake {
    self.isDelegateCalled = YES;
    self.snakeLostTail = tailPoint;
}

@end

