//
//  QuestionTableView.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/7.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionModel.h"

typedef NS_ENUM(NSInteger, QTypeShowKey)
{
    DanXuan = 1,
    DuoXuan = 2,
    PanDuan = 3,
};

@interface QuestionTableView : UITableView

@property (nonatomic, strong) QuestionModel *questionModel;

@end
