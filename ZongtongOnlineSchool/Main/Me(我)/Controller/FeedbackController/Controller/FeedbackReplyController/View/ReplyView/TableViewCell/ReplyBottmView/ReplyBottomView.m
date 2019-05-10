//
//  ReplyBottomView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/8.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "ReplyBottomView.h"
#import "Tools.h"

@implementation ReplyBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = MAIN_RGB_LINE;
        
        self.contentTF = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, UI_SCREEN_WIDTH - 80, self.height - 10*2)];
        self.contentTF.font = FontOfSize(14.0);
        self.contentTF.placeholder = @"  请输入您要填写的内容";
        VIEW_BORDER_RADIUS(self.contentTF, [UIColor whiteColor], 5, 1, MAIN_RGB_TEXT)
        [self addSubview:self.contentTF];
        
        UIButton *sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.contentTF.right, 10, 60, self.height - 10*2)];
        [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [sendBtn setTitleColor:MAIN_RGB forState:UIControlStateNormal];
        [sendBtn addTarget:self action:@selector(sendContentClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sendBtn];
    }
    
    return self;
}
#pragma mark - 点击发送内容
- (void)sendContentClicked
{
    if ([ManagerTools deleteSpaceAndNewLineWithString:self.contentTF.text].length == 0) {
        NSLog(@"请输入内容");
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SendReplyContent" object:self.contentTF.text];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
