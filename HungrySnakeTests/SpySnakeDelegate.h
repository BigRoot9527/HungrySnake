//
//  SpySnakeDelegate.h
//  HungrySnakeTests
//
//  Created by Tingwei Hsu on 2018/8/22.
//  Copyright © 2018年 Tingwei Hsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSCoordinate.h"

@interface SpySnakeDelegate : NSObject
@property (nonatomic) BOOL isDelegateCalled;
@property (nonatomic) BOOL snakeDidCrashIntoBody;
@property (nonatomic, strong) HSCoordinate *snakeGainedHead;
@property (nonatomic, strong) HSCoordinate *snakeLostTail;
@end
