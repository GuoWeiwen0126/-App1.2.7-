//
//  FileDownHistoryCell.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/9/6.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FileCoinHistoryModel;

@interface FileDownHistoryCell : UITableViewCell

@property (nonatomic, strong) FileCoinHistoryModel *fileCoinHistoryModel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *coinNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@end
