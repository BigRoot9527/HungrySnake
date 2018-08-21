//
//  HSCoordinate.h
//  HungrySnake
//
//  Created by Tingwei Hsu on 2018/8/16.
//  Copyright © 2018年 Tingwei Hsu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSCoordinate : NSObject

- (instancetype)initWithCoordinateX:(NSUInteger)x Y:(NSUInteger)y;

@property (readonly, nonatomic) NSUInteger x;
@property (readonly, nonatomic) NSUInteger y;
@end
