//
//  MockGameManagerDelegate.m
//  HungrySnakeTests
//
//  Created by Tingwei Hsu on 2018/8/23.
//  Copyright © 2018年 Tingwei Hsu. All rights reserved.
//

#import "MockGameManagerDelegate.h"

@implementation MockGameManagerDelegate

- (void)gameDidupdate:(HSGameManager *)manager
{
    self.delegateDidUpdateGame = YES;
    self.callingManager = self.callingManager == nil ? manager : self.callingManager == manager ? manager : [[HSGameManager alloc] init];
}

- (void)snakeDidCrashIntoBodyInGame:(HSGameManager *)manager gotScore:(NSInteger)score
{
    self.delegateDidCallSnakeCrash = YES;
    self.delegateSendScore = score;
    self.callingManager = self.callingManager == nil ? manager : self.callingManager == manager ? manager : [[HSGameManager alloc] init];
}

- (void)snakeDidWinTheGameInGame:(HSGameManager *)manager gotScore:(NSInteger)score
{
    self.delegateDidCallSnakeWin = YES;
    self.delegateSendScore = score;
    self.callingManager = self.callingManager == nil ? manager : self.callingManager == manager ? manager : [[HSGameManager alloc] init];
}

@end
