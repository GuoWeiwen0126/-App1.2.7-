//
//  StudyCollectionViewFlowLayout.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/30.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "StudyCollectionViewFlowLayout.h"
#import "Tools.h"

@interface StudyCollectionViewFlowLayout ()

@property (nonatomic ,strong) NSMutableArray *cellAttrArray;
@property (nonatomic, assign) CGFloat maxWidth;

@end

@implementation StudyCollectionViewFlowLayout

- (void)prepareLayout
{
    [super prepareLayout];
    
//    //---item的高度&宽度
//    CGFloat itemWidth = self.collectionView.width/4;
//    CGFloat itemHeight = self.collectionView.width/4;
//    
//    //---section的数量
//    NSInteger sectionCount = self.collectionView.numberOfSections;
//    
//    NSInteger nowPageCount = 0;
//    for (int i = 0; i < sectionCount; i ++)
//    {
//        NSInteger itemCount = [self.collectionView numberOfItemsInSection:i];
//        for (int j = 0; j < itemCount; i ++)
//        {
//            //---获取 cell 的 index
//            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
//            //---根据 index 创建 UICollectionViewLayoutAttributes
//            UICollectionViewLayoutAttributes *layoutAttr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
//            //---计算 j 在 该组第几页
//            int page = j / (self.columns * self.rows);
//            int index = j % (self.columns * self.rows);
//            //---计算 layoutAttr 的 frame
//            CGFloat itemX = (nowPageCount + page) * self.collectionView.width + itemWidth*(index%self.columns);
//            CGFloat itemY = itemHeight * (index/self.columns);
//            
//            layoutAttr.frame = CGRectMake(itemX, itemY, itemWidth, itemHeight);
//            
//            [self.cellAttrArray addObject:layoutAttr];
//        }
//        nowPageCount += (itemCount - 1)/(self.columns * self.rows) + 1;
//    }
//    self.maxWidth = nowPageCount * self.collectionView.width;
    
    //---item的高度&宽度
    CGFloat itemWidth = self.collectionView.width/4;
    CGFloat itemHeight = self.collectionView.width/4;
    
    //---section的数量
    NSInteger numSections = [self.collectionView numberOfSections];
    
    NSInteger nowPageCount = 0;
    for (int i = 0; i < numSections; i++)
    {
        CGFloat itemCount = [self.collectionView numberOfItemsInSection:i];
        for (int j = 0; j < itemCount; j++)
        {
            //---获取 cell 的 index
            NSIndexPath * indePath = [NSIndexPath indexPathForItem:j inSection:i];
            
            //---根据 index 创建 UICollectionViewLayoutAttributes
            UICollectionViewLayoutAttributes *layoutAttr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indePath];
            
            //---计算 j 在 该组第几页
            NSInteger page = j / (self.columns * self.rows);
            NSInteger index = j % (self.columns * self.rows);
            
            //---计算 layoutAttr 的 frame
            CGFloat itemX = (nowPageCount + page) * self.collectionView.width + itemWidth*(index%self.columns);
            CGFloat itemY = itemHeight * (index/self.columns);
            
            layoutAttr.frame = CGRectMake(itemX, itemY, itemWidth, itemHeight);
            
            [self.cellAttrArray addObject:layoutAttr];
        }
        
        nowPageCount += (itemCount - 1 ) / (self.columns*self.rows)+1;
    }
    self.maxWidth = nowPageCount * self.collectionView.bounds.size.width;
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.cellAttrArray;
}

-(CGSize)collectionViewContentSize
{
    return CGSizeMake(self.maxWidth, 0);
}

#pragma mark -- 懒加载
-(NSMutableArray *)cellAttrArray
{
    if (!_cellAttrArray)
    {
        _cellAttrArray = [NSMutableArray arrayWithCapacity:20];
    }
    return _cellAttrArray;
}

-(NSInteger)columns
{
    NSInteger num = [self.layoutDelegate numberOfColumnsWithLayout:self];
    if (num == 0)
    {
        _columns = 4;
    }
    else
    {
        _columns = num;
    }
    return _columns;
}

-(NSInteger)rows
{
    NSInteger num = [self.layoutDelegate numberOfRowsWithLayout:self];
    if (num == 0)
    {
        _rows = 2;
    }
    else
    {
        _rows = num;
    }
    return _rows;
}

@end
