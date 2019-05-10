//
//  CourseOptionFirstCell.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/5/7.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseOptionCollectionView.h"

@interface CourseOptionFirstCell : UITableViewCell

@property (nonatomic, assign) NSInteger courseNumber;
@property (nonatomic, strong) CourseOptionCollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;

@end
