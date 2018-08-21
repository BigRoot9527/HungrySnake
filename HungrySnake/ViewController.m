//
//  ViewController.m
//  HungrySnake
//
//  Created by Tingwei Hsu on 2018/8/16.
//  Copyright © 2018年 Tingwei Hsu. All rights reserved.
//

#import "ViewController.h"
#import "HSSnake.h"
#import "HSFood.h"
#import "GameView.h"

@interface ViewController () <HSSnakeDelegate>
@property (nonatomic,strong) HSCoordinate *gameField;
@property (nonatomic,strong) HSSnake *snake;
@property (nonatomic,strong) HSFood *food;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) GameView *gameView;
@property (nonatomic, assign) BOOL isHeadCrashed;
@property (nonatomic) NSInteger score;
@property (nonatomic) NSInteger velocityThreshold;
@end

@interface ViewController(GameViewDelegate) <GameViewDelegate>
@end

@interface HSCoordinate (Private)
@property (nonatomic) NSInteger x;
@property (nonatomic) NSInteger y;
@end


@implementation ViewController

typedef NS_ENUM(NSUInteger, SettingParameter) {
    gameFieldX,
    gameFieldY,
};

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupGestures];
    self.gameField = [[HSCoordinate alloc] init];
    _velocityThreshold = 250;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self askInputForParameter:gameFieldX];
}

- (void)setupGestures
{
    UIPanGestureRecognizer *panGuesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [self.view addGestureRecognizer:panGuesture];
}

- (void)askInputForParameter:(SettingParameter)paramter
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
                    [self askInputForParameter:gameFieldY];
                } else {
                    [self showErrorForParameter:gameFieldX];
                }
                break;
            case gameFieldY:
                if ([alert.textFields[0].text integerValue] >= 3 && [alert.textFields[0].text integerValue] <= 20) {
                    self.gameField.y = [alert.textFields[0].text integerValue] - 1;
                    [self setupGame];
                    [self setupGameView];
                } else {
                    [self showErrorForParameter:gameFieldY];
                }
                break;
        }
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showErrorForParameter:(SettingParameter)paramter
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
        [self askInputForParameter:paramter];
    }]];
    [self presentViewController:errorAlert animated:YES completion:nil];
}

- (void)setupGame
{
    self.score = 0;
    self.snake = [[HSSnake alloc] initWithFieldSize:self.gameField];
    self.snake.delegate = self;
    self.food = [[HSFood alloc] initWithFieldSize:self.gameField];
    [self getAndDrawNewFoodWithEmptySpace:self.snake.emptySpace];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.14 target:self selector: @selector(snakeMove) userInfo:nil repeats:YES];
}

- (void)setupGameView
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
    
    if (self.gameView) {
        [self.gameView removeFromSuperview];
        self.gameView = nil;
    }
    
    self.gameView = [[GameView alloc] initWithFrame:displayRect];
    self.gameView.delegate = self;
    [self.view addSubview: self.gameView];
}

- (void)snakeMove
{
    [self.snake movingAroundFood:self.food.location];
    [self changeGameView];
}

- (void)changeGameView
{
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
    
    UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:(isWin ? @"You Win!" : @"Game Over") message:[NSString stringWithFormat:@"Score:%lu", self.score] preferredStyle:UIAlertControllerStyleAlert];
    [errorAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self askInputForParameter:gameFieldX];
        [self.gameView removeFromSuperview];
    }]];
    [self presentViewController:errorAlert animated:YES completion:nil];
}

- (void)handleGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint velocity = [gestureRecognizer velocityInView:self.view];
    
    if(velocity.x > _velocityThreshold)
    {
        self.snake.nextDirection = HSDirectionRight;
    }
    
    if(velocity.x < -_velocityThreshold)
    {
        self.snake.nextDirection = HSDirectionLeft;
    }
    
    if(velocity.y > _velocityThreshold)
    {
        self.snake.nextDirection = HSDirectionUp;
    }
    
    if(velocity.y < -_velocityThreshold)
    {
        self.snake.nextDirection = HSDirectionDown;
    }
}

- (void)snakeDidCrashIntoBody:(BOOL)isCrashed {
    if (isCrashed) {
        self.isHeadCrashed = isCrashed;
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


@implementation ViewController (GameViewDelegate)
- (HSCoordinate *)farestPointForView:(GameView *)view {
    return self.gameField;
}

- (HSCoordinate *)foodPositionForView:(GameView *)view {
    return self.food.location;
}

- (BOOL)isHeadCrashForView:(GameView *)view {
    return self.isHeadCrashed;
}

- (NSArray<HSCoordinate *> *)snakeBodyForView:(GameView *)view {
    return self.snake.bodyPositions;
}

@end

