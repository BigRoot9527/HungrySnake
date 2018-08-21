//
//  HSGameField.m
//  HungrySnake
//
//  Created by Tingwei Hsu on 2018/8/21.
//  Copyright © 2018年 Tingwei Hsu. All rights reserved.
//

#import "HSGameField.h"
#import "HSSnake.h"
#import "HSFood.h"

@interface HSGameField()
@property (nonatomic,strong) HSSnake *snake;
@property (nonatomic,strong) HSFood *food;
@property (nonatomic,strong) NSMutableArray *emptySpace;

@end

@implementation HSGameField

- (instancetype)initWithFieldSize:(HSCoordinate *)farestPoint {
    self = [super init];
    if (self) {
        
        
    }
    return self;
}

@end
