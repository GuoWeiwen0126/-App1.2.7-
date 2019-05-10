//
//  AnalyseCell.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/8.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QuestionModel;

@interface AnalyseCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *statisticLabel;
@property (weak, nonatomic) IBOutlet UILabel *analyseLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statisticLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *analyseLabelHeight;
@property (nonatomic, strong) QuestionModel *questionModel;

@end
