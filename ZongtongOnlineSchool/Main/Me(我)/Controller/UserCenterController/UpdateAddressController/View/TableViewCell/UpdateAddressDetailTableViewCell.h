//
//  UpdateAddressDetailTableViewCell.h
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/25.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UpdateRowHeightBlock)(NSString * addressStr);

@interface UpdateAddressDetailTableViewCell : UITableViewCell <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *detailTextView;

@property (nonatomic, copy) UpdateRowHeightBlock updateRowHeightBlock;

@end
