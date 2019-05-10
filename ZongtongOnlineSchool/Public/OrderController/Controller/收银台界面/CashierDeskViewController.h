//
//  CashierDeskViewController.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/26.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "BaseViewController.h"

@interface CashierDeskViewController : BaseViewController

@property (nonatomic, copy) NSString *oid;
@property (nonatomic, strong) NSDecimalNumber *actuallyMoney;
@property (nonatomic, copy) NSString *appType;

@end
