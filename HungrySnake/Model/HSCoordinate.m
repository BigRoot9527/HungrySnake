//
//  HSCoordinate.m
//  HungrySnake
//
//  Created by Tingwei Hsu on 2018/8/16.
//  Copyright © 2018年 Tingwei Hsu. All rights reserved.
//

#import "HSCoordinate.h"

@interface HSCoordinate ()
@property (nonatomic) NSUInteger x;
@property (nonatomic) NSUInteger y;
@end

@implementation HSCoordinate

-(id)initWithCoordinateX:(NSUInteger)x Y:(NSUInteger)y {
    
    self = [super init];
    if (self) {
        self.x = x;
        self.y = y;
    }
    return  self;
}

@end
