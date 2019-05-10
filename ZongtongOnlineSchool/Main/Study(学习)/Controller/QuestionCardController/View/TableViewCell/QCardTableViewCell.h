//
//  QCardTableViewCell.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/12.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QCardTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL isClicked;
- (void)createCardButtonWithArray:(NSMutableArray *)array;

@end
