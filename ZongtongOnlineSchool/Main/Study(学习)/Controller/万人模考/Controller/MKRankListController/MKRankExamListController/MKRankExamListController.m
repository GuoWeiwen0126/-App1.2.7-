//
//  MKRankExamListController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2019/3/27.
//  Copyright © 2019年 ZongTongEdu. All rights reserved.
//

#import "MKRankExamListController.h"
#import "Tools.h"
#import "MKModel.h"
#import "MKManager.h"
#import "MKRankExamListTableView.h"
#import "MKRankListController.h"

@interface MKRankExamListController ()
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) MKRankExamListTableView *tableView;
@end

@implementation MKRankExamListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self configNavigationBarWithNaviTitle:@"排行榜" naviFont:18.0f leftBtnTitle:@"back.png" rightBtnTitle:@"" bgColor:MAIN_RGB];
    
    [MKManager mkManagerExamMockEmkListWithPast:@"0" Completed:^(id obj) {
        if (obj != nil) {
            self.dataArray = [NSMutableArray arrayWithCapacity:10];
            for (NSDictionary *dic in (NSArray *)obj) {
                EmkListModel *listModel = [EmkListModel yy_modelWithDictionary:dic];
                [self.dataArray addObject:listModel];
            }
            self.tableView = [[MKRankExamListTableView alloc] initWithFrame:CGRectMake(0, self.navigationBar.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - self.navigationBar.height) style:UITableViewStylePlain dataArray:self.dataArray];
            [self.view addSubview:self.tableView];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MKRankExamListRankBtnClicked:) name:@"MKRankExamListRankBtnClicked" object:nil];
        }
    }];
}
#pragma mark - 查看排行
- (void)MKRankExamListRankBtnClicked:(NSNotification *)noti
{
    EmkListModel *listModel = (EmkListModel *)noti.object;
    MKRankListController *rankVC = [[MKRankListController alloc] init];
    rankVC.emkListModel = listModel;
    [self.navigationController pushViewController:rankVC animated:YES];
    return;
    if ([ManagerTools timestampJudgeWithStarttime:listModel.stime endTime:listModel.etime] == 1 || [ManagerTools timestampJudgeWithStarttime:listModel.stime endTime:listModel.etime] == 2) {
        MKRankListController *rankVC = [[MKRankListController alloc] init];
        rankVC.emkListModel = listModel;
        [self.navigationController pushViewController:rankVC animated:YES];
    } else {
        [XZCustomWaitingView showAutoHidePromptView:@"暂未排行\n请考试结束后查看" background:nil showTime:1.0];
    }
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

@end
