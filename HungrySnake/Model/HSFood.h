//
//  HSFood.h
//  HungrySnake
//
//  Created by Tingwei Hsu on 2018/8/17.
//  Copyright © 2018年 Tingwei Hsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSCoordinate.h"

@interface HSFood : NSObject

@property (nonatomic,strong) HSCoordinate *location;
- (id)initWithFieldSize:(HSCoordinate *)farestPoint;
- (void)generateNewFoodWithEmptySpace:(NSMutableArray *)space;

@end
