//
//  HSFood.h
//  HungrySnake
//
//  Created by Tingwei Hsu on 2018/8/17.
//  Copyright © 2018年 Tingwei Hsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSCoordinate.h"

@class HSFoodProvider;

@interface HSFoodProvider : NSObject
- (HSCoordinate*)generateNewFoodWithEmptySpace:(NSArray<HSCoordinate *> *)space;
- (HSCoordinate*)getFoodLocation;
@end
