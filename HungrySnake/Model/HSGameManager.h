//
//  HSGameField.h
//  HungrySnake
//
//  Created by Tingwei Hsu on 2018/8/21.
//  Copyright © 2018年 Tingwei Hsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSCoordinate.h"
#import "HSDirection.h"

@class HSGameManager;

@protocol HSGameManagerDelegate
- (void)gameDidupdate: (HSGameManager *)manager;
- (void)snakeDidCrashIntoBodyInGame: (HSGameManager *)manager gotScore:(NSInteger)score;
- (void)snakeDidWinTheGameInGame: (HSGameManager *)manager gotScore:(NSInteger)score;
@end

@interface HSGameManager : NSObject
@property (nonatomic,weak) id<HSGameManagerDelegate> delegate;
- (void)startNewGameWithFieldSize:(HSCoordinate *)farestPoint snakeSpeed:(NSInteger)speed;
- (void)snakeDirectionControl:(HSDirection)direction;
- (NSArray <HSCoordinate*>*)getSnakeBody;
- (HSCoordinate *)getFoodLocation;
- (HSCoordinate *)getFarestPoint;
@end
