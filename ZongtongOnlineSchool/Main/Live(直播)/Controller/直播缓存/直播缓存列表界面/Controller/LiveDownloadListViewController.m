//
//  LiveDownloadListViewController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/12/27.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "LiveDownloadListViewController.h"
#import "Tools.h"
#import "LiveModel.h"
#import "LiveManager.h"
#import "LiveDownloadListTableView.h"
#import "LiveDownloadPlayViewController.h"

#import "ZFPlayer.h"
#import "ZFDownloadManager.h"

@interface LiveDownloadListViewController ()
@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, strong) LiveDownloadListTableView *tableView;
@end

@implementation LiveDownloadListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self configNavigationBarWithNaviTitle:self.naviTitle naviFont:18.0f leftBtnTitle:@"back.png" rightBtnTitle:@"" bgColor:MAIN_RGB];
    self.listArray = [NSMutableArray arrayWithCapacity:10];
    
    if (self.tableView) {
        self.tableView.dataArray = self.dataArray;
        [self.tableView reloadData];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LiveDownloadListClicked:) name:@"LiveDownloadListClicked" object:nil];
}
- (void)LiveDownloadListClicked:(NSNotification *)noti {
    ZFFileModel *fileModel = (ZFFileModel *)noti.object;
    
    LiveDownloadPlayViewController *livePlayVC = [[LiveDownloadPlayViewController alloc] init];
    livePlayVC.fileModel = fileModel;
    [self.navigationController pushViewController:livePlayVC animated:YES];
}

#pragma mark - 导航按钮点击
- (void)baseNaviButtonClickedWithBtnType:(naviBtnType)btnType {
    if (btnType == LeftBtnType) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (LiveDownloadListTableView *)tableView {
    if (!_tableView) {
        _tableView = [[LiveDownloadListTableView alloc] initWithFrame:CGRectMake(0, self.navigationBar.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - self.navigationBar.height) style:UITableViewStylePlain];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
