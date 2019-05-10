//
//  FbOptionCell.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/5.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QuestionOptionModel;

@interface FbOptionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *optionLabel;

@property (nonatomic, copy)   NSString *answer;   //正确答案
@property (nonatomic, assign) NSInteger qTypeShowKey;
@property (nonatomic, strong) QuestionOptionModel *optionModel;

@end
