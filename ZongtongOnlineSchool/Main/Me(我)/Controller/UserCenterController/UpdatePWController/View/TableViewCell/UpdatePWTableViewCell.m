//
//  UpdatePWTableViewCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/23.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "UpdatePWTableViewCell.h"
#import "Macros.h"

@implementation UpdatePWTableViewCell 

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.textField.delegate = self;
}
#pragma mark - textField代理方法
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
//    self.titleLabel.textColor = MAIN_RGB;
//    self.lineView.backgroundColor = MAIN_RGB;
    
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
//    self.titleLabel.textColor = MAIN_RGB_TEXT;
//    self.lineView.backgroundColor = MAIN_RGB_LINE;
    if (self.textField.text.length > 0) {
        self.titleLabel.textColor = MAIN_RGB;
        self.lineView.backgroundColor = MAIN_RGB;
    } else {
        self.titleLabel.textColor = MAIN_RGB_TEXT;
        self.lineView.backgroundColor = MAIN_RGB_LINE;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
