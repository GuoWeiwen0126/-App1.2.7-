//
//  VideoEvaluateCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/29.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "VideoEvaluateCell.h"
#import "Tools.h"
#import "VideoDetailModel.h"

@interface VideoEvaluateCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *insertTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelHeight;

@end

@implementation VideoEvaluateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
#pragma mark - 删除评价
- (IBAction)deleteEvaluateClicked:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"VideoEvaluateDeleteEvaluate" object:self.vEvaluateModel];
}
- (void)setVEvaluateModel:(VideoEvaluateModel *)vEvaluateModel
{
    if (_vEvaluateModel != vEvaluateModel)
    {
        _vEvaluateModel = vEvaluateModel;
    }
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:vEvaluateModel.portrait]];
    self.nameLabel.text = vEvaluateModel.nickName;
    self.contentLabel.text = vEvaluateModel.content;
    self.contentLabelHeight.constant = [ManagerTools adaptHeightWithString:vEvaluateModel.content FontSize:14.0 SizeWidth:UI_SCREEN_WIDTH - 80]+2;
    self.insertTimeLabel.text = vEvaluateModel.insertTime;
    if (self.isQVideoType == NO && vEvaluateModel.uid == [[USER_DEFAULTS objectForKey:User_uid] integerValue]) {
        self.deleteBtn.hidden = NO;
    } else {
        self.deleteBtn.hidden = YES;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
