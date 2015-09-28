//
//  CollectionViewCell.m
//  AddPOi
//
//  Created by 黄鹏志 on 15/9/27.
//  Copyright © 2015年 黄鹏志. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell
- (void)awakeFromNib{
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
}
@end
