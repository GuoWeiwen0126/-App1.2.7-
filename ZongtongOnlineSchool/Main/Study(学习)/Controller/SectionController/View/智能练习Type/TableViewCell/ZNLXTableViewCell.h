//
//  ZNLXTableViewCell.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/4.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZNLXCellModel;

@interface ZNLXTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *writeBtn;
@property (weak, nonatomic) IBOutlet UILabel *QNumLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *qProgressView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelHeight;

@property (nonatomic, strong) ZNLXCellModel *cellModel;

@end
