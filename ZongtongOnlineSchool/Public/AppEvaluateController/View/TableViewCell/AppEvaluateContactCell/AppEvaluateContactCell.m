//
//  AppEvaluateContactCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/24.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "AppEvaluateContactCell.h"

@implementation AppEvaluateContactCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contactTF.delegate = self;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateAppEvaluateContact" object:textField.text];
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
