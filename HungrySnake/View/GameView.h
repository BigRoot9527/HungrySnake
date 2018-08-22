//
//  GameView.h
//  HungrySnake
//
//  Created by Tingwei Hsu on 2018/8/17.
//  Copyright © 2018年 Tingwei Hsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSCoordinate.h"

@class GameView;
@protocol GameViewDelegate
- (HSCoordinate *)farestPointForView:(GameView *)view;
- (NSArray<HSCoordinate *> *)snakeBodyForView:(GameView *)view;
- (HSCoordinate *)foodPositionForView:(GameView *)view;
@end

@interface GameView : UIView
@property (nonatomic, weak) id<GameViewDelegate> delegate;
@property (nonatomic) BOOL isCrashMode;
@end
