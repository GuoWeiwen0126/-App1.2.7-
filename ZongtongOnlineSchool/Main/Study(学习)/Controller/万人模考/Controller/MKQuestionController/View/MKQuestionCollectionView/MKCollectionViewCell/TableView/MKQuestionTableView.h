//
//  MKQuestionTableView.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2019/3/19.
//  Copyright © 2019年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, QTypeShowKey)
{
    DanXuan = 1,
    DuoXuan = 2,
    PanDuan = 3,
};

@interface MKQuestionTableView : UITableView

@property (nonatomic, strong) QuestionModel *questionModel;

@end

NS_ASSUME_NONNULL_END
