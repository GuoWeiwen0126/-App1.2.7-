//
//  MKSignUpViewController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2019/3/14.
//  Copyright © 2019年 ZongTongEdu. All rights reserved.
//

#import "MKSignUpViewController.h"
#import "Tools.h"
#import "MKModel.h"
#import "MKManager.h"
#import "MKExamListController.h"
#import "MKRankExamListController.h"
#import "MKGradeController.h"
#import "MKStateController.h"

@interface MKSignUpViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgViewTopSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *MKPlanBtnSpace;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *signUpBtn;
@property (weak, nonatomic) IBOutlet UIButton *mkPlanBtn;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic, strong) ExamMockInfoModel *infoModel;

@end

@implementation MKSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self configNavigationBarWithNaviTitle:@"模考大赛" naviFont:18.0f leftBtnTitle:@"back.png" rightBtnTitle:@"排行榜" bgColor:MAIN_RGB];
    self.imgViewTopSpace.constant = NAVIGATION_BAR_HEIGHT;
    
    [USER_DEFAULTS setBool:YES forKey:IsMKQuestionMode];
    [USER_DEFAULTS synchronize];
    
    [MKManager mkManagerExamMockCurrentInfoWithCompleted:^(id obj) {
        if (obj != nil) {
            NSDictionary *dic = (NSDictionary *)obj;
            if (dic.count > 0) {
                self.MKPlanBtnSpace.constant = 50;
                self.titleLabel.hidden = NO;
                self.timeLabel.hidden = NO;
                self.signUpBtn.hidden = NO;
                self.infoModel = [ExamMockInfoModel yy_modelWithDictionary:dic];
                self.titleLabel.text = self.infoModel.title;
                self.timeLabel.text = [NSString stringWithFormat:@"开考时间：%@",self.infoModel.stime];
                
                if ([ManagerTools timestampJudgeWithStarttime:self.infoModel.stime endTime:self.infoModel.etime] == 1 || [ManagerTools timestampJudgeWithStarttime:self.infoModel.stime endTime:self.infoModel.etime] == 2) {
                    [self.signUpBtn setTitle:@"立即考试" forState:UIControlStateNormal];
                    self.infoModel.isSignUp = YES;
                } else {
                    if ([self checkMKExamIsSignUpWithEiid:[USER_DEFAULTS objectForKey:EIID] infoModel:self.infoModel]) {
                        [self.signUpBtn setTitle:@"报名成功" forState:UIControlStateNormal];
                        self.infoModel.isSignUp = YES;
                    } else {
                        [self.signUpBtn setTitle:@"立即报名" forState:UIControlStateNormal];
                        self.infoModel.isSignUp = NO;
                    }
                }
            } else {
                self.MKPlanBtnSpace.constant = 0;
                self.titleLabel.hidden = YES;
                self.timeLabel.hidden = YES;
                self.signUpBtn.hidden = YES;
            }
        }
    }];
    
//    [MKManager mkManagerExamMockInfoWithEmkid:@"1" Completed:^(id obj) {
//        if (obj != nil) {
//            NSDictionary *dic = (NSDictionary *)obj;
//            self.infoModel = [ExamMockInfoModel yy_modelWithDictionary:dic];
//            self.titleLabel.text = self.infoModel.title;
//            self.timeLabel.text = [NSString stringWithFormat:@"开考时间：%@",self.infoModel.stime];
//            
//            if ([ManagerTools timestampJudgeWithStarttime:self.infoModel.stime endTime:self.infoModel.etime] == 1 || [ManagerTools timestampJudgeWithStarttime:self.infoModel.stime endTime:self.infoModel.etime] == 2) {
//                [self.signUpBtn setTitle:@"开始考试" forState:UIControlStateNormal];
//                self.infoModel.isSignUp = YES;
//            } else {
//                if ([self checkMKExamIsSignUpWithEiid:[USER_DEFAULTS objectForKey:EIID] infoModel:self.infoModel]) {
//                    [self.signUpBtn setTitle:@"报名成功" forState:UIControlStateNormal];
//                    self.infoModel.isSignUp = YES;
//                } else {
//                    [self.signUpBtn setTitle:@"立即报名" forState:UIControlStateNormal];
//                    self.infoModel.isSignUp = NO;
//                }
//            }
//        }
//    }];
    
    self.textView.text = @"模考说明\n\n1、万人模考是总统网校组织的面向所有学员的大型摸底考试，总共进行6轮万人模考。\n2、考试界面及规则完全遵循真实机考，但不设监考，为了达到真正的摸底”效果，请您自觉答写。\n3.初级实务考试时间2小时，经济法考试时间1.5小时。\n4.开始答题后不可暂停或退出，建议您合理安排考试时间。\n5.交卷后即公布个人成绩。\n6.第二天早上10点公布成绩排名和答案，您的排名成绩以您第一次提交的答题成绩为准。公布答案后进行的答题成绩不再进行排名。\n7.活动中的试卷难度接近但不等于真实考试，建议勿因模考成绩心灰意冷或过度自信。\n8.本次活动最终解释权归总统网校所有。\n\n奖励说明\n\n1、第1名  奖励100元现金红包；\n2、第2-5名  奖励总统网校考点手册、精美笔记本；\n3、第6-20名 奖励总统网校真题试卷；\n4、如果总分相同，用时短的排名靠前；\n5、所有奖励请联系客服领取。\n6、每个帐号六轮模考仅能并且只能领取一次奖励，如有作弊行为均视为无效。\n\n注：所有的奖品由本公司提供,与苹果官方无关";
    self.textView.font = FontOfSize(SCREEN_FIT_WITH_DEVICE(12, 14));
}
#pragma mark - 点击报名
- (IBAction)signUpBtnClicked:(id)sender {
    if (self.infoModel.isSignUp == NO) {  //未报名
        if (![ManagerTools existLocalPlistWithFileName:MKExamSignUpPlist]) {
            NSMutableArray *temArray = [NSMutableArray arrayWithCapacity:10];
            [ManagerTools saveLocalPlistFileWtihFile:temArray fileName:MKExamSignUpPlist];
        }
        NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:GetFileFullPath(MKExamSignUpPlist)];
        [array addObject:[NSString stringWithFormat:@"%@-%ld-%ld",[USER_DEFAULTS objectForKey:EIID],(long)self.infoModel.emkid,(long)self.infoModel.year]];
        [ManagerTools saveLocalPlistFileWtihFile:array fileName:MKExamSignUpPlist];
        [XZCustomWaitingView showAutoHidePromptView:@"报名成功\n请您准时参加考试" background:nil showTime:1.0];
        self.infoModel.isSignUp = YES;
        [self.signUpBtn setTitle:@"报名成功" forState:UIControlStateNormal];
    } else {
        if ([ManagerTools timestampJudgeWithStarttime:self.infoModel.stime endTime:self.infoModel.etime] == 1 || [ManagerTools timestampJudgeWithStarttime:self.infoModel.stime endTime:self.infoModel.etime] == 2) {
            MKStateController *mkStateVC = [[MKStateController alloc] init];
            mkStateVC.emkid = self.infoModel.emkid;
            mkStateVC.naviTitle = self.infoModel.title;
            [self.navigationController pushViewController:mkStateVC animated:YES];
        } else {
            [XZCustomWaitingView showAutoHidePromptView:@"考试暂未开始\n请您积极备考" background:nil showTime:1.0];
        }
    }
}
#pragma mark - 点击模考安排
- (IBAction)mkPlanBtnClicked:(id)sender {
    MKExamListController *mkExamVC = [[MKExamListController alloc] init];
    [self.navigationController pushViewController:mkExamVC animated:YES];
}

- (BOOL)checkMKExamIsSignUpWithEiid:(NSString *)eiid infoModel:(ExamMockInfoModel *)infoModel
{
    NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:GetFileFullPath(MKExamSignUpPlist)];
    for (NSString *str in array) {
        if ([str isEqualToString:[NSString stringWithFormat:@"%@-%ld-%ld",eiid,(long)infoModel.emkid,(long)infoModel.year]]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark -
#pragma mark - 导航按钮
- (void)baseNaviButtonClickedWithBtnType:(naviBtnType)btnType
{
    if (btnType == LeftBtnType) {
        [USER_DEFAULTS setBool:NO forKey:IsMKQuestionMode];
        [USER_DEFAULTS synchronize];
        [self.navigationController popViewControllerAnimated:YES];
    } else if (btnType == RightBtnType) {
        MKRankExamListController *mkExamRanklistVC = [[MKRankExamListController alloc] init];
        [self.navigationController pushViewController:mkExamRanklistVC animated:YES];
    }
}

@end
