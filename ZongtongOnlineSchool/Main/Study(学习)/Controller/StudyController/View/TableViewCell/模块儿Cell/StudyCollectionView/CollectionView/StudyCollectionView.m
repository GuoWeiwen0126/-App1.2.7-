//
//  StudyCollectionView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/29.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "StudyCollectionView.h"
#import "Tools.h"
#import "StudyCollectionViewCell.h"

static NSString *cellID = @"cellID";

@implementation StudyCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"StudyCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellID];
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
    }
    
    return self;
}

#pragma mark - UICollectionView协议方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _moduleDataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    StudyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    cell.moduleModel = self.moduleDataArray[indexPath.row];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"StudyCollectionViewCellClicked" object:self.moduleDataArray[indexPath.row]];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([self.collectionViewDelegate respondsToSelector:@selector(studyCollectionViewPageControlChangeWithNewPage:)])
    {
        [self.collectionViewDelegate studyCollectionViewPageControlChangeWithNewPage:scrollView.contentOffset.x < UI_SCREEN_WIDTH/2 ? 0:1];
    }
}

@end
