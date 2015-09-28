//
//  CDLineLayout.h
//  PhotoFlow
//
//  Created by 黄鹏志 on 15/8/2.
//  Copyright (c) 2015年 黄鹏志. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDLineLayout : UICollectionViewFlowLayout
@property (nonatomic, copy) void (^block)(NSInteger);
@end
