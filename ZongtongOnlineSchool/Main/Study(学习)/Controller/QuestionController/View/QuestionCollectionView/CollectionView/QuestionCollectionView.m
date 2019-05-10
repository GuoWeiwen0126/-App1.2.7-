//
//  QuestionCollectionView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/7.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "QuestionCollectionView.h"
#import "Tools.h"

@interface QuestionCollectionView () <UICollectionViewDelegate, UICollectionViewDataSource>

@end
static NSString *itemID = @"itemID";
@implementation QuestionCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[QuestionCollectionViewCell class] forCellWithReuseIdentifier:itemID];
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
//        [self.cell.tableView setContentOffset:CGPointZero animated:NO];
    }
    
    return self.cell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([self.collectionViewDelegate respondsToSelector:@selector(questionCollectionViewScrollWithNowQModel:nowIndex:)])
    {
        NSInteger nowIndex = (NSInteger)scrollView.contentOffset.x/self.width;
        QuestionModel *nowQModel = self.collectionDataArray[nowIndex];
        [self.collectionViewDelegate questionCollectionViewScrollWithNowQModel:nowQModel nowIndex:nowIndex];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
