//
//  MKRankListController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2019/3/14.
//  Copyright © 2019年 ZongTongEdu. All rights reserved.
//

#import "MKRankListController.h"
#import "Tools.h"
#import "MKRankListTableView.h"
#import "MKModel.h"
#import "MKManager.h"

@interface MKRankListController ()
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) MKRankListTableView *tableView;

@end

@implementation MKRankListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self configNavigationBarWithNaviTitle:@"排行榜" naviFont:18.0f leftBtnTitle:@"back.png" rightBtnTitle:@"" bgColor:MAIN_RGB];
    
    self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.navigationBar.bottom, UI_SCREEN_WIDTH, UI_SCREEN_WIDTH * 0.44)];
    self.imgView.image = [UIImage imageNamed:@"mkrankbanner.png"];
    [self.view addSubview:self.imgView];
    
    [MKManager mkManagerExamMockRankingGetRankingWithEmkid:[NSString stringWithFormat:@"%ld",(long)self.emkListModel.emkid] Completed:^(id obj) {
        if (obj != nil) {
            NSArray *array = (NSArray *)obj;
            NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:10];
            for (NSDictionary *dic in array) {
                MKRankModel *rankModel = [MKRankModel yy_modelWithDictionary:dic];
                [dataArray addObject:rankModel];
            }
            if (dataArray.count == 0) {
                [XZCustomWaitingView showAutoHidePromptView:@"暂无排行榜信息" background:nil showTime:1.0];
                return;
            }
            
            self.tableView = [[MKRankListTableView alloc] initWithFrame:CGRectMake(0, self.imgView.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - self.navigationBar.height - self.imgView.height) style:UITableViewStylePlain dataArray:dataArray];
            [self.view addSubview:self.tableView];
        }
    }];
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
