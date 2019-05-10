//
//  NoteCell.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/8.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, NoteCellBtnType)
{
    LookPersonalNote = 10,
    AddNote          = 11,
    LookOtherNote    = 12,
};

@interface NoteCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *lookNoteBtn;
@property (weak, nonatomic) IBOutlet UIButton *addNoteBtn;
@property (weak, nonatomic) IBOutlet UIButton *lookOtherNoteBtn;
@property (nonatomic, assign) NoteCellBtnType btnType;

@end
