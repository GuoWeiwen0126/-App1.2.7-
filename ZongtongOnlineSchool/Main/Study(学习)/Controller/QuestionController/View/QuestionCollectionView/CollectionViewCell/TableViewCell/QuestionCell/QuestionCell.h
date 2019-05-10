//
//  QuestionCell.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/8.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QuestionModel;

@interface QuestionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (nonatomic, strong) QuestionModel *questionModel;

@end
