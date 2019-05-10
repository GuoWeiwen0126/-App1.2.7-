//
//  NavLoginViewController.m
//  TalkfunSDKDemo
//
//  Created by 孙兆能 on 16/5/16.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import "NavLoginViewController.h"

@interface NavLoginViewController ()

@property (nonatomic,assign) BOOL isFirst;

@end

@implementation NavLoginViewController

- (void)loadView
{
    [super loadView];
    APPLICATION.statusBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.hidden = YES;
//    self.navigationBar.tintColor = GRAYCOLOR;
//    self.isFirst = NO;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    if (self.isFirst) {
//        return;
//    }
//    self.isFirst = YES;
//    
//    NSLog(@"deviceOrientation:%ld",[UIDevice currentDevice].orientation);
//    if (APPLICATION.statusBarOrientation != UIInterfaceOrientationPortrait) {
//    
////        [APPLICATION setStatusBarOrientation:UIInterfaceOrientationPortrait];
//        if (APPLICATION.statusBarOrientation == UIInterfaceOrientationLandscapeLeft) {
//            
//            self.view.transform = CGAffineTransformRotate(self.view.transform, M_PI_2);
//            self.view.bounds = CGRectMake(0, 0, ScreenSize.height, ScreenSize.width);
//            
//        }
//        else
//        {
//            self.view.transform = CGAffineTransformRotate(self.view.transform, - M_PI_2);
//            self.view.bounds = CGRectMake(0, 0, ScreenSize.height, ScreenSize.width);
//        }
//        [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationPortrait) forKey:@"orientation"];
//            NSLog(@"statusss:%f  %f  %f   %f",APPLICATION.statusBarFrame.size.width,APPLICATION.statusBarFrame.size.height,ScreenSize.width,ScreenSize.height);
////        [APPLICATION setStatusBarOrientation:UIInterfaceOrientationPortrait];
////        self.view.bounds = CGRectMake(0, 0, ScreenSize.height, ScreenSize.width);
//        NSLog(@"deviceOrientation:%ld",[UIDevice currentDevice].orientation);
//    }
}

#pragma mark - 禁止旋转
- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
