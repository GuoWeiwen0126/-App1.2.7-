//
//  CourseOptionCollectionView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/5/7.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "CourseOptionCollectionView.h"
#import "Tools.h"
#import "CourseOptionItemCell.h"
#import "CourseOptionModel.h"

@implementation CourseOptionCollectionView

static NSString *cellID = @"cellID";
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        self.dataSource = self;
        self.scrollEnabled = NO;
        [self registerNib:[UINib nibWithNibName:@"CourseOptionItemCell" bundle:nil] forCellWithReuseIdentifier:cellID];
    }
    
    return self;
}
#pragma mark - UICollectionView协议方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.courseArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CourseOptionItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    CourseCellModel *cellModel = self.courseArray[indexPath.row];
    
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:cellModel.eiIco]];
    cell.courseTitleLabel.text = cellModel.title;
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CourseOptionCollectionClicked" object:self.courseArray[indexPath.row]];
}


@end
