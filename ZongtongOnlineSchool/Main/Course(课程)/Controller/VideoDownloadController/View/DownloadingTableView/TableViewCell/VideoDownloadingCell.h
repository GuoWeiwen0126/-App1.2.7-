//
//  VideoDownloadingCell.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/16.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFDownloadManager.h"

typedef void(^DownloadBtnClicked)(void);

@interface VideoDownloadingCell : UITableViewCell

/* 下载按钮点击回调block */
@property (nonatomic, copy) DownloadBtnClicked  downloadBtnClickBlock;
/* 下载信息模型 */
@property (nonatomic, strong) ZFFileModel       *fileInfo;
/* 该文件发起的请求 */
@property (nonatomic,retain) ZFHttpRequest      *request;

@end
