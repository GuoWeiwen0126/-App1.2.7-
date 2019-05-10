//
//  QuestionNoteCell.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/5.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QNoteModel;

@interface QuestionNoteCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *insertTimeLabel;

@property (nonatomic, strong) QNoteModel *qNoteModel;

@end
