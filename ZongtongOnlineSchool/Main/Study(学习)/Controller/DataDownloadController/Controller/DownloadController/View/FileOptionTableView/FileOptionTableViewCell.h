//
//  FileOptionTableViewCell.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/8/21.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FileOptionTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL isSelected;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end
