//
//  BaseViewController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/14.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "BaseViewController.h"
#import "Tools.h"

@interface BaseViewController ()

@end

@implementation BaseViewController
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [MTA trackPageViewBegin:NSStringFromClass([self class])];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MTA trackPageViewEnd:NSStringFromClass([self class])];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}
#pragma mark - 配置导航栏
- (void)configNavigationBarWithNaviTitle:(NSString *)naviTitle naviFont:(CGFloat)naviFont leftBtnTitle:(NSString *)leftBtnTitle rightBtnTitle:(NSString *)rightBtnTitle bgColor:(UIColor *)bgColor
{
    self.navigationBar = [[NavigationBar alloc] initWithLeftButtonTitle:leftBtnTitle RightButtonTitle:rightBtnTitle NaviTitle:naviTitle NaviFont:naviFont BgColor:bgColor];
    if (leftBtnTitle.length > 0)
    {
        [self.navigationBar.leftButton addTarget:self action:@selector(navigationButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    if (rightBtnTitle.length > 0)
    {
        [self.navigationBar.rightButton addTarget:self action:@selector(navigationButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.view addSubview:self.navigationBar];
    
    self.baseNaviDelegate = self;
}
- (void)navigationButtonClicked:(UIButton *)btn
{
    if ([self.baseNaviDelegate respondsToSelector:@selector(baseNaviButtonClickedWithBtnType:)])
    {
        if (btn.center.x < UI_SCREEN_WIDTH/2)
        {
            [self.baseNaviDelegate baseNaviButtonClickedWithBtnType:LeftBtnType];
        }
        else
        {
            [self.baseNaviDelegate baseNaviButtonClickedWithBtnType:RightBtnType];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
