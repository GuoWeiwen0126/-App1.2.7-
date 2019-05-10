//
//  UpdateAddressDetailTableViewCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/25.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "UpdateAddressDetailTableViewCell.h"

@implementation UpdateAddressDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.detailTextView.delegate = self;
}
#pragma mark - textView代理方法
- (void)textViewDidChange:(UITextView *)textView
{
    CGRect bounds = textView.bounds;
    //计算textView的高度
    CGSize maxSize = CGSizeMake(bounds.size.width, CGFLOAT_MAX);
    CGSize newSize = [textView sizeThatFits:maxSize];
    bounds.size = newSize;
    textView.bounds = bounds;
    
    if (self.updateRowHeightBlock)
    {
        self.updateRowHeightBlock(textView.text);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
