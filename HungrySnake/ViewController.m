//
//  ViewController.m
//  HungrySnake
//
//  Created by Tingwei Hsu on 2018/8/16.
//  Copyright © 2018年 Tingwei Hsu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self guestureSetup];
    [self gameSetup];
    [self gameViewSetup];
}

- (void)gameViewSetup {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    self.gameView = [[GameView alloc] initWithFrame:CGRectMake(0, 0, width, width/(self.gameField.x + 1) * (self.gameField.y + 1)) fieldFarestPoint: self.gameField snakeBodies:self.snake.bodyPositions foodPosition:self.food.location isCrashed:false];
    [self.view addSubview: self.gameView];
}

- (void)changeGameView {
    self.gameView.farestPoint = self.gameField;
    self.gameView.foodPosition = self.food.location;
    self.gameView.bodyPositions = self.snake.bodyPositions;
    self.gameView.isHeadCrashed = self.isCrashed;
    [self.gameView setNeedsDisplay];
}

- (void)guestureSetup {
    for (int i =0; i < 4; i++) {
        UISwipeGestureRecognizer *swipeGuesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
        [swipeGuesture setDirection: 1 << i];
        [self.view addGestureRecognizer:swipeGuesture];
    }
}

- (void)gameSetup {
    self.gameField = [[HSCoordinate alloc] initWithCoordinateX:10 withCoordinateY:13];
    self.snake = [[HSSnake alloc] initWithFieldSize:self.gameField];
    self.snake.delegate = self;
    self.food = [[HSFood alloc] initWithFieldSize:self.gameField];
    [self getAndDrawNewFood];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector: @selector(snakeMove) userInfo:nil repeats:YES];
}

- (void)handleSwipeFrom: (UISwipeGestureRecognizer *)recognizer {
    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        self.snake.movingDirection = right;
    }
    if (recognizer.direction == UISwipeGestureRecognizerDirectionUp) {
        self.snake.movingDirection = down;
    }
    if (recognizer.direction == UISwipeGestureRecognizerDirectionDown) {
        self.snake.movingDirection = up;
    }
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        self.snake.movingDirection = left;
    }
}

- (void)snakeMove {
    [self.snake movingAroundFood:self.food.location];
    [self changeGameView];
}

- (void)getAndDrawNewFood {
    [self.food generateNewFood];
    [self changeGameView];
}

- (void)gameStop {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)snakeStateDidEatFood:(BOOL)ateFood didCrashIntoBody:(BOOL)isCrashed {
    if (ateFood) {
        [self getAndDrawNewFood];
    }
    if (isCrashed) {
        self.isCrashed = isCrashed;
        [self changeGameView];
        [self gameStop];
    }
}

@end
