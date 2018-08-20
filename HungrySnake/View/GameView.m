//
//  GameView.m
//  HungrySnake
//
//  Created by Tingwei Hsu on 2018/8/17.
//  Copyright © 2018年 Tingwei Hsu. All rights reserved.
//

#import "GameView.h"

@implementation GameView

- (instancetype)initWithFrame:(CGRect)frame fieldFarestPoint:(HSCoordinate *)farestPoint snakeBodies:(NSMutableArray *)bodies foodPosition:(HSCoordinate *)food isCrashed:(BOOL)isCrashed
{
    self = [super initWithFrame:frame];
    if (self) {
        _bodyPositions = bodies;
        _foodPosition = food;
        _isHeadCrashed = isCrashed;
        _farestPoint = farestPoint;
    }
    [self setNeedsDisplay];
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGFloat rectLength = self.bounds.size.width / (self.farestPoint.x+1);
    HSCoordinate *head = self.bodyPositions.lastObject;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    CGContextAddRect(context, self.bounds);
    CGContextSetLineWidth(context, 2.0);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    CGContextSetFillColorWithColor(context, [[UIColor greenColor] CGColor]);
    CGContextSetLineWidth(context, 2.0);
    for (HSCoordinate *point in self.bodyPositions) {
        CGContextAddRect(context, CGRectMake(rectLength*point.x, rectLength*point.y, rectLength, rectLength));
        CGContextDrawPath(context, kCGPathFillStroke);
    }
    CGContextSetFillColorWithColor(context, _isHeadCrashed ? [[UIColor redColor] CGColor] : [[UIColor brownColor] CGColor]);
    CGContextAddRect(context, CGRectMake(rectLength*head.x, rectLength*head.y, rectLength, rectLength));
    CGContextDrawPath(context, kCGPathFillStroke);
    
    CGContextSetFillColorWithColor(context, [[UIColor purpleColor] CGColor]);
    CGContextAddArc(context, rectLength*self.foodPosition.x + (rectLength/2), rectLength*self.foodPosition.y + (rectLength/2), rectLength/2, 0, M_PI * 2.0, 0);
    CGContextDrawPath(context, kCGPathFill);
}

@end
