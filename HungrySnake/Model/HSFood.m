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

-(id)initWithFieldSize:(HSCoordinate *)farestPoint {
    self = [super init];
    if (self) {
        self.privateGameField = farestPoint;
    }
    return self;
}

-(void)generateNewFood {
    
    NSInteger randomX = arc4random() % (self.privateGameField.x + 1);
    
    NSInteger randomY = arc4random() % (self.privateGameField.y + 1);
    
    self.location = [[HSCoordinate alloc] initWithCoordinateX:randomX withCoordinateY:randomY ];
}

@end
