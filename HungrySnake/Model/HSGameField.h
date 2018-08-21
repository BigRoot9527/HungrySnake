//
//  HSGameField.h
//  HungrySnake
//
//  Created by Tingwei Hsu on 2018/8/21.
//  Copyright © 2018年 Tingwei Hsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSCoordinate.h"

@class HSGameField;

@protocol HSGameFieldDelegate
- (void)snakeDidEatFoodInGameField: (HSGameField *)gameField;
- (void)snakeDidCrashIntoBodyInGameField: (HSGameField *)gameField;
- (void)snakeDidWinTheGameInGameField: (HSGameField *)gameField;
@end

@interface HSGameField : NSObject
- (instancetype)initWithFieldSize:(HSCoordinate *)farestPoint;
@end
