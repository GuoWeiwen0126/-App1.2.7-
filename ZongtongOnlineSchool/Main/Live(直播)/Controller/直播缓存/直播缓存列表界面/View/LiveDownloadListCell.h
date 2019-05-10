//
//  LiveDownloadListCell.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/12/28.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LiveDownloadListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *courseLabel;
@property (weak, nonatomic) IBOutlet UILabel *teacherLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;

@end

NS_ASSUME_NONNULL_END
