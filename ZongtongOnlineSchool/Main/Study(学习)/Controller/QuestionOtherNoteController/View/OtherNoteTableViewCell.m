//
//  OtherNoteTableViewCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/19.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "OtherNoteTableViewCell.h"
#import "Tools.h"
#import "OtherNoteModel.h"

@interface OtherNoteTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *portraitImgView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *praiseBtn;
@property (weak, nonatomic) IBOutlet UILabel *praiseNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *insertTimeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@end

@implementation OtherNoteTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
#pragma mark - 点赞按钮点击
- (IBAction)praiseBtnClicked:(id)sender
{
    self.praiseBtn.selected = !self.praiseBtn.selected;
    self.praiseNumLabel.text = [NSString stringWithFormat:@"%ld",[self.praiseNumLabel.text integerValue] + (self.praiseBtn.selected ? 1:-1)];
}
#pragma mark - setter方法
- (void)setNoteModel:(OtherNoteModel *)noteModel
{
    if (_noteModel != noteModel)
    {
        _noteModel = noteModel;
    }
    [self.portraitImgView sd_setImageWithURL:[NSURL URLWithString:noteModel.portrait] placeholderImage:PortraitPlaceholder];
    self.nickNameLabel.text = noteModel.nickName;
    self.contentLabel.text = noteModel.content;
    self.insertTimeLabel.text = noteModel.insertTime;
    self.praiseNumLabel.text = [NSString stringWithFormat:@"%ld",(long)noteModel.praise];
    self.contentHeight.constant = [ManagerTools adaptHeightWithString:noteModel.content FontSize:14.0f SizeWidth:UI_SCREEN_WIDTH - 115]+2;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
