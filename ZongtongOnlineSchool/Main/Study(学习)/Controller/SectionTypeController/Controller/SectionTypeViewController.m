//
//  SectionTypeViewController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2019/1/30.
//  Copyright © 2019年 ZongTongEdu. All rights reserved.
//

#import "SectionTypeViewController.h"
#import "Tools.h"
#import "SectionManager.h"
#import "SecTypeModel.h"
#import "SectionTypeTableView.h"
#import "SectionViewController.h"

@interface SectionTypeViewController ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation SectionTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self configNavigationBarWithNaviTitle:@"2018年题库" naviFont:18.0f leftBtnTitle:@"back.png" rightBtnTitle:@"" bgColor:MAIN_RGB];
    
    [SectionManager sectionManagerBasicListWithYear:@"2018" completed:^(id obj) {
        if (obj == nil) {
            return;
        } else {
            self.dataArray = [NSMutableArray arrayWithCapacity:10];
            for (NSDictionary *dic in (NSArray *)obj) {
                SecTypeModel *model = [SecTypeModel yy_modelWithDictionary:dic];
                [self.dataArray addObject:model];
            }
            SectionTypeTableView *tableView = [[SectionTypeTableView alloc] initWithFrame:CGRectMake(0, self.navigationBar.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - self.navigationBar.height) style:UITableViewStylePlain array:self.dataArray];
            [self.view addSubview:tableView];
        }
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SectionTypeCellClicked:) name:@"SectionTypeCellClicked" object:nil];
}
- (void)SectionTypeCellClicked:(NSNotification *)noti
{
    SecTypeModel *typeModel = (SecTypeModel *)noti.object;
    SectionViewController *sectionVC = [[SectionViewController alloc] init];
    sectionVC.naviTitle = typeModel.title;
    sectionVC.sid = [NSString stringWithFormat:@"%ld",(long)typeModel.sfid];
    sectionVC.type = self.type;
    [self.navigationController pushViewController:sectionVC animated:YES];
}

#pragma mark -
#pragma mark - 导航按钮
- (void)baseNaviButtonClickedWithBtnType:(naviBtnType)btnType
{
    if (btnType == LeftBtnType) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
