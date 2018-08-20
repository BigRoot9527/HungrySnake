//
//  HSFood.m
//  HungrySnake
//
//  Created by Tingwei Hsu on 2018/8/17.
//  Copyright © 2018年 Tingwei Hsu. All rights reserved.
//

#import "HSFood.h"

@interface HSFood()

@property(nonatomic, strong) HSCoordinate *privateGameField;

@end

@implementation HSFood

- (id)initWithFieldSize:(HSCoordinate *)farestPoint
{
    self = [super init];
    if (self) {
        self.privateGameField = farestPoint;
    }
    return self;
}

- (void)generateNewFoodWithEmptySpace:(NSMutableArray *)space
{
    NSInteger index = arc4random() % [space count];
    self.location = [space objectAtIndex:index];
}

@end
