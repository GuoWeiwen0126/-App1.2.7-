//
//  VideoSectionCell.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/26.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VideoSectionModel;

@interface VideoSectionCell : UITableViewCell

@property (nonatomic, strong) VideoSectionModel *vSectionModel;
@property (nonatomic, assign) NSInteger vSecStatus;

@end
