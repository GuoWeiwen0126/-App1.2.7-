//
//  FileDownDetailCell.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/9/6.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FileCoinLogModel;

@interface FileDownDetailCell : UITableViewCell

@property (nonatomic, strong) FileCoinLogModel *fileCoinLogModel;

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@end
