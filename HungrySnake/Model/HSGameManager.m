//
//  HSGameField.m
//  HungrySnake
//
//  Created by Tingwei Hsu on 2018/8/21.
//  Copyright © 2018年 Tingwei Hsu. All rights reserved.
//

#import "HSGameManager.h"
#import "HSSnake.h"
#import "HSFoodProvider.h"

@interface HSGameManager()
@property (nonatomic,strong) HSCoordinate *gameFildSize;
@property (nonatomic,strong) NSMutableArray *emptySpace;
@property (nonatomic,strong) HSSnake *snake;
@property (nonatomic,strong) HSFoodProvider *foodProvider;
@property (nonatomic) NSInteger score;
@property (nonatomic) BOOL snakeCrashed;
@property (nonatomic,strong) NSTimer *snakeTimer;
@end

@interface HSGameManager(HSSnakeDelegate)<HSSnakeDelegate>
@end

@implementation HSGameManager
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self _reset];
    }
    return self;
}

- (void)startNewGameWithFieldSize:(HSCoordinate *)farestPoint snakeSpeed:(NSInteger)speed
{
    //todo: parameter input error handle
    [self _reset];
    self.gameFildSize = [[HSCoordinate alloc] initWithCoordinateX:farestPoint.x -1 Y:farestPoint.y -1];
    for (NSInteger i = 0; i<=self.gameFildSize.x; i++) {
        for (NSInteger j=0; j<=self.gameFildSize.y; j++) {
            [self.emptySpace addObject: [[HSCoordinate alloc] initWithCoordinateX:i Y:j]];
        }
    }
    self.snake = [[HSSnake alloc] initWithGameField:self.gameFildSize];
    self.snake.delegate = self;
    [self.snake setup];
    [self.foodProvider generateNewFoodWithEmptySpace: [self.emptySpace copy]];
    self.snakeTimer = [NSTimer scheduledTimerWithTimeInterval:1-(0.09*speed) target:self selector: @selector(_moveSnake) userInfo:nil repeats:YES];
}

- (void)snakeDirectionControl:(HSDirection)direction
{
    [self.snake changeDirectionTo:direction];
}

- (NSArray <HSCoordinate*>*)getSnakeBody
{
    return [self.snake getBodyPosition];
}

- (HSCoordinate *)getFoodLocation
{
    return [self.foodProvider getFoodLocation];
}

- (HSCoordinate *)getFarestPoint
{
    return self.gameFildSize;
}

- (void)_gameStop
{
    if (self.snakeTimer) {
        [self.snakeTimer invalidate];
        self.snakeTimer = nil;
    }
}

- (void)_reset
{
    [self _gameStop];
    if (self.snake) {
        self.snake = nil;
    }
    self.foodProvider = [[HSFoodProvider alloc] init];
    self.emptySpace = [[NSMutableArray alloc] init];
    self.score = 0;
    self.gameFildSize = nil;
}

- (void)_moveSnake
{
    [self.snake move];
    [self.delegate gameDidupdate:self];
}


- (void)_snakeEatFood
{
    self.score += 1;
    [self.snake growth:2];
    if (![self.foodProvider generateNewFoodWithEmptySpace: [self.emptySpace copy]]) {
        [self _snakeWin];
    }
    [self.delegate gameDidupdate:self];
}

- (void)_snakeWin
{
    [self.delegate snakeDidWinTheGameInGame:self gotScore:self.score];
    [self _gameStop];
}
@end

@implementation HSGameManager(HSSnakeDelegate)

- (void)snakeDidCrashIntoBody:(HSSnake *)snake
{
    [self.delegate snakeDidCrashIntoBodyInGame:self gotScore:self.score];
    [self _gameStop];
}

- (void)snakeDidGainHeadOn:(HSCoordinate *)headPoint snake:(HSSnake *)snake
{
    HSCoordinate *tempPoint;
    for (HSCoordinate *point in self.emptySpace) {
        if(point.x == headPoint.x && point.y == headPoint.y) {
            tempPoint = point;
        }
    }
    [self.emptySpace removeObject:tempPoint];
    if (headPoint.x == [self.foodProvider getFoodLocation].x && headPoint.y == [self.foodProvider getFoodLocation].y) {
        [self _snakeEatFood];
    }
}

- (void)snakeDidLostTailOn:(HSCoordinate *)tailPoint snake:(HSSnake *)snake
{
    [self.emptySpace addObject:tailPoint];
}

- (void)snakeDidUpdateBody:(NSArray<HSCoordinate *> *)body snake:(HSSnake *)snake
{
    [self.delegate gameDidupdate:self];
}
@end
