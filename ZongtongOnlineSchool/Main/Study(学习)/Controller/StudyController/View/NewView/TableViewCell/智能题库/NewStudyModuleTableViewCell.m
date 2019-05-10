//
//  NewStudyModuleTableViewCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/11/20.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "NewStudyModuleTableViewCell.h"
#import "Tools.h"
#import "StudyCollectionViewFlowLayout.h"

@implementation NewStudyModuleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self addSubview:self.collectionView];
}

#pragma mark - collectionView懒加载
- (StudyCollectionView *)collectionView {
    if (!_collectionView)
    {
        StudyCollectionViewFlowLayout *layout = [[StudyCollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(UI_SCREEN_WIDTH/4, UI_SCREEN_WIDTH/4);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[StudyCollectionView alloc] initWithFrame:CGRectMake(0, 25, UI_SCREEN_WIDTH, UI_SCREEN_WIDTH/2) collectionViewLayout:layout];
//        _collectionView.backgroundColor = [UIColor redColor];
        _collectionView.collectionViewDelegate = self;
    }
    return _collectionView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
