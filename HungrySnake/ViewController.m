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
};

- (void)viewDidLoad {
    [super viewDidLoad];
    [self guestureSetup];
    self.gameField = [[HSCoordinate alloc] init];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self inputNewGameWith:gameFieldX];
}

- (void)guestureSetup {
    for (int i =0; i < 4; i++) {
        UISwipeGestureRecognizer *swipeGuesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
        [swipeGuesture setDirection: 1 << i];
        [self.view addGestureRecognizer:swipeGuesture];
    }
}

- (void)inputNewGameWith:(enum SettingParameter)paramter {
    NSString *displayString = @"";
    switch (paramter) {
        case gameFieldX:
            displayString = @"Please input X range(int 3-20)";
            break;
        case gameFieldY:
            displayString = @"Please input Y range(int 3-20)";
            break;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Setup Game" message:displayString preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"Enter" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        switch (paramter) {
            case gameFieldX:
                if ([alert.textFields[0].text integerValue] >= 3 && [alert.textFields[0].text integerValue] <= 20) {
                    self.gameField.x = [alert.textFields[0].text integerValue] - 1;
                    [self inputNewGameWith:gameFieldY];
                } else {
                    [self invalidAlertWithParameter:gameFieldX];
                }
                break;
            case gameFieldY:
                if ([alert.textFields[0].text integerValue] >= 3 && [alert.textFields[0].text integerValue] <= 20) {
                    self.gameField.y = [alert.textFields[0].text integerValue] - 1;
                    [self gameSetup];
                    [self gameViewSetup];
                } else {
                    [self invalidAlertWithParameter:gameFieldY];
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
            errorMessage = @"invalid gameFieldX (int 3~20)";
            break;
        case gameFieldY:
            errorMessage = @"invalid gameFieldY (int 3~20)";
            break;
    }
    
    UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"OOOPS!" message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
    [errorAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self inputNewGameWith:paramter];
    }]];
    [self presentViewController:errorAlert animated:YES completion:nil];
}

- (void)gameSetup {
    self.score = 0;
    self.gameView.isHeadCrashed = false;
    self.snake = [[HSSnake alloc] initWithFieldSize:self.gameField];
    self.snake.delegate = self;
    self.food = [[HSFood alloc] initWithFieldSize:self.gameField];
    [self getAndDrawNewFood];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.13 target:self selector: @selector(snakeMove) userInfo:nil repeats:YES];
}

- (void)gameViewSetup {
    CGFloat widthPadding = 20;
    CGFloat heightPadding = 20;
    CGFloat maxWidth = self.view.bounds.size.width - (widthPadding * 2);
    CGFloat maxHeight = self.view.bounds.size.height - (heightPadding * 2);
    float gamefieldRate = _gameField.x / _gameField.y;
    float maxRate = maxWidth / maxHeight;
    CGRect displayRect;
    if (gamefieldRate > maxRate) {
        displayRect = CGRectMake(widthPadding, heightPadding+(maxHeight-(maxWidth / _gameField.x) * _gameField.y)/2, maxWidth, (maxWidth / _gameField.x) * _gameField.y);
    } else if (gamefieldRate < maxRate) {
        displayRect = CGRectMake(widthPadding+(maxWidth-(maxHeight/_gameField.y)*_gameField.x)/2, heightPadding, (maxHeight / _gameField.y) * _gameField.x, maxHeight);
    } else {
        displayRect = CGRectMake(widthPadding, heightPadding, maxWidth, maxHeight);
    }
    self.gameView = [[GameView alloc] initWithFrame:displayRect fieldFarestPoint: self.gameField snakeBodies:self.snake.bodyPositions foodPosition:self.food.location isCrashed:false];
    [self.view addSubview: self.gameView];
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

- (void)changeGameView {
    self.gameView.foodPosition = self.food.location;
    self.gameView.bodyPositions = self.snake.bodyPositions;
    [self.gameView setNeedsDisplay];
}

- (void)getAndDrawNewFood {
    [self.food generateNewFood];
    [self changeGameView];
}

- (void)gameStop {
    [self.timer invalidate];
    self.timer = nil;
    
    UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Game Over" message:[NSString stringWithFormat:@"Score:%d",self.score] preferredStyle:UIAlertControllerStyleAlert];
    [errorAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self inputNewGameWith:gameFieldX];
        [self.gameView removeFromSuperview];
    }]];
    [self presentViewController:errorAlert animated:YES completion:nil];
}

- (void)snakeStateDidEatFood:(BOOL)ateFood didCrashIntoBody:(BOOL)isCrashed {
    if (ateFood) {
        [self getAndDrawNewFood];
        self.score += 1;
    }
    if (isCrashed) {
        self.gameView.isHeadCrashed = isCrashed;
        [self changeGameView];
        [self gameStop];
    }
}

@end
