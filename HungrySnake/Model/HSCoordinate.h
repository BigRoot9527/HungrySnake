//
//  HSCoordinate.h
//  HungrySnake
//
//  Created by Tingwei Hsu on 2018/8/16.
//  Copyright © 2018年 Tingwei Hsu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSCoordinate : NSObject

@property (nonatomic) NSInteger x;
@property (nonatomic) NSInteger y;

-(id)initWithCoordinateX:(NSInteger)x_ withCoordinateY:(NSInteger)y_;


@end
