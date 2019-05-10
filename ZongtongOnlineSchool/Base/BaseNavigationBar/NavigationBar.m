//
//  NavigationBar.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/6.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "NavigationBar.h"
#import "Macros.h"
#import "ManagerTools.h"
#import "NaviButton.h"

@interface NavigationBar ()
{
    CGFloat _naviFont;
}
@end

@implementation NavigationBar

- (id)initWithLeftButtonTitle:(NSString *)leftTitle RightButtonTitle:(NSString *)rightTitle NaviTitle:(NSString *)naviTitle NaviFont:(CGFloat)naviFont BgColor:(UIColor *)bgColor
{
    self = [super initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT)];
    if (self)
    {
        self.backgroundColor = bgColor;
        _naviFont = naviFont;
        
        //左侧按钮
        self.leftButton = [[NaviButton alloc] initWithFrame:CGRectMake(0, 0, 44.0f, 44.0f)];
//        self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        self.leftButton.frame = CGRectMake(0, 0, 22.0f, 22.0f);
        self.leftButton.center = CGPointMake(22.0f, STATUS_BAR_HEIGHT + 22.0f);
        if ([leftTitle containsString:@"png"])
        {
            [self.leftButton setImage:[UIImage imageNamed:leftTitle] forState:UIControlStateNormal];
        }
        else
        {
            [self.leftButton setTitle:leftTitle forState:UIControlStateNormal];
            self.leftButton.titleLabel.font = FontOfSize(10.0);
        }
        [self addSubview:self.leftButton];
        
        //右侧按钮
        self.rightButton = [[NaviButton alloc] initWithFrame:CGRectMake(0, 0, 44.0f, 44.0f)];
//        self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        self.rightButton.frame = CGRectMake(0, 0, 22.0f, 22.0f);
        self.rightButton.center = CGPointMake(UI_SCREEN_WIDTH - 22.0f, STATUS_BAR_HEIGHT + 22.0f);
        if ([rightTitle containsString:@"png"])
        {
            [self.rightButton setImage:[UIImage imageNamed:rightTitle] forState:UIControlStateNormal];
        }
        else
        {
            [self.rightButton setTitle:rightTitle forState:UIControlStateNormal];
            self.rightButton.titleLabel.font = FontOfSize(10.0);
        }
        [self addSubview:self.rightButton];
        
        //标题
        float titleWidth = [ManagerTools adaptWidthWithString:naviTitle FontSize:naviFont SizeHeight:self.height - STATUS_BAR_HEIGHT];
        if (titleWidth > UI_SCREEN_WIDTH - 44.0*2) {
            titleWidth = UI_SCREEN_WIDTH - 44.0*2;
        }
        self.titlebutton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.height - STATUS_BAR_HEIGHT, titleWidth, self.height - STATUS_BAR_HEIGHT)];
        self.titlebutton.center = CGPointMake(self.width/2, self.height/2 + STATUS_BAR_HEIGHT/2);
        [self.titlebutton setTitle:naviTitle forState:UIControlStateNormal];
        self.titlebutton.titleLabel.font = FontOfSize(naviFont);
        self.titlebutton.titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.titlebutton];
    }
    
    return self;
}
#pragma mark - 刷新导航标题
- (void)refreshTitleButtonFrameWithNaviTitle:(NSString *)naviTitle
{
    [self.titlebutton setTitle:naviTitle forState:UIControlStateNormal];
    float titleWidth = [ManagerTools adaptWidthWithString:naviTitle FontSize:_naviFont SizeHeight:self.height - STATUS_BAR_HEIGHT];
    self.titlebutton.frame = CGRectMake(0, self.height - STATUS_BAR_HEIGHT, titleWidth > (UI_SCREEN_WIDTH-44*2) ? (UI_SCREEN_WIDTH-44*2):titleWidth, self.height - STATUS_BAR_HEIGHT);
    self.titlebutton.center = CGPointMake(self.width/2, self.height/2 + STATUS_BAR_HEIGHT/2);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
