//
//  MKQuestionCollectionView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2019/3/19.
//  Copyright © 2019年 ZongTongEdu. All rights reserved.
//

#import "MKQuestionCollectionView.h"
#import "Tools.h"

@interface MKQuestionCollectionView () <UICollectionViewDelegate, UICollectionViewDataSource>

@end
static NSString *itemID = @"itemID";
@implementation MKQuestionCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[MKQuestionCollectionViewCell class] forCellWithReuseIdentifier:itemID];
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
    }
    
    return self;
}

#pragma mark - UICollectionView协议方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.collectionDataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.cell = [collectionView dequeueReusableCellWithReuseIdentifier:itemID forIndexPath:indexPath];
    
    self.cell.tableView.questionModel = self.collectionDataArray[indexPath.row];
    [self.cell.tableView reloadData];
    
    //根据内容高度 --> 是否可以滑动
    [self.cell.tableView layoutIfNeeded];
    if (self.cell.tableView.contentSize.height < self.cell.tableView.height) {
        //根据内容调整是否滚动
        self.cell.tableView.scrollEnabled = NO;
    } else {
        self.cell.tableView.scrollEnabled = YES;
    }
    
    return self.cell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([self.MKcollectionViewDelegate respondsToSelector:@selector(MKquestionCollectionViewScrollWithNowQModel:nowIndex:)])
    {
        NSInteger nowIndex = (NSInteger)scrollView.contentOffset.x/self.width;
        QuestionModel *nowQModel = self.collectionDataArray[nowIndex];
        [self.MKcollectionViewDelegate MKquestionCollectionViewScrollWithNowQModel:nowQModel nowIndex:nowIndex];
    }
}

@end
