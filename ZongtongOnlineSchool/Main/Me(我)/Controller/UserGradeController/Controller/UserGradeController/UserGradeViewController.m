//
//  UserGradeViewController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/12/10.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "UserGradeViewController.h"
#import "Tools.h"
#import "UserGradeHeaderView.h"
#import "UserGradeTableView.h"
#import "UserGradeManager.h"
#import "DataDownloadDetailViewController.h"

@interface UserGradeViewController ()
@property (nonatomic, strong) UserGradeHeaderView *headerView;
@property (nonatomic, strong) UserGradeTableView *tableView;
@end

@implementation UserGradeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self configNavigationBarWithNaviTitle:@"积分任务" naviFont:18.0f leftBtnTitle:@"back.png" rightBtnTitle:@"明细" bgColor:MAIN_RGB];
    
    [self reloadView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UserGradeTableViewClicked:) name:@"UserGradeTableViewClicked" object:nil];
}
#pragma mark - 获取积分数量、刷新界面
- (void)reloadView {
    [UserGradeManager userGradeManagerUserGradeNumberWithUid:[USER_DEFAULTS objectForKey:User_uid] completed:^(id obj) {
        if (obj != nil) {
            self.headerView.gradeLabel.text = [NSString stringWithFormat:@"%ld",(long)[obj integerValue]];
            [self.tableView reloadData];
        }
    }];
}
#pragma mark - 通知方法
- (void)UserGradeTableViewClicked:(NSNotification *)noti
{
    NSIndexPath *indexPath = (NSIndexPath *)noti.object;
    NSArray *shareArray = @[@(UMSocialPlatformType_WechatTimeLine),
                            @(UMSocialPlatformType_WechatSession),
                            @(UMSocialPlatformType_Qzone),
                            @(UMSocialPlatformType_QQ)];
    //显示分享面板
    [UMSocialUIManager setPreDefinePlatforms:@[shareArray[indexPath.row]]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        NSLog(@"分享平台：%ld",(long)platformType);
        [self shareWebPageToPlatformType:platformType indexPath:indexPath];
    }];
}
#pragma mark - 分享功能
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType indexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UMSocialMessageObject *shareMessage = [UMSocialMessageObject messageObject];
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"总统网校" descr:@"提供各种职业考试的网络课程、复习资料、历年真题和考试资讯" thumImage:nil];
        shareObject.webpageUrl = ShareAppURL;
        shareMessage.shareObject = shareObject;
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:shareMessage currentViewController:self completion:^(id result, NSError *error) {
            if (error) {
                NSLog(@"************Share fail with error %@*********",error);
                [XZCustomWaitingView showAutoHidePromptView:@"分享失败" background:nil showTime:1.0];
            } else {
                NSLog(@"response data is %@",result);
            }
        }];
        //分享后增加积分
        [USER_DEFAULTS setObject:[NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]] forKey:UserGradeShareArray[indexPath.row]];
        [USER_DEFAULTS synchronize];
        //积分获取
        /*
         安卓APP评价 = 1,
         分享微信朋友圈 = 2,
         分享微信群 = 11,
         分享QQ朋友圈 = 3,
         分享QQ = 4,
         集人气 = 5,
         在线购买产品 = 6,
         IOSAPP评价 = 7,
         */
        [UserGradeManager userGradeManagerUserGradeAddWithExamid:[USER_DEFAULTS objectForKey:EIID] courseid:[USER_DEFAULTS objectForKey:COURSEID] uid:[USER_DEFAULTS objectForKey:User_uid] source:@[@"2", @"11", @"3", @"4"][indexPath.row] completed:^(id obj) {
            if (obj != nil) {
                [self reloadView];
            }
        }];
    } else {
        //获取分享码
        [UserGradeManager userGradeManagerShareNumberWithUid:[USER_DEFAULTS objectForKey:User_uid] courseid:@"0" shareType:@"1" completed:^(id obj) {
            if (obj != nil) {
                NSDictionary *shareDic = (NSDictionary *)obj;
                NSString *shareURL = ShareInfoNumberURL(shareDic[@"shareNum"], [USER_DEFAULTS objectForKey:EIID]);
                NSLog(@"分享地址：%@",shareURL);
                UMSocialMessageObject *shareMessage = [UMSocialMessageObject messageObject];
                UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:[NSString stringWithFormat:@"老铁！我要下载%@备考资料，快帮帮我！",[USER_DEFAULTS objectForKey:COURSEIDNAME]] descr:@"（点击链接）快来为好友集人气，一次人气等于五个积分！" thumImage:nil];
                shareObject.webpageUrl = shareURL;
                shareMessage.shareObject = shareObject;
                [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:shareMessage currentViewController:self completion:^(id result, NSError *error) {
                    if (error) {
                        NSLog(@"************Share fail with error %@*********",error);
                        [XZCustomWaitingView showAutoHidePromptView:@"分享失败" background:nil showTime:1.0];
                    } else {
                        NSLog(@"response data is %@",result);
                    }
                }];
            }
        }];
    }
}

#pragma mark -
#pragma mark - 导航按钮
- (void)baseNaviButtonClickedWithBtnType:(naviBtnType)btnType
{
    if (btnType == LeftBtnType) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        //明细
        DataDownloadDetailViewController *detailVC = [[DataDownloadDetailViewController alloc] init];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}
- (UserGradeHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[UserGradeHeaderView alloc] initWithFrame:CGRectMake(0, self.navigationBar.bottom, UI_SCREEN_WIDTH, 120)];
        [self.view addSubview:_headerView];
    }
    return _headerView;
}
- (UserGradeTableView *)tableView {
    if (!_tableView) {
        _tableView = [[UserGradeTableView alloc] initWithFrame:CGRectMake(0, self.headerView.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - self.navigationBar.height - self.headerView.height) style:UITableViewStylePlain];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
