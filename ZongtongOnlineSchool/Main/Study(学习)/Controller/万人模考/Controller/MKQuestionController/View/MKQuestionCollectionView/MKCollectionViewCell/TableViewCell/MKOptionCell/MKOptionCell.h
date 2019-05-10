//
//  MKOptionCell.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2019/3/19.
//  Copyright © 2019年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QuestionOptionModel;

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, CellShowKey)
{
    DanXuanOption = 1,
    DuoXuanOption = 2,
    PanDuanOption = 3,
};

@interface MKOptionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *optionImgView;
@property (weak, nonatomic) IBOutlet UILabel *optionLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, assign) NSInteger qTypeShowKey;
@property (nonatomic, strong) QuestionOptionModel *optionModel;
@property (nonatomic, copy)   NSString *answer;   //正确答案
@property (nonatomic, copy)   NSString *uAnswer;  //用户答案

@end

NS_ASSUME_NONNULL_END
