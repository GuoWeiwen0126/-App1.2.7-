//
//  GuideViewController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/3/26.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "GuideViewController.h"
#import "Tools.h"
#import "LoginViewController.h"
#import "TabbarViewController.h"

@interface GuideViewController ()
{
    NSArray *_imgArray;
}
@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollView;
@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _imgArray = [NSArray arrayWithObjects:@"Guide1.png",@"Guide2.png",@"Guide3.png",@"Guide4.png", nil];
    
    self.bgScrollView.contentSize = CGSizeMake(UI_SCREEN_WIDTH * _imgArray.count, UI_SCREEN_HEIGHT);
    self.bgScrollView.showsHorizontalScrollIndicator = NO;
    self.bgScrollView.pagingEnabled = YES;
    for (int i = 0; i < _imgArray.count; i ++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH * i, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
        imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@",[self getGuideImageName],_imgArray[i]]];
        [self.bgScrollView addSubview:imgView];
        if (i == _imgArray.count - 1) {
            UIButton *startBtn = [[UIButton alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH/4, UI_SCREEN_HEIGHT - 100, UI_SCREEN_WIDTH/2, UI_SCREEN_WIDTH/2/4)];
            startBtn.center = CGPointMake(UI_SCREEN_WIDTH/2, UI_SCREEN_HEIGHT * 0.93 - startBtn.height/2);
            [startBtn addTarget:self action:@selector(startBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            [imgView addSubview:startBtn];
            imgView.userInteractionEnabled = YES;
        }
    }
}
#pragma mark - 立即体验
- (void)startBtnClicked
{
    //清空window上残留的view
    [self.view.window.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //回到登录界面并设置为根视图
    if (![USER_DEFAULTS objectForKey:User_uid] || IsLocalAccount) {
        LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:NSStringFromClass([LoginViewController class]) bundle:nil];
        UINavigationController *newNavi = [[UINavigationController alloc] initWithRootViewController:loginVC];
        loginVC.navigationController.navigationBar.hidden = YES;
        [UIApplication sharedApplication].delegate.window.rootViewController = newNavi;
    } else {
        TabbarViewController *tabbarVC = [[TabbarViewController alloc] init];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:tabbarVC];
        tabbarVC.navigationController.navigationBar.hidden = YES;
        [UIApplication sharedApplication].delegate.window.rootViewController = navi;
    }
}
#pragma mark - 图片名称
- (NSString *)getGuideImageName
{
    if (SCREEN_IS_3_5) {
        return @"iPhone4";
    } else if (SCREEN_IS_4_0) {
        return @"iPhone5";
    } else if (SCREEN_IS_4_7) {
        return @"iPhone6";
    } else if (SCREEN_IS_5_5) {
        return @"iPhone6P";
    } else if (IS_IPHONEX) {
        return @"iPhoneX";
    } else {
        return @"iPad";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
