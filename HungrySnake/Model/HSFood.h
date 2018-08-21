//
//  HSFood.h
//  HungrySnake
//
//  Created by Tingwei Hsu on 2018/8/17.
//  Copyright © 2018年 Tingwei Hsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSCoordinate.h"

@class HSFood;
@protocol HSFoodDelegate
- (void)noPosibleSpaceForFood:(HSFood *)food;
@end

@interface HSFood : NSObject
@property (nonatomic,strong) HSCoordinate *location;
@property (nonatomic,weak) id<HSFoodDelegate> delegate;
- (void)generateNewFoodWithEmptySpace:(NSArray<HSCoordinate *> *)space;

@end
