//
//  LookAnalyseCell.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2019/1/28.
//  Copyright © 2019年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QuestionModel;

NS_ASSUME_NONNULL_BEGIN

@interface LookAnalyseCell : UITableViewCell

@property (nonatomic, strong) QuestionModel *questionModel;
@property (weak, nonatomic) IBOutlet UIButton *lookAnalyseBtn;

@end

NS_ASSUME_NONNULL_END
