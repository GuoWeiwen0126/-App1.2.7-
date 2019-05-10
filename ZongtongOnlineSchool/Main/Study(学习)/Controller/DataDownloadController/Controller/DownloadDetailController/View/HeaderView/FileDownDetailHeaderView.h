//
//  FileDownDetailHeaderView.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/9/5.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OptionButtonView.h"

@interface FileDownDetailHeaderView : UIView

@property (nonatomic, strong) OptionButtonView *optionView;

@property (weak, nonatomic) IBOutlet UIButton *bgButton;
@property (weak, nonatomic) IBOutlet UIView *bgView;

- (instancetype)initWithFrame:(CGRect)frame praiseNum:(NSString *)praiseNum userCoin:(NSString *)userCoin;

@end
