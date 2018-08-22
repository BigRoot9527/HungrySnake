//
//  GameView.m
//  HungrySnake
//
//  Created by Tingwei Hsu on 2018/8/17.
//  Copyright © 2018年 Tingwei Hsu. All rights reserved.
//

#import "GameView.h"

@implementation GameView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.isCrashMode = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (!self.delegate) {
        return;
    }
    
    HSCoordinate *farestPoint = [self.delegate farestPointForView:self];
    NSArray <HSCoordinate *> *bodyPositions = [self.delegate snakeBodyForView:self];
    HSCoordinate *foodPosition = [self.delegate foodPositionForView:self];
    
    CGFloat rectLength = self.bounds.size.width / (farestPoint.x+1);
    HSCoordinate *head = bodyPositions.lastObject;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    CGContextAddRect(context, self.bounds);
    CGContextSetLineWidth(context, 2.0);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    CGContextSetFillColorWithColor(context, [[UIColor greenColor] CGColor]);
    CGContextSetLineWidth(context, 2.0);
    for (HSCoordinate *point in bodyPositions) {
        CGContextAddRect(context, CGRectMake(rectLength*point.x, rectLength*point.y, rectLength, rectLength));
        CGContextDrawPath(context, kCGPathFillStroke);
    }
    CGContextSetFillColorWithColor(context, self.isCrashMode ? [[UIColor redColor] CGColor] : [[UIColor brownColor] CGColor]);
    CGContextAddRect(context, CGRectMake(rectLength*head.x, rectLength*head.y, rectLength, rectLength));
    CGContextDrawPath(context, kCGPathFillStroke);
    
    if (foodPosition) {
        CGContextSetFillColorWithColor(context, [[UIColor purpleColor] CGColor]);
        CGContextAddArc(context, rectLength * foodPosition.x + (rectLength/2), rectLength*foodPosition.y + (rectLength/2), rectLength/2 * 0.9, 0, M_PI * 2.0, 0);
        CGContextDrawPath(context, kCGPathFill);
    }
}

@end
