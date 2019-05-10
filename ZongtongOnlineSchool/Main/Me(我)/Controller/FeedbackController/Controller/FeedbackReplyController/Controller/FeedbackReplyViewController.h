//
//  FeedbackReplyViewController.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/5.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "BaseViewController.h"
@class QuestionModel;
@class FeedbackModel;

@interface FeedbackReplyViewController : BaseViewController

@property (nonatomic, strong) QuestionModel *qModel;
@property (nonatomic, strong) FeedbackModel *fbModel;

@end
