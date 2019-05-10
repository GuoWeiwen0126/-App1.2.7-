//
//  CouponTableView.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/9.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CouponType)
{
    CouponNormal   = 0,
    CouponAbnormal = 1,
};

@interface CouponTableView : UITableView

@property (nonatomic, assign) CouponType couponType;
@property (nonatomic, strong) NSMutableArray *couponArray;

@end
