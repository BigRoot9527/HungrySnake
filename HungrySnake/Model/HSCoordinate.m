//
//  HSCoordinate.m
//  HungrySnake
//
//  Created by Tingwei Hsu on 2018/8/16.
//  Copyright © 2018年 Tingwei Hsu. All rights reserved.
//

#import "HSCoordinate.h"

@implementation HSCoordinate

-(id)initWithCoordinateX:(NSInteger)x_ withCoordinateY:(NSInteger)y_ {
    
    self = [super init];
    if (self) {
        self.x = x_ >= 0 ? x_ : 0;
        self.y = y_ >= 0 ? y_ : 0;
    }
    return  self;
}

@end
