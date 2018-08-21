//
//  ViewController.m
//  HungrySnake
//
//  Created by Tingwei Hsu on 2018/8/16.
//  Copyright © 2018年 Tingwei Hsu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic) int velocityThreshold;

@end

@implementation ViewController

enum SettingParameter {
    gameFieldX,
    gameFieldY,
};

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self guestureSetup];
    self.gameField = [[HSCoordinate alloc] init];
    _velocityThreshold = 250;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self inputNewGameWith:gameFieldX];
}

- (void)guestureSetup
{
    UIPanGestureRecognizer *panGuesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [self.view addGestureRecognizer:panGuesture];
}

- (void)inputNewGameWith:(enum SettingParameter)paramter
{
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

- (void)invalidAlertWithParameter:(enum SettingParameter)paramter
{
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

- (void)gameSetup
{
    self.score = 0;
    self.gameView.isHeadCrashed = false;
    self.snake = [[HSSnake alloc] initWithFieldSize:self.gameField];
    self.snake.delegate = self;
    self.food = [[HSFood alloc] initWithFieldSize:self.gameField];
    [self getAndDrawNewFoodWithEmptySpace:self.snake.emptySpace];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.14 target:self selector: @selector(snakeMove) userInfo:nil repeats:YES];
}

- (void)gameViewSetup
{
    CGFloat widthPadding = 20;
    CGFloat heightPadding = 20;
    CGFloat maxWidth = self.view.bounds.size.width - (widthPadding * 2);
    CGFloat maxHeight = self.view.bounds.size.height - (heightPadding * 2);
    NSInteger xLength = self.gameField.x + 1;
    NSInteger yLength = self.gameField.y + 1;
    float gamefieldRate = xLength / yLength;
    float maxRate = maxWidth / maxHeight;
    CGRect displayRect;
    if (gamefieldRate > maxRate) {
        displayRect = CGRectMake(widthPadding, heightPadding+(maxHeight-(maxWidth / xLength * yLength))/2, maxWidth, (maxWidth / xLength) * yLength);
    } else if (gamefieldRate < maxRate) {
        displayRect = CGRectMake(widthPadding+(maxWidth-(maxHeight / yLength * xLength))/2, heightPadding, (maxHeight / yLength) * xLength, maxHeight);
    } else {
        displayRect = CGRectMake(widthPadding, heightPadding, maxWidth, maxHeight);
    }
    self.gameView = [[GameView alloc] initWithFrame:displayRect fieldFarestPoint: self.gameField snakeBodies:self.snake.bodyPositions foodPosition:self.food.location isCrashed:false];
    [self.view addSubview: self.gameView];
}

- (void)snakeMove
{
    [self.snake movingAroundFood:self.food.location];
    [self changeGameView];
}

- (void)changeGameView
{
    self.gameView.foodPosition = self.food.location;
    self.gameView.bodyPositions = self.snake.bodyPositions;
    [self.gameView setNeedsDisplay];
}

- (void)getAndDrawNewFoodWithEmptySpace:(NSMutableArray*)space
{
    [self.food generateNewFoodWithEmptySpace:space];
    [self changeGameView];
}

- (void)gameStopOnWin:(BOOL)isWin
{
    [self.timer invalidate];
    self.timer = nil;
    
    UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:(isWin ? @"You Win!" : @"Game Over") message:[NSString stringWithFormat:@"Score:%d",self.score] preferredStyle:UIAlertControllerStyleAlert];
    [errorAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self inputNewGameWith:gameFieldX];
        [self.gameView removeFromSuperview];
    }]];
    [self presentViewController:errorAlert animated:YES completion:nil];
}

- (void)handleGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint velocity = [gestureRecognizer velocityInView:self.view];
    
    if(velocity.x > _velocityThreshold)
    {
        self.snake.nextDirection = right;
    }
    
    if(velocity.x < -_velocityThreshold)
    {
        self.snake.nextDirection = left;
    }
    
    if(velocity.y > _velocityThreshold)
    {
        self.snake.nextDirection = up;
    }
    
    if(velocity.y < -_velocityThreshold)
    {
        self.snake.nextDirection = down;
    }
}

- (void)snakeDidCrashIntoBody:(BOOL)isCrashed {
    if (isCrashed) {
        self.gameView.isHeadCrashed = isCrashed;
        [self changeGameView];
        [self gameStopOnWin:false];
    }
}

- (void)snakeDidEatFoodWithEmptySpace:(NSMutableArray *)emptySpace {
    self.score += 1;
    NSLog(@"space.count = %lu",[emptySpace count]);
    if ([emptySpace count] == 0) {
        [self gameStopOnWin:true];
    } else {
        [self getAndDrawNewFoodWithEmptySpace:emptySpace];
    }
}
@end
