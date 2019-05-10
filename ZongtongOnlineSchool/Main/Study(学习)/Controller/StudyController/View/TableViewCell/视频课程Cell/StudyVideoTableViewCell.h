//
//  StudyVideoTableViewCell.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/29.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VideoSectionModel;

@interface StudyVideoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *peopleLabel;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;

@property (nonatomic, assign) NSInteger headerStatus;
@property (nonatomic, strong) VideoSectionModel *vSectionModel;

@end
