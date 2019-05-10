//
//  CourseOptionNextViewController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/14.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "CourseOptionNextViewController.h"
#import "Tools.h"
#import "CourseOptionModel.h"
#import "CourseOptionManager.h"
#import "CourseOptionNextTableView.h"

@interface CourseOptionNextViewController ()
{
    NSArray *_courseIdArray;
}
@property (nonatomic, strong) CourseOptionNextTableView *tableView;

@end

@implementation CourseOptionNextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configNavigationBarWithNaviTitle:@"考试科目管理" naviFont:18.0 leftBtnTitle:@"back.png" rightBtnTitle:@"保存" bgColor:MAIN_RGB];
    
    [self getCourseList];
}
#pragma mark - 获取科目列表
- (void)getCourseList
{
    [CourseOptionManager CourseOptionCourseListCompleted:^(id obj) {
        if (obj == nil) {
            [XZCustomWaitingView hideWaitingMaskView];
            return;
        } else {
            [self configTableViewWithData:(NSArray *)obj];
        }
    }];
}
#pragma mark - 配置数组
- (void)configTableViewWithData:(NSArray *)dataArray
{
    NSMutableArray *listArray   = [NSMutableArray arrayWithCapacity:20];
    NSMutableArray *commonArray = [NSMutableArray arrayWithCapacity:20];
    NSMutableArray *publicArray = [NSMutableArray arrayWithCapacity:20];
    NSMutableArray *majorArray  = [NSMutableArray arrayWithCapacity:20];
    for (NSDictionary *dic in dataArray)
    {
        CourseListModel *model = [CourseListModel modelWithDic:dic courseIdArray:[CourseOptionManager getLocalPlistFileArrayWithTemEiid:[[USER_DEFAULTS objectForKey:EIID] integerValue]]];
        switch (model.clPublic) {
            case 0:  //不区分
            {
                [commonArray addObject:model];
            }
                break;
            case 1:  //公共科目
            {
                [publicArray addObject:model];
            }
                break;
            case 2:  //专业科目
            {
                [majorArray addObject:model];
            }
                break;
                
            default:
                break;
        }
    }
    [listArray addObject:commonArray];
    [listArray addObject:publicArray];
    [listArray addObject:majorArray];
    [XZCustomWaitingView hideWaitingMaskView];
    self.tableView = [[CourseOptionNextTableView alloc] initWithFrame:CGRectMake(0, self.navigationBar.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - self.navigationBar.height) style:UITableViewStylePlain dataArray:listArray];
    [self.view addSubview:self.tableView];
}

#pragma mark - 导航按钮
- (void)baseNaviButtonClickedWithBtnType:(naviBtnType)btnType
{
    if (btnType == LeftBtnType)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else  //保存courseId
    {
        [XZCustomWaitingView showAdaptiveWaitingMaskView:@"正在保存" iconName:LoadingImage iconNumber:4];
        //整合数组
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
        for (NSMutableArray *temArray in self.tableView.dataArray)
        {
            for (CourseListModel *temModel in temArray)
            {
                [array addObject:temModel];
            }
        }
        //根据 order 数组排序
        NSSortDescriptor *courseIdOrderDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
        [array sortUsingDescriptors:@[courseIdOrderDescriptor]];
        //添加勾选的科目
        NSMutableArray *listArray = [NSMutableArray arrayWithCapacity:10];
        for (CourseListModel *listModel in array)
        {
            NSLog(@"---%d---%@---%ld---",listModel.isSelected,listModel.title,(long)listModel.courseId);
            if (listModel.isSelected == YES)
            {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setObject:[NSString stringWithFormat:@"%ld",(long)listModel.courseId] forKey:@"courseId"];
                [dic setObject:listModel.title forKey:@"title"];
                [dic setObject:[NSString stringWithFormat:@"%ld",(long)listModel.clPublic] forKey:@"clPublic"];
                [dic setObject:[NSString stringWithFormat:@"%ld",(long)listModel.order]    forKey:@"order"];
                [listArray addObject:dic];
            }
        }
        
        [CourseOptionManager CourseOptionSaveCourseIdWithVC:self array:listArray isCentCourse:YES isUserCenter:self.isUserCenter];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
