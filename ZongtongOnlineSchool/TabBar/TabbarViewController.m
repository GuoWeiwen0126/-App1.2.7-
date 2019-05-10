//
//  TabbarViewController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/21.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "TabbarViewController.h"
#import "Tools.h"
#import "StudyViewController.h"
#import "CourseViewController.h"
#import "LiveViewController.h"
#import "MeViewController.h"

@interface TabbarViewController ()

@end

@implementation TabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    StudyViewController    *studyVC    = [[StudyViewController alloc] init];
    CourseViewController   *courseVC   = [[CourseViewController alloc] init];
    LiveViewController     *liveVC     = [[LiveViewController alloc] init];
    MeViewController       *meVC       = [[MeViewController alloc] init];
    
    UITabBarItem *studyItem = [[UITabBarItem alloc] initWithTitle:@"主页" image:[[UIImage imageNamed:@"shouye1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"shouye.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    UITabBarItem *courseItem = [[UITabBarItem alloc] initWithTitle:@"课程" image:[[UIImage imageNamed:@"kecheng1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"kecheng.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    UITabBarItem *liveItem = [[UITabBarItem alloc] initWithTitle:@"直播" image:[[UIImage imageNamed:@"zhibo1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"zhibo.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    UITabBarItem *meItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:[[UIImage imageNamed:@"wode1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"wode.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    studyVC.tabBarItem    = studyItem;
    courseVC.tabBarItem   = courseItem;
    liveVC.tabBarItem     = liveItem;
    meVC.tabBarItem       = meItem;
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:MAIN_RGB_TEXT} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:MAIN_RGB} forState:UIControlStateSelected];
    
    self.viewControllers = @[studyVC, courseVC, liveVC, meVC];
    self.selectedIndex = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
