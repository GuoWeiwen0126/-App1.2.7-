//
//  MKStateController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2019/3/20.
//  Copyright © 2019年 ZongTongEdu. All rights reserved.
//

#import "MKStateController.h"
#import "Tools.h"
#import "MKModel.h"
#import "MKManager.h"
#import "MKQuestionViewController.h"
#import "MKStateCollectionView.h"
#import "MKGradeController.h"

@interface MKStateController ()
{
    NSMutableArray *_gradeArray;
}
@property (nonatomic, strong) ExamMockInfoModel *infoModel;
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) MKStateCollectionView *collectionView;
@end

@implementation MKStateController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //获取模考详细
    [MKManager mkManagerExamMockInfoWithEmkid:[NSString stringWithFormat:@"%ld",(long)self.emkid] Completed:^(id obj) {
        if (obj != nil) {
            NSDictionary *dic = (NSDictionary *)obj;
            self.infoModel = [ExamMockInfoModel yy_modelWithDictionary:dic];
            //获取用户成绩
            [MKManager mkManagerExamMockGetUserScoreWithUid:[USER_DEFAULTS objectForKey:User_uid] emkid:[NSString stringWithFormat:@"%ld",(long)self.emkid] Completed:^(id obj) {
                if (obj != nil) {
                    NSArray *array = (NSArray *)obj;
                    NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:10];
                    _gradeArray = [NSMutableArray arrayWithCapacity:10];
                    for (NSDictionary *dic in array) {
                        EmkUserGradeModel *userGradeModel = [EmkUserGradeModel yy_modelWithDictionary:dic];
                        [_gradeArray addObject:userGradeModel];
                    }
                    for (EmkInfoListModel *infoListModel in self.infoModel.basicList) {
                        for (EmkUserGradeModel *model in _gradeArray) {
                            if (model.emkiid == infoListModel.emkiId) {
                                if (model.eid > 0 && model.estate == 2) {
                                    infoListModel.isJoinedExam = YES;
                                }
                                [dataArray addObject:infoListModel];
                            }
                        }
                    }
                    
                    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
                    CGFloat space = SCREEN_FIT_WITH_DEVICE(20, 40);
                    layout.itemSize = CGSizeMake((UI_SCREEN_WIDTH - space*4)/2, (UI_SCREEN_WIDTH - space*4)/2 + 30);
                    layout.minimumInteritemSpacing = 20;
                    layout.minimumLineSpacing = 40;
                    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
                    if (!self.collectionView) {
                        self.collectionView = [[MKStateCollectionView alloc] initWithFrame:CGRectMake(20, self.stateLabel.bottom + 20, UI_SCREEN_WIDTH - 20*2, UI_SCREEN_HEIGHT - self.navigationBar.height - 10 - self.stateLabel.height - 20) collectionViewLayout:layout];
                        [self.view addSubview:self.collectionView];
                    }
                    self.collectionView.dataArray = dataArray;
                    [self.collectionView reloadData];
                }
            }];
        }
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self configNavigationBarWithNaviTitle:self.naviTitle naviFont:18.0f leftBtnTitle:@"back.png" rightBtnTitle:@"" bgColor:MAIN_RGB];
    
    self.stateLabel = [[UILabel alloc] init];
    self.stateLabel.text = @"考试说明\n\n1、万人模考是总统网校组织的面向所有学员的大型摸底考试，总共进行6轮万人模考。\n2、考试界面及规则完全遵循真实机考，但不设监考，为了达到真正的摸底”效果，请您自觉答写。\n3.初级实务考试时间2小时，经济法考试时间1.5小时。\n4.开始答题后不可暂停或退出，建议您合理安排考试时间。\n5.交卷后即公布个人成绩。\n6.第二天早上10点公布成绩排名和答案，您的排名成绩以您第一次提交的答题成绩为准。公布答案后进行的答题成绩不再进行排名。\n7.活动中的试卷难度接近但不等于真实考试，建议勿因模考成绩心灰意冷或过度自信。\n8.本次活动最终解释权归总统网校所有。";
    self.stateLabel.font = FontOfSize(SCREEN_FIT_WITH_DEVICE(12, 14));
    self.stateLabel.numberOfLines = 0;
    self.stateLabel.frame = CGRectMake(20, self.navigationBar.bottom + 10, UI_SCREEN_WIDTH - 20*2, [ManagerTools adaptHeightWithString:self.stateLabel.text FontSize:SCREEN_FIT_WITH_DEVICE(12, 14) SizeWidth:UI_SCREEN_WIDTH - 20*2]);
    [self.view addSubview:self.stateLabel];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MKStateCollectionViewCellClicked:) name:@"MKStateCollectionViewCellClicked" object:nil];
}
#pragma mark - 点击科目，开始考试
- (void)MKStateCollectionViewCellClicked:(NSNotification *)noti
{
    [USER_DEFAULTS setObject:self.infoModel.stime forKey:MKNowExamSTime];
    [USER_DEFAULTS synchronize];
    EmkInfoListModel *infoListModel = (EmkInfoListModel *)noti.object;
    if (infoListModel.isJoinedExam) {
        [USER_DEFAULTS setBool:YES forKey:MKQuestion_IsAnalyse];
        [USER_DEFAULTS synchronize];
        MKGradeController *gradeVC = [[MKGradeController alloc] init];
        gradeVC.naviTitle = self.naviTitle;
        gradeVC.emkid = infoListModel.emkid;
        gradeVC.isLookGrade = YES;
        [self.navigationController pushViewController:gradeVC animated:YES];
    } else {
        [USER_DEFAULTS setBool:NO forKey:MKQuestion_IsAnalyse];
        [USER_DEFAULTS synchronize];
        MKQuestionViewController *mkQuestionVC = [[MKQuestionViewController alloc] init];
        mkQuestionVC.naviTitle = self.naviTitle;
        mkQuestionVC.gradeVCNaviTitle = self.naviTitle;
        for (EmkUserGradeModel *userGradeModel in _gradeArray) {
            if (userGradeModel.emkiid == infoListModel.emkiId) {
                mkQuestionVC.temEmkid = userGradeModel.emkid;
                mkQuestionVC.temEmkiid = userGradeModel.emkiid;
                mkQuestionVC.temEid = userGradeModel.eid;
                break;
            }
        }
        [self.navigationController pushViewController:mkQuestionVC animated:YES];
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
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
