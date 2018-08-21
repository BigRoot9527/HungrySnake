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

typedef NS_ENUM(NSInteger, HSDirection) {
    HSDirectionUp = 0,
    HSDirectionLeft,
    HSDirectionRight,
    HSDirectionDown
};

@interface HSSnake : NSObject
- (instancetype)initWithFieldSize:(HSCoordinate *)farestPoint;

@property (nonatomic) enum HSDirection nextDirection;
@property (nonatomic,weak) id<HSSnakeDelegate> delegate;

- (void)movingAroundFood:(HSCoordinate *)foodLocation;
@end
