//
//  OptionCell.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/8.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QuestionOptionModel;

typedef NS_ENUM(NSInteger, CellShowKey)
{
    DanXuanOption = 1,
    DuoXuanOption = 2,
    PanDuanOption = 3,
};

@interface OptionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *optionImgView;
@property (weak, nonatomic) IBOutlet UILabel *optionLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, assign) NSInteger qTypeShowKey;
@property (nonatomic, strong) QuestionOptionModel *optionModel;
@property (nonatomic, copy)   NSString *answer;   //正确答案
@property (nonatomic, copy)   NSString *uAnswer;  //用户答案

@end
