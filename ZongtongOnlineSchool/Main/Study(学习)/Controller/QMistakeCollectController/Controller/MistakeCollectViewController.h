//
//  MistakeCollectViewController.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/22.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, MistakeCollectType)
{
    MistakeType = 10,
    CollectType = 11,
};

@interface MistakeCollectViewController : BaseViewController

@property (nonatomic, assign) MistakeCollectType mistakeCollectType;

@end
