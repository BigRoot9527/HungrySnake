//
//  ViewController.h
//  HungrySnake
//
//  Created by Tingwei Hsu on 2018/8/16.
//  Copyright © 2018年 Tingwei Hsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSSnake.h"
#import "HSFood.h"
#import "GameView.h"

@interface ViewController : UIViewController<HSSnakeDelegate>

@property (nonatomic,strong) HSCoordinate *gameField;
@property (nonatomic,strong) HSSnake *snake;
@property (nonatomic,strong) HSFood *food;
@property (nonatomic) BOOL isCrashed;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) GameView *gameView;
@property (nonatomic) float snakeSpeed;

@end

