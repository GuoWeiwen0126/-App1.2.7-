//
//  StudyBookTableViewCell.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/8/9.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StudyBookTableViewCell : UITableViewCell

@property (nonatomic, strong) NSMutableArray *bookArray;

- (void)configViewWithArray:(NSMutableArray *)array;

@end
