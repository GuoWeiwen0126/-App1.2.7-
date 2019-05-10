//
//  AreaOptionViewController.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/14.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "BaseViewController.h"

@protocol AreaOptionVCDelegate <NSObject>

- (void)areaOptionPopWithProvinceStr:(NSString *)provinceStr cityStr:(NSString *)cityStr;

@end

@interface AreaOptionViewController : BaseViewController

@property (nonatomic, assign) BOOL isExamArea;  //是否是报考地区
@property (nonatomic, weak) id <AreaOptionVCDelegate> areaOptionDelegate;

@end
