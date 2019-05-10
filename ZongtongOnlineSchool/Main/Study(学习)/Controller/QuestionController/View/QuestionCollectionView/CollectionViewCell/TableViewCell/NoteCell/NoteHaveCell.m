//
//  NoteHaveCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/18.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "NoteHaveCell.h"
#import "Tools.h"
#import "QuestionModel.h"

@interface NoteHaveCell ()
@property (weak, nonatomic) IBOutlet UIButton *lookNoteBtn;
@property (weak, nonatomic) IBOutlet UIButton *lookOtherNoteBtn;

@property (weak, nonatomic) IBOutlet UIImageView *portraitImgView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *praiseBtn;
@property (weak, nonatomic) IBOutlet UILabel *praiseNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *insertTimeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@end

@implementation NoteHaveCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentLabelTapped)];
    [self.contentLabel addGestureRecognizer:tap];
}
#pragma mark - 按钮点击方法（查看个人笔记、添加笔记、查看他人笔记）
- (IBAction)noteBtnClicked:(id)sender
{
    UIButton *temBtn = (UIButton *)sender;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NoteCellButtonClicked" object:[NSString stringWithFormat:@"%ld",(long)temBtn.tag]];
}
#pragma mark - contentLabel 点击方法
- (void)contentLabelTapped
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NoteCellContentLabelClicked" object:nil];
}

#pragma mark - 删除笔记
- (IBAction)removeNoteBtnClicked:(id)sender
{
    [XZCustomViewManager showSystemAlertViewWithTitle:@"删除该题笔记" message:@"确定删除该题笔记吗？" cancelButtonTitle:@"取消" otherButtonTitle:@"删除" isTouchbackground:YES withAlertViewType:XZAlertViewTypeSystemAlert handler:^(XZCustomAlertView *alertView, XZAlertViewBtnTag buttonIndex, XZAlertViewType alertViewType) {
        if (buttonIndex == XZAlertViewBtnTagSure) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NoteCellRemoveNote" object:nil];
        }
    }];
}
#pragma mark - 点赞按钮点击
- (IBAction)praiseBtnClicked:(id)sender
{
    self.praiseBtn.selected = !self.praiseBtn.selected;
    self.praiseNumLabel.text = [NSString stringWithFormat:@"%ld",[self.praiseNumLabel.text integerValue] + (self.praiseBtn.selected ? 1:-1)];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NoteCellPraiseBtnClicked" object:nil];
}
#pragma mark - setter方法
- (void)setQNoteModel:(QNoteModel *)qNoteModel
{
    if (_qNoteModel != qNoteModel)
    {
        _qNoteModel = qNoteModel;
    }
    [self.portraitImgView sd_setImageWithURL:[NSURL URLWithString:qNoteModel.portrait]];
    self.nickNameLabel.text = qNoteModel.nickName;
    self.contentLabel.text = qNoteModel.content;
    self.insertTimeLabel.text = qNoteModel.insertTime;
    self.praiseBtn.selected = [qNoteModel.isNotePraise integerValue] == 1 ? YES:NO;
    self.praiseNumLabel.text = [NSString stringWithFormat:@"%ld",(long)qNoteModel.praise];
    self.contentHeight.constant = [ManagerTools adaptHeightWithString:qNoteModel.content FontSize:14.0 SizeWidth:UI_SCREEN_WIDTH - 115]+2;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
