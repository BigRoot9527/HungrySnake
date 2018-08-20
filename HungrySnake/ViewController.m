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

enum SettingParameter {
    gameFieldX,
    gameFieldY,
    snakeSpeed
};

- (void)viewDidLoad {
    [super viewDidLoad];
    [self guestureSetup];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self inputNewGameWith:gameFieldX];
}

- (void)inputNewGameWith:(enum SettingParameter)paramter {
    
    NSString *displayString = @"";
    
    switch (paramter) {
        case gameFieldX:
            displayString = @"Please input X range(int 1-20)";
            break;
        case gameFieldY:
            displayString = @"Please input Y range(int 1-20)";
            break;
        default:
            displayString = @"Please input Snake Speed(float 1-10)";
            break;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Setup Game" message:displayString preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"Enter" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        switch (paramter) {
            case gameFieldX:
                if ([alert.textFields[0].text integerValue] >= 1 && [alert.textFields[0].text integerValue] <= 20) {
                    self.gameField.x = [alert.textFields[0].text integerValue];
                    [self inputNewGameWith:gameFieldY];
                } else {
                    [self invalidAlertWithParameter:gameFieldX];
                }
                break;
            case gameFieldY:
                if ([alert.textFields[0].text integerValue] >= 1 && [alert.textFields[0].text integerValue] <= 20) {
                    self.gameField.y = [alert.textFields[0].text integerValue];
                    [self inputNewGameWith:snakeSpeed];
                } else {
                    [self invalidAlertWithParameter:gameFieldY];
                }
                break;
            case snakeSpeed:
                if ([alert.textFields[0].text floatValue] >= 1 && [alert.textFields[0].text floatValue] <= 10) {
                    self.snakeSpeed = [alert.textFields[0].text floatValue];
                    [self gameSetup];
                    [self gameViewSetup];
                } else {
                    [self invalidAlertWithParameter:snakeSpeed];
                }
                break;
        }
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)invalidAlertWithParameter:(enum SettingParameter)paramter {
    NSString *errorMessage = @"";
    switch (paramter) {
        case gameFieldX:
            errorMessage = @"invalid gameFieldX (int 1~20)";
            break;
        case gameFieldY:
            errorMessage = @"invalid gameFieldY (int 1~20)";
            break;
        case snakeSpeed:
            errorMessage = @"invalid snakeSpeed (float 1~10)";
            break;
    }
    
    UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"OOOPS!" message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
    [errorAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self inputNewGameWith:paramter];
    }]];
    [self presentViewController:errorAlert animated:YES completion:nil];
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
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1/snakeSpeed target:self selector: @selector(snakeMove) userInfo:nil repeats:YES];
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
