//
//  StudyModuleTableViewCell.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/29.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudyCollectionView.h"

@interface StudyModuleTableViewCell : UITableViewCell <StudyCollectionViewDelegate>

@property (nonatomic, strong) NSArray *cellDataArray;

@property (nonatomic, strong) StudyCollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) UIView *lineView;

@end
