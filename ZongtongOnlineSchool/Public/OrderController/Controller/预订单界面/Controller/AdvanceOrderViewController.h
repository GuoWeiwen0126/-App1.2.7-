//
//  AdvanceOrderViewController.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/23.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "BaseViewController.h"
@class OrderAdvanceModel;

@interface AdvanceOrderViewController : BaseViewController

@property (nonatomic, strong) OrderAdvanceModel *advanceModel;
@property (nonatomic, copy) NSString *appType;

@end
