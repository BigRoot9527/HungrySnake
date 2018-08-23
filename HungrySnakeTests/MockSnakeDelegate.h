//
//  SpySnakeDelegate.h
//  HungrySnakeTests
//
//  Created by Tingwei Hsu on 2018/8/22.
//  Copyright © 2018年 Tingwei Hsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSCoordinate.h"
#import "HSSnake.h"

@interface MockSnakeDelegate : NSObject <HSSnakeDelegate>
@property (nonatomic) BOOL snakeDidCrashIntoBody;
@property (nonatomic, strong) HSCoordinate *snakeGainedHead;
@property (nonatomic, strong) HSCoordinate *snakeLostTail;
@property (nonatomic, strong) HSSnake *callingSnake;
@property (nonatomic) NSInteger headGainCount;
@property (nonatomic) NSInteger tailLostCount;
@end
