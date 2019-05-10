//
//  DataDownloadHeaderView.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/8/15.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OptionButtonView.h"

@interface DataDownloadHeaderView : UIView

@property (nonatomic, strong) OptionButtonView *optionView;

@property (weak, nonatomic) IBOutlet UIButton *bgButton;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *coinLabel;
@property (weak, nonatomic) IBOutlet UIImageView *portraitImgView;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@end
