//
//  HSFood.m
//  HungrySnake
//
//  Created by Tingwei Hsu on 2018/8/17.
//  Copyright © 2018年 Tingwei Hsu. All rights reserved.
//

#import "HSFood.h"

@implementation HSFood

- (void)generateNewFoodWithEmptySpace:(NSArray<HSCoordinate *> *)space;
{
    if ([space count] == 0) {
        self.location = nil;
        [self.delegate noPosibleSpaceForFood:self];
        return;
    }
    NSInteger index = arc4random() % [space count];
    self.location = [space objectAtIndex:index];
}
@end
