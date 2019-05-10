//
//  ReplyRightCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/6.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "ReplyRightCell.h"
#import "Tools.h"
#import "FeedbackModel.h"

@implementation ReplyRightCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setFbReplyModel:(FeedbackReplyModel *)fbReplyModel
{
    if (_fbReplyModel != fbReplyModel)
    {
        _fbReplyModel = fbReplyModel;
    }
    [self.portraitImgView sd_setImageWithURL:[NSURL URLWithString:[USER_DEFAULTS objectForKey:User_portrait]] placeholderImage:PortraitPlaceholder];
    self.nameLabel.text = fbReplyModel.userName;
    self.contentLabel.text = fbReplyModel.content;
    CGRect rect = [fbReplyModel.content boundingRectWithSize:CGSizeMake(UI_SCREEN_WIDTH - 125, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: self.contentLabel.font} context:nil];
    self.contentLabel.frame = CGRectMake(UI_SCREEN_WIDTH - rect.size.width - 65, 40, rect.size.width, rect.size.height);
    self.contentImgView.frame = CGRectMake(UI_SCREEN_WIDTH - rect.size.width - 65 - 15, 25, rect.size.width + 35, rect.size.height + 30);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
