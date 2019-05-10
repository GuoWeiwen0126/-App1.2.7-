//
//  ReplyLeftCell.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/6.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FeedbackReplyModel;

@interface ReplyLeftCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *portraitImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *contentImgView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (nonatomic, strong) FeedbackReplyModel *fbReplyModel;

@end
