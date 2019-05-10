//
//  TalkfunLoadingView.m
//  TalkfunSDKDemo
//
//  Created by Sunzn on 2017/4/21.
//  Copyright © 2017年 Talkfun. All rights reserved.
//

#import "TalkfunLoadingView.h"
#import "UIImageView+WebCache.h"

@implementation TalkfunLoadingView

+ (id)initView{
    id view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
    return view;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.tipsBtn.layer.borderWidth = 0.5;
    self.tipsBtn.userInteractionEnabled = NO;
    self.tipsBtn.layer.borderColor = UIColorFromRGBHex(0x687fcd).CGColor;
    self.logoImageView.layer.cornerRadius = CGRectGetWidth(self.logoImageView.frame)/2.;
    self.logoImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.logoImageView.layer.shadowOffset = CGSizeMake(0, 0);
    self.logoImageView.layer.shadowOpacity = 0.5;
    self.logoImageView.backgroundColor = [UIColor whiteColor];
//    self.logoImageView.layer.borderWidth = 1;
    
}

- (void)configLogo:(NSString *)logoUrl courseName:(NSString *)name{
    [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:logoUrl] placeholderImage:nil options:0];
//    self.logoImageView.image = [UIImage imageNamed:logoUrl?logoUrl:@""];
    self.courseNameLabel.text = name?name:nil;
}

@end
