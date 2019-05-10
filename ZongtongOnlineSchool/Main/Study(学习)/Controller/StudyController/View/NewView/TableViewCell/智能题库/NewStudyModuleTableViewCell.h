//
//  NewStudyModuleTableViewCell.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/11/20.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudyCollectionView.h"

@interface NewStudyModuleTableViewCell : UITableViewCell <StudyCollectionViewDelegate>

@property (nonatomic, strong) StudyCollectionView *collectionView;

@end
