//
//  CourseOptionFirstCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/5/7.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "CourseOptionFirstCell.h"
#import "Tools.h"
#import "CourseOptionItemCell.h"

@implementation CourseOptionFirstCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - collectionView懒加载
- (CourseOptionCollectionView *)collectionView {
    if (!_collectionView)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        NSInteger rowNumber = SCREEN_FIT_WITH_DEVICE(4, 6);
        layout.itemSize = CGSizeMake((UI_SCREEN_WIDTH - 20*2)/rowNumber, (UI_SCREEN_WIDTH - 20*2)/rowNumber * 0.8);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        float height = 0.0;
        if (self.courseNumber != 0) {
            if (self.courseNumber < rowNumber) {
                height = layout.itemSize.height;
            } else if (self.courseNumber%rowNumber == 0) {
                height = self.courseNumber/rowNumber * layout.itemSize.height;
            } else {
                height = (self.courseNumber/rowNumber + 1) * layout.itemSize.height;
            }
        }
        _collectionView = [[CourseOptionCollectionView alloc] initWithFrame:CGRectMake(20, 40, UI_SCREEN_WIDTH - 20*2, height) collectionViewLayout:layout];
        [self addSubview:_collectionView];
    }
    return _collectionView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
