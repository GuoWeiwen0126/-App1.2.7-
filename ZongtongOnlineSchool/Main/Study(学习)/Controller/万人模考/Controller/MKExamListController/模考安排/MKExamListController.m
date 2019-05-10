//
//  MKExamListController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2019/3/15.
//  Copyright © 2019年 ZongTongEdu. All rights reserved.
//

#import "MKExamListController.h"
#import "Tools.h"
#import "MKHistoryController.h"
#import "MKModel.h"
#import "MKManager.h"
#import "MKExamListTableView.h"
#import "MKStateController.h"

@interface MKExamListController ()
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) MKExamListTableView *tableView;
@end

@implementation MKExamListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self configNavigationBarWithNaviTitle:@"模考安排" naviFont:18.0f leftBtnTitle:@"back.png" rightBtnTitle:@"历年模考" bgColor:MAIN_RGB];
    
    [MKManager mkManagerExamMockEmkListWithPast:@"0" Completed:^(id obj) {
        if (obj != nil) {
            self.dataArray = [NSMutableArray arrayWithCapacity:10];
            for (NSDictionary *dic in (NSArray *)obj) {
                EmkListModel *listModel = [EmkListModel yy_modelWithDictionary:dic];
                for (NSString *str in [NSMutableArray arrayWithContentsOfFile:GetFileFullPath(MKExamSignUpPlist)]) {
                    if ([str isEqualToString:[NSString stringWithFormat:@"%@-%ld-%ld",[USER_DEFAULTS objectForKey:EIID],(long)listModel.emkid,(long)listModel.year]]) {
                        listModel.isSignUp = YES;
                        break;
                    }
                }
                [self.dataArray addObject:listModel];
            }
            self.tableView = [[MKExamListTableView alloc] initWithFrame:CGRectMake(0, self.navigationBar.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - self.navigationBar.height) style:UITableViewStylePlain dataArray:self.dataArray];
            [self.view addSubview:self.tableView];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MKExamListTableViewTopBtnClicked:) name:@"MKExamListTableViewTopBtnClicked" object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MKExamListExamBtnClicked:) name:@"MKExamListExamBtnClicked" object:nil];
        }
    }];
}
#pragma mark - 点击HeaderView
- (void)MKExamListTableViewTopBtnClicked:(NSNotification *)noti
{
    EmkListModel *listModel = (EmkListModel *)noti.object;
    for (EmkListModel *temModel in self.dataArray) {
        if (temModel.emkid == listModel.emkid) {
            temModel.isOpen = !temModel.isOpen;
            break;
        }
    }
    self.tableView.dataArray = self.dataArray;
    [self.tableView reloadData];
}
#pragma mark - 点击开始考试
- (void)MKExamListExamBtnClicked:(NSNotification *)noti
{
    EmkListModel *listModel = (EmkListModel *)noti.object;
    if ([ManagerTools timestampJudgeWithStarttime:listModel.stime endTime:listModel.etime] == 1 || [ManagerTools timestampJudgeWithStarttime:listModel.stime endTime:listModel.etime] == 2) {  //开始考试
        MKStateController *mkStateVC = [[MKStateController alloc] init];
        mkStateVC.emkid = listModel.emkid;
        mkStateVC.naviTitle = listModel.title;
        [self.navigationController pushViewController:mkStateVC animated:YES];
    } else {  //暂未开始
        if (!listModel.isSignUp) {  //未报名，先报名
            if (![ManagerTools existLocalPlistWithFileName:MKExamSignUpPlist]) {
                NSMutableArray *temArray = [NSMutableArray arrayWithCapacity:10];
                [ManagerTools saveLocalPlistFileWtihFile:temArray fileName:MKExamSignUpPlist];
            }
            NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:GetFileFullPath(MKExamSignUpPlist)];
            [array addObject:[NSString stringWithFormat:@"%@-%ld-%ld",[USER_DEFAULTS objectForKey:EIID],(long)listModel.emkid,(long)listModel.year]];
            [ManagerTools saveLocalPlistFileWtihFile:array fileName:MKExamSignUpPlist];
            
            for (EmkListModel *model in self.dataArray) {
                if (model.emkid == listModel.emkid) {
                    model.isSignUp = YES;
                    break;
                }
            }
            [self.tableView reloadData];
            [XZCustomWaitingView showAutoHidePromptView:@"报名成功\n请您准时参加考试" background:nil showTime:1.0];
        } else {
            [XZCustomWaitingView showAutoHidePromptView:@"考试暂未开始\n请您积极备考" background:nil showTime:1.0];
        }
    }
}

#pragma mark -
#pragma mark - 导航按钮
- (void)baseNaviButtonClickedWithBtnType:(naviBtnType)btnType
{
    if (btnType == LeftBtnType) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if (btnType == RightBtnType) {
        MKHistoryController *mkHistoryVC = [[MKHistoryController alloc] init];
        [self.navigationController pushViewController:mkHistoryVC animated:YES];
    }
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
