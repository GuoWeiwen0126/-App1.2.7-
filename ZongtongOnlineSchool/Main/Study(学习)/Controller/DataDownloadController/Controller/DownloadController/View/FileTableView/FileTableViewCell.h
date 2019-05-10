//
//  FileTableViewCell.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/8/23.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FileModel;

@interface FileTableViewCell : UITableViewCell

@property (nonatomic, strong) FileModel *fileModel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *coinNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *downloadLabel;

@end
