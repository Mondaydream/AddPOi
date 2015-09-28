//
//  CABasicAnimation+poiViewAnimation.m
//  AddPOi
//
//  Created by 黄鹏志 on 15/9/25.
//  Copyright © 2015年 黄鹏志. All rights reserved.
//

#import "CABasicAnimation+poiViewAnimation.h"

@implementation CABasicAnimation (poiViewAnimation)
- (CABasicAnimation *)animationWithPosition:(CGPoint)position{
    CGPoint x = CGPointMake(position.x + 2.0f, position.y + 1.5f);
    CGPoint y = CGPointMake(position.x - 2.0f, position.y - 1.5f);
    [self setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self setDuration:0.1f];
    [self setAutoreverses:YES];
    [self setRepeatCount:4];
    [self setRemovedOnCompletion:YES];
    [self setFromValue:[NSValue valueWithCGPoint:x]];
    [self setToValue:[NSValue valueWithCGPoint:y]];
    return self;
}
@end
