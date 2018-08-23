//
//  MockGameManagerDelegate.h
//  HungrySnakeTests
//
//  Created by Tingwei Hsu on 2018/8/23.
//  Copyright © 2018年 Tingwei Hsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSGameManager.h"

@interface MockGameManagerDelegate : NSObject <HSGameManagerDelegate>

@property (nonatomic) BOOL delegateDidUpdateGame;
@property (nonatomic) BOOL delegateDidCallSnakeCrash;
@property (nonatomic) BOOL delegateDidCallSnakeWin;
@property (nonatomic) NSInteger delegateSendScore;
@property (nonatomic,strong) HSGameManager *callingManager;

@end
