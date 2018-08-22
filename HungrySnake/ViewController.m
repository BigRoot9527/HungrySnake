//
//  ViewController.m
//  HungrySnake
//
//  Created by Tingwei Hsu on 2018/8/16.
//  Copyright © 2018年 Tingwei Hsu. All rights reserved.
//

#import "ViewController.h"
#import "GameView.h"
#import "HSGameManager.h"

@interface ViewController ()
@property (nonatomic) NSInteger gameFieldXParameter;
@property (nonatomic) NSInteger gameFieldYParameter;
@property (nonatomic) NSInteger gameSnakeSpeedParameter;
@property (nonatomic,strong) GameView *gameView;
@property (nonatomic,strong) HSGameManager *gameManager;
@property (nonatomic) NSInteger velocityThreshold;
@end

@interface ViewController(GameViewDelegate) <GameViewDelegate>
@end

@interface ViewController(HSGameManagerDelegate)<HSGameManagerDelegate>
@end

@implementation ViewController
typedef NS_ENUM(NSUInteger, SettingParameter) {
    gameFieldX,
    gameFieldY,
    snakeSpeed
};

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupGestures];
    self.gameManager = [[HSGameManager alloc] init];
    self.gameManager.delegate = self;
    _velocityThreshold = 250;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self askInputForGameParameter:gameFieldX];
}

- (void)setupGestures
{
    UIPanGestureRecognizer *panGuesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [self.view addGestureRecognizer:panGuesture];
}

- (void)askInputForGameParameter:(SettingParameter)paramter
{
    NSString *displayString = @"";
    switch (paramter) {
        case gameFieldX:
            displayString = @"Please input X range(int 3-20)";
            break;
        case gameFieldY:
            displayString = @"Please input Y range(int 3-20)";
            break;
        case snakeSpeed:
            displayString = @"Please input Snake Speed (int 1-10)";
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Setup Game" message:displayString preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"Enter" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        switch (paramter) {
            case gameFieldX:
                if ([alert.textFields[0].text integerValue] >= 3 && [alert.textFields[0].text integerValue] <= 20) {
                    self.gameFieldXParameter = [alert.textFields[0].text integerValue];
                    [self askInputForGameParameter:gameFieldY];
                } else {
                    [self showErrorForParameter:gameFieldX];
                }
                break;
            case gameFieldY:
                if ([alert.textFields[0].text integerValue] >= 3 && [alert.textFields[0].text integerValue] <= 20) {
                    self.gameFieldYParameter = [alert.textFields[0].text integerValue];
                    [self askInputForGameParameter:snakeSpeed];
                } else {
                    [self showErrorForParameter:gameFieldY];
                }
                break;
            case snakeSpeed:
                if ([alert.textFields[0].text integerValue] >= 1 && [alert.textFields[0].text integerValue] <= 10) {
                    self.gameSnakeSpeedParameter = [alert.textFields[0].text integerValue];
                    [self.gameManager startNewGameWithFieldSize:[[HSCoordinate alloc] initWithCoordinateX:self.gameFieldXParameter Y:self.gameFieldYParameter] snakeSpeed:self.gameSnakeSpeedParameter];
                    [self setupGameView];
                } else {
                    [self showErrorForParameter:snakeSpeed];
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
        case snakeSpeed:
            errorMessage = @"invalid snakeSpeed (int 1~10)";
    }
    
    UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"OOOPS!" message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
    [errorAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self askInputForGameParameter:paramter];
    }]];
    [self presentViewController:errorAlert animated:YES completion:nil];
}

- (void)setupGameView
{
    CGFloat widthPadding = 20;
    CGFloat heightPadding = 20;
    CGFloat maxWidth = self.view.bounds.size.width - (widthPadding * 2);
    CGFloat maxHeight = self.view.bounds.size.height - (heightPadding * 2);
    float gamefieldRate = self.gameFieldXParameter / self.gameFieldYParameter;
    float maxRate = maxWidth / maxHeight;
    CGRect displayRect;
    if (gamefieldRate > maxRate) {
        displayRect = CGRectMake(widthPadding, heightPadding+(maxHeight-(maxWidth / self.gameFieldXParameter * self.gameFieldYParameter))/2, maxWidth, (maxWidth / self.gameFieldXParameter) * self.gameFieldYParameter);
    } else if (gamefieldRate < maxRate) {
        displayRect = CGRectMake(widthPadding+(maxWidth-(maxHeight / self.gameFieldYParameter * self.gameFieldXParameter))/2, heightPadding, (maxHeight / self.gameFieldYParameter) * self.gameFieldXParameter, maxHeight);
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

- (void)handleGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint velocity = [gestureRecognizer velocityInView:self.view];
    
    if(velocity.x > _velocityThreshold)
    {
        [self.gameManager snakeDirectionControl:HSDirectionRight];
    }
    
    if(velocity.x < -_velocityThreshold)
    {
        [self.gameManager snakeDirectionControl:HSDirectionLeft];
    }
    
    if(velocity.y > _velocityThreshold)
    {
        [self.gameManager snakeDirectionControl:HSDirectionUp];
    }
    
    if(velocity.y < -_velocityThreshold)
    {
        [self.gameManager snakeDirectionControl:HSDirectionDown];
    }
}
@end

@implementation ViewController (HSGameManagerDelegate)
- (void)gameDidupdate:(HSGameManager *)manager
{
    [self.gameView setNeedsDisplay];
}

- (void)snakeDidCrashIntoBodyInGame:(HSGameManager *)manager gotScore:(NSInteger)score
{
    self.gameView.isCrashMode = YES;
    [self showGameOverAlertIsWin:NO getScore:score];
}

- (void)snakeDidWinTheGameInGame:(HSGameManager *)manager gotScore:(NSInteger)score
{
    [self showGameOverAlertIsWin:YES getScore:score];
}

- (void)showGameOverAlertIsWin:(BOOL)isWin getScore:(NSInteger)score
{
    UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:(isWin ? @"You Win!" : @"Game Over") message:[NSString stringWithFormat:@"Score:%lu", score] preferredStyle:UIAlertControllerStyleAlert];
    [errorAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self askInputForGameParameter:gameFieldX];
        [self.gameView removeFromSuperview];
    }]];
    [self presentViewController:errorAlert animated:YES completion:nil];
}
@end

@implementation ViewController (GameViewDelegate)
- (HSCoordinate *)farestPointForView:(GameView *)view
{
    return [self.gameManager getFarestPoint];
}

- (HSCoordinate *)foodPositionForView:(GameView *)view
{
    return [self.gameManager getFoodLocation];
}

- (NSArray<HSCoordinate *> *)snakeBodyForView:(GameView *)view
{
    return [self.gameManager getSnakeBody];
}
@end

