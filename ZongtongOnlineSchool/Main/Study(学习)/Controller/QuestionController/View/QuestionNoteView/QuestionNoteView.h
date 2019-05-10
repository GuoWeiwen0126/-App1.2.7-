//
//  QuestionNoteView.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/19.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, QuestionNoteViewState)
{
    AddNote    = 0,
    UpdateNote = 1,
};

@interface QuestionNoteView : UIView

@property (nonatomic, strong) UIView *noteBgView;
@property (nonatomic, strong) UITextView *noteTextView;
@property (nonatomic, assign) QuestionNoteViewState state;

@end
