//
//  GameView.h
//  HungrySnake
//
//  Created by Tingwei Hsu on 2018/8/17.
//  Copyright © 2018年 Tingwei Hsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSCoordinate.h"

@interface GameView : UIView

@property (nonatomic, strong) HSCoordinate *farestPoint;
@property (nonatomic, strong) NSMutableArray *bodyPositions;
@property (nonatomic, strong) HSCoordinate *foodPosition;
@property (nonatomic) BOOL isHeadCrashed;

- (instancetype)initWithFrame:(CGRect)frame fieldFarestPoint:(HSCoordinate *)farestPoint snakeBodies:(NSMutableArray *)bodies foodPosition:(HSCoordinate *)food isCrashed:(BOOL)isCrashed;

@end
