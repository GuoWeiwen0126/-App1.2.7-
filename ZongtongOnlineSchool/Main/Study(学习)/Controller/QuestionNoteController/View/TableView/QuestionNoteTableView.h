//
//  QuestionNoteTableView.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/5.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QNoteTableViewDelegate <NSObject>

- (void)tableViewCellClickedWithIndex:(NSIndexPath *)indexPath;

@end

@interface QuestionNoteTableView : UITableView

@property (nonatomic, strong) NSMutableArray *noteArray;
@property (nonatomic, weak) id <QNoteTableViewDelegate> tableViewDelegate;

@end
