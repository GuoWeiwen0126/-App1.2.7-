//
//  MKHistoryController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2019/3/15.
//  Copyright © 2019年 ZongTongEdu. All rights reserved.
//

#import "MKHistoryController.h"
#import "Tools.h"
#import "MKModel.h"
#import "MKManager.h"
#import "MKHistoryListTableView.h"
#import "MKStateController.h"

@interface MKHistoryController ()

@end

@implementation MKHistoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self configNavigationBarWithNaviTitle:@"历年模考" naviFont:18.0f leftBtnTitle:@"back.png" rightBtnTitle:@"" bgColor:MAIN_RGB];
    
    [MKManager mkManagerExamMockEmkListWithPast:@"1" Completed:^(id obj) {
        if (obj != nil) {
            NSMutableArray *listArray = [NSMutableArray arrayWithCapacity:10];
            for (NSDictionary *dic in (NSArray *)obj) {
                EmkListModel *listModel = [EmkListModel yy_modelWithDictionary:dic];
                [listArray addObject:listModel];
            }
            if (listArray.count == 0) {
                [XZCustomWaitingView showAutoHidePromptView:@"暂无模考信息" background:nil showTime:1.0];
                return;
            }
            NSInteger year = 0;
            NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:10];
            NSMutableArray *temArray = [NSMutableArray arrayWithCapacity:10];
            for (EmkListModel *listModel in listArray) {
                if (year != listModel.year) {
                    year = listModel.year;
                    if (temArray.count != 0) {
                        [dataArray addObject:temArray.mutableCopy];
                    }
                    [temArray removeAllObjects];
                    [temArray addObject:listModel];
                } else {
                    [temArray addObject:listModel];
                }
            }
            [dataArray addObject:temArray.mutableCopy];
            
            MKHistoryListTableView *tableView = [[MKHistoryListTableView alloc] initWithFrame:CGRectMake(0, self.navigationBar.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - self.navigationBar.height) style:UITableViewStylePlain dataArray:dataArray];
            [self.view addSubview:tableView];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MKExamHistoryListTableViewClicked:) name:@"MKExamHistoryListTableViewClicked" object:nil];
        }
    }];
}
#pragma mark - 点击历年模考列表
- (void)MKExamHistoryListTableViewClicked:(NSNotification *)noti
{
    EmkListModel *listModel = (EmkListModel *)noti.object;
    MKStateController *mkStateVC = [[MKStateController alloc] init];
    mkStateVC.emkid = listModel.emkid;
    mkStateVC.naviTitle = listModel.title;
    [self.navigationController pushViewController:mkStateVC animated:YES];
}

#pragma mark -
#pragma mark - 导航按钮
- (void)baseNaviButtonClickedWithBtnType:(naviBtnType)btnType
{
    if (btnType == LeftBtnType) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if (btnType == RightBtnType) {
        
    }
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
