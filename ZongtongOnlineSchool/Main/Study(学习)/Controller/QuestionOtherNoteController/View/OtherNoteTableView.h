//
//  OtherNoteTableView.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/19.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OtherNoteTableView : UITableView

@property (nonatomic, strong) NSMutableArray *noteArray;
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style noteArray:(NSMutableArray *)noteArray;

@end
