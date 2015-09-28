//
//  CDLineLayout.m
//  PhotoFlow
//
//  Created by 黄鹏志 on 15/8/2.
//  Copyright (c) 2015年 黄鹏志. All rights reserved.
//

#import "CDLineLayout.h"
#import "CollectionViewCell.h"
static const CGFloat CDItemW = 90;
static const CGFloat CDItemH = CDItemW;

@implementation CDLineLayout

// 只要显示的边界发生改变就重新布局：
// 内部会重新调用layoutAttributesForElementsInRect:方法，获取所有cell的布局属性
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

// 系统会自动调用这个方法，用来设置collectionView停止滚动那一刻的位置
// 原本停止滚动的位置proposedContentOffset
// 滚动速度velocity
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    // 1.计算collectionView最后会停留的范围
    CGRect lastRect;
    lastRect.origin = proposedContentOffset;
    lastRect.size = self.collectionView.frame.size;
    // 2.取出这个范围内的所有属性
    NSArray *array = [self layoutAttributesForElementsInRect:lastRect];
    // 计算屏幕最中间的X
    CGFloat WIDTH = [UIScreen mainScreen].bounds.size.width;
    CGFloat centerX = self.collectionView.contentOffset.x + WIDTH * 0.5;
    // 3.遍历所有可见范围内的item
    CGFloat adjustOffsetX = 1000;
    // 记录下屏幕中心的attribute
  
    UICollectionViewLayoutAttributes *middleAttrs;
    for (UICollectionViewLayoutAttributes *attrs in array) {
        if (ABS(attrs.center.x - centerX) < ABS(adjustOffsetX)) {
            adjustOffsetX = attrs.center.x - centerX;
            middleAttrs = attrs;
        }
    }
    // 调用block改变poi视图的编号
    // 改变不在居中位置的cell的显示内容，此处有bug，并没有实现自动居中，待解决。
    self.block(middleAttrs.indexPath.row);
    CollectionViewCell *cell = (CollectionViewCell *) [self.collectionView cellForItemAtIndexPath:middleAttrs.indexPath];
    cell.secondLabel.text = @"东京";
    NSIndexPath *pp = [NSIndexPath indexPathForRow:middleAttrs.indexPath.row - 1 inSection:0];
    NSIndexPath *ppp = [NSIndexPath indexPathForRow:middleAttrs.indexPath.row + 1 inSection:0];
    CollectionViewCell *preCell = (CollectionViewCell *)[self.collectionView cellForItemAtIndexPath:pp];
    CollectionViewCell *nextCell = (CollectionViewCell *)[self.collectionView cellForItemAtIndexPath:ppp];
    preCell.secondLabel.text = @"";
    nextCell.secondLabel.text = @"";
    
    return CGPointMake(proposedContentOffset.x + adjustOffsetX, proposedContentOffset.y);
}



- (void)prepareLayout {
    [super prepareLayout];
    // 每个cell（item）都有自己的UICollectionViewLayoutAttributes
    // 每一个indexPath都有自己的UICollectionViewLayoutAttributes
    // 每个cell的尺寸
    self.itemSize = CGSizeMake(CDItemW, CDItemH);
    CGFloat inset = (self.collectionView.frame.size.width - CDItemW) * 0.5;
    self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset);
    // 设置水平滚动
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.minimumLineSpacing = CDItemW * 0.5;
    
    
}

/** 有效距离：当item的中间x距离屏幕的中间x在CDActiveDistance以内，才会开始放大，其他情况都是缩小*/
static CGFloat const CDActiveDistance = 100;
/** 缩放因素：值越大，item就会被放大的越大*/
static CGFloat const CDScaleFator = 0.3;

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    // 0.计算可见的矩形框rect
    CGRect visableRect;
    visableRect.origin = self.collectionView.contentOffset;
    visableRect.size = self.collectionView.frame.size;
    
    // 1.取得默认的cell的UICollectionViewLayoutAttributes
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    // 计算屏幕最中间的X
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width * 0.5;
    // 2.遍历所有的布局属性,, 在collectionView可见范围内的则进行缩放
    for (UICollectionViewLayoutAttributes *attrs in array) {
        if (!CGRectIntersectsRect(visableRect, attrs.frame)) continue;
        // 每个item的中点
        CGFloat itemCenterX = attrs.center.x;
    
        // 差距越小，缩放比例越大
        // 根据跟屏幕中间的距离计算缩放比例
        // 当左右的item滚出边界的时候，情愿让它变小也不要它变大，否则，当item的真实rect滚出边界，被放大的item会突然消失,,当(1 - (ABS(itemCenterX - centerX))的值小于CDActiveDistance时是放大，大于是缩小
        CGFloat scale = 1 + CDScaleFator * (1 - (ABS(itemCenterX - centerX)) / CDActiveDistance);
        
        // attrs.transform = CGAffineTransformScale(attrs.transform, scale, scale);
        attrs.transform3D = CATransform3DMakeScale(scale, scale, 1.0);
    }
    
    return array;
}
@end
