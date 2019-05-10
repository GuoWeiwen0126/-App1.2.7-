//
//  MKAnalyseCell.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2019/3/19.
//  Copyright © 2019年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QuestionModel;

NS_ASSUME_NONNULL_BEGIN

@interface MKAnalyseCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *analyseLabel;

@property (nonatomic, strong) QuestionModel *questionModel;

@end

NS_ASSUME_NONNULL_END
