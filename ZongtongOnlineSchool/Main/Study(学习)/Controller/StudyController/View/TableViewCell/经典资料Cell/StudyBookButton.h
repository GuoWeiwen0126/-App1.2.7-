//
//  StudyBookButton.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/8/13.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomeModuleModel;

@interface StudyBookButton : UIButton

@property (nonatomic, strong) HomeModuleModel *moduleModel;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *detailLabel;

@end
