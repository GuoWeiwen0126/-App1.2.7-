//
//  NewStudyVIPTableViewCell.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/11/20.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomeModuleModel;

@interface NewStudyVIPTableViewCell : UITableViewCell

@property (nonatomic, strong) HomeModuleModel *moduleModel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end
