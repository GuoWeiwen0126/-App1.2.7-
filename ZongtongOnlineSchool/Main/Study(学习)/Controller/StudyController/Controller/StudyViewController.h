//
//  StudyViewController.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/21.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSUInteger, ZTSectionType)
{
    KDZNLX = 1,
    ZJZNLX = 2,
    ZTLX   = 3,
    GGMK   = 4,
    GPSJ   = 5,
    JCQHLX = 6,
    MKDS   = 7,  //万人模考
    CTLX   = 8,
    SC     = 9,
    LXLS   = 10,
    JTK    = 16,  //旧题库
    SJCT   = 17, //随机抽题
};

@interface StudyViewController : BaseViewController

@end
