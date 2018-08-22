//
//  HSFood.m
//  HungrySnake
//
//  Created by Tingwei Hsu on 2018/8/17.
//  Copyright © 2018年 Tingwei Hsu. All rights reserved.
//

#import "HSFoodProvider.h"

@interface HSFoodProvider()
@property (nonatomic,strong) HSCoordinate *foodLocation;
@end

@implementation HSFoodProvider

- (HSCoordinate*)generateNewFoodWithEmptySpace:(NSArray<HSCoordinate *> *)space
{
    if ([space count] == 0) {
        self.foodLocation = nil;
        return nil;
    }
    NSInteger index = arc4random() % [space count];
    self.foodLocation = [space objectAtIndex:index];
    return self.foodLocation;
}

- (HSCoordinate*)getFoodLocation
{
    return self.foodLocation;
}

@end
