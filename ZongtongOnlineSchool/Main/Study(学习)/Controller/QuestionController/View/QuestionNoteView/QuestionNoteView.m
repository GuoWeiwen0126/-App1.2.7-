//
//  QuestionNoteView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/19.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "QuestionNoteView.h"
#import "Tools.h"

@implementation QuestionNoteView
{
    UIButton   *_noteBgButton;
    UITextView *_noteTextView;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        //阴影背景
        _noteBgButton = [[UIButton alloc] initWithFrame:frame];
        _noteBgButton.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.3];
        [self addSubview:_noteBgButton];
        
        //笔记背景
        self.noteBgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - self.width*0.6, self.width, self.width*0.6)];
        self.noteBgView.backgroundColor = [USER_DEFAULTS boolForKey:Question_DayNight] ? Night_RGB_BGColor:[UIColor whiteColor];
        [_noteBgButton addSubview:self.noteBgView];
        
        //取消、保存按钮
        float btnWidth = _noteBgButton.width * 0.16;
        float btnHeight = _noteBgButton.width * SCREEN_FIT_WITH_DEVICE(0.1, 0.12);
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btnWidth, btnHeight)];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:MAIN_RGB forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(saveOrCancelNoteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.noteBgView addSubview:cancelBtn];
        UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.noteBgView.width - btnWidth, 0, btnWidth, btnHeight)];
        [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        [saveBtn setTitleColor:MAIN_RGB forState:UIControlStateNormal];
        [saveBtn addTarget:self action:@selector(saveOrCancelNoteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.noteBgView addSubview:saveBtn];
        
        //内容输入框
        _noteTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, cancelBtn.bottom, self.noteBgView.width-10*2, self.noteBgView.height-cancelBtn.height-10)];
        _noteTextView.font = FontOfSize(SCREEN_FIT_WITH_DEVICE(16.0, 14.0));
        VIEW_BORDER_RADIUS(_noteTextView, [UIColor clearColor], 5.0, 1.0, MAIN_RGB)
        _noteTextView.autocorrectionType = UITextAutocorrectionTypeNo; //⭐️必须添加⭐️
        _noteTextView.spellCheckingType = UITextSpellCheckingTypeNo;
        [self.noteBgView addSubview:_noteTextView];
    }
    
    return self;
}
#pragma mark - 取消、保存按钮方法
- (void)saveOrCancelNoteBtnClicked:(UIButton *)btn
{
    if (btn.left < self.width/2)
    {
        [self.noteTextView resignFirstResponder];
        self.hidden = YES;
    }
    else
    {
        if (_noteTextView.text.length == 0 || [[_noteTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0)
        {
            [XZCustomWaitingView showAutoHidePromptView:@"请填写您的笔记" background:nil showTime:0.8];
            return;
        }
        //发送通知（添加云笔记、修改云笔记）
        if (self.state == AddNote) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"QuestionAddNoteText" object:_noteTextView.text];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"QuestionUpdateNoteText" object:_noteTextView.text];
        }
        [self.noteTextView resignFirstResponder];
        self.hidden = YES;
    }
}

@end
