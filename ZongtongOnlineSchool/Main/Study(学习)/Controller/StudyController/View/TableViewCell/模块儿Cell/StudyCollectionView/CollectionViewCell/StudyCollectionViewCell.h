//
//  StudyCollectionViewCell.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/29.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomeModuleModel;

@interface StudyCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) HomeModuleModel *moduleModel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIImageView *markImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgViewLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgViewTrailing;

@end
