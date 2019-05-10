//
//  VideoEvaluateCell.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/29.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VideoEvaluateModel;

@interface VideoEvaluateCell : UITableViewCell

@property (nonatomic, assign) BOOL isQVideoType;
@property (nonatomic, strong) VideoEvaluateModel *vEvaluateModel;

@end
