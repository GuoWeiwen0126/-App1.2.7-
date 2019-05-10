//
//  StudyModuleTableViewCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/29.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "StudyModuleTableViewCell.h"
#import "Tools.h"
#import "StudyCollectionViewFlowLayout.h"

@implementation StudyModuleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self addSubview:self.collectionView];
    [self addSubview:self.lineView];
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
        _collectionView.collectionViewDelegate = self;
    }
    return _collectionView;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 25 + UI_SCREEN_WIDTH/2, UI_SCREEN_WIDTH, 4)];
        _lineView.backgroundColor = MAIN_RGB_LINE;
    }
    return _lineView;
}

#pragma mark - collectionViewDelegate
- (void)studyCollectionViewPageControlChangeWithNewPage:(NSInteger)newPage
{
    self.pageControl.currentPage = newPage;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
