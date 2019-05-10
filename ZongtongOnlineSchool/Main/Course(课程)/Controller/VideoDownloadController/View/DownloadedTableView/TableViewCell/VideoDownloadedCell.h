//
//  VideoDownloadedCell.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/16.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZFFileModel;

@interface VideoDownloadedCell : UITableViewCell

/* 下载信息模型 */
@property (nonatomic, strong) ZFFileModel *fileInfo;

@end
