//
//  CABasicAnimation+poiViewAnimation.h
//  AddPOi
//
//  Created by 黄鹏志 on 15/9/25.
//  Copyright © 2015年 黄鹏志. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
@interface CABasicAnimation (poiViewAnimation)
- (CABasicAnimation *)animationWithPosition:(CGPoint)position;
@end
