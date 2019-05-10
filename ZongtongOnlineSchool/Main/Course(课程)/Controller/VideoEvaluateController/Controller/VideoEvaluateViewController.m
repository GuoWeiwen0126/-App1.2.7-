//
//  VideoEvaluateViewController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/1.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "VideoEvaluateViewController.h"
#import "Tools.h"
#import "VideoManager.h"
#import "VideoDetailModel.h"
#import "VideoEvaluateTableView.h"

@interface VideoEvaluateViewController () <VideoEvaluateTableViewDelegate>
{
    NSString *_vaid;
    NSString *_qvcid;
}
@end

@implementation VideoEvaluateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = MAIN_RGB_LINE;
    [self configNavigationBarWithNaviTitle:@"视频评价" naviFont:18.0f leftBtnTitle:@"back.png" rightBtnTitle:@"" bgColor:MAIN_RGB];
    
    if (self.isQVideoType == YES) {
        [VideoManager videoManagerQVideoBasicInfoWithQvid:[NSString stringWithFormat:@"%ld",(long)self.vDetailModel.vid] uid:[USER_DEFAULTS objectForKey:User_uid] completed:^(id obj) {
            if (obj != nil) {
                VideoEvaluateTableView *tableView = [[VideoEvaluateTableView alloc] initWithFrame:CGRectMake(0, self.navigationBar.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - self.navigationBar.height) style:UITableViewStylePlain];
                tableView.isQVideoType = self.isQVideoType;
                NSDictionary *dic = (NSDictionary *)obj;
                if (dic.count == 0) {  //无个人评价
                    _qvcid = @"";
                    tableView.contentStr = @"";
                } else {  //有个人评价
                    _qvcid = dic[@"qvcid"];
                    tableView.contentStr = dic[@"content"];
                }
                tableView.tableViewDelegate = self;
                [self.view addSubview:tableView];
            }
        }];
    } else {
        //获取个人评价2
        [VideoManager videoManagerVideoAppraiseBasicWithCourseid:[USER_DEFAULTS objectForKey:COURSEID] uid:[USER_DEFAULTS objectForKey:User_uid] vid:[NSString stringWithFormat:@"%ld",(long)self.vDetailModel.vid] completed:^(id obj) {
            if (obj != nil) {
                VideoEvaluateTableView *tableView = [[VideoEvaluateTableView alloc] initWithFrame:CGRectMake(0, self.navigationBar.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - self.navigationBar.height) style:UITableViewStylePlain];
                NSDictionary *dic = (NSDictionary *)obj;
                if (dic.count == 0) {  //无个人评价
                    _vaid = @"";
                    tableView.contentStr = @"";
                } else {  //有个人评价
                    _vaid = [NSString stringWithFormat:@"%@",dic[@"vaid"]];
                    tableView.contentStr = dic[@"content"];
                }
                tableView.tableViewDelegate = self;
                [self.view addSubview:tableView];
            }
        }];
    }
}
#pragma mark - 提交按钮代理方法
- (void)videoEvaluateSubmitWithContent:(NSString *)content gradeArray:(NSMutableArray *)gradeArray isQVideoType:(BOOL)isQVideoType
{
    if (content.length == 0) {
        [XZCustomWaitingView showAutoHidePromptView:@"请填写评价内容" background:nil showTime:1.0];
        return;
    }
    //试题视频
    if (isQVideoType == YES)
    {
        if (!_qvcid || _qvcid.length == 0) {  //增加评价
            [VideoManager videoManagerQVideoAddCommentWithQvid:[NSString stringWithFormat:@"%ld",(long)self.vDetailModel.vid] qid:self.qid uid:[USER_DEFAULTS objectForKey:User_uid] content:content completed:^(id obj) {
                if (obj != nil) {
                    [self showAlert];
                }
            }];
        } else {  //修改评价
            [VideoManager videoManagerQVideoUpCommentWithQvcid:_qvcid uid:[USER_DEFAULTS objectForKey:User_uid] content:content completed:^(id obj) {
                if (obj != nil) {
                    [self showAlert];
                }
            }];
        }
    }
    //章节视频
    else
    {
        NSMutableDictionary *gradeDic = [NSMutableDictionary dictionary];
        for (int i = 0; i < gradeArray.count; i ++) {
            [gradeDic setObject:gradeArray[i] forKey:[NSString stringWithFormat:@"%d",i + 1]];
        }
        if (!_vaid || _vaid.length == 0) {  //增加评价
            [VideoManager videoManagerVideoAppraiseAddAppraiseWithCourseid:[USER_DEFAULTS objectForKey:COURSEID] uid:[USER_DEFAULTS objectForKey:User_uid] vtid:[NSString stringWithFormat:@"%ld",(long)self.vDetailModel.vtid] vid:[NSString stringWithFormat:@"%ld",(long)self.vDetailModel.vid] content:content gradeJson:[ManagerTools dictionaryToJsonWithDic:(NSDictionary *)gradeDic] completed:^(id obj) {
                if (obj != nil) {
                    [self showAlert];
                }
            }];
        } else {  //修改评价
            [VideoManager videoManagerVideoAppraiseUpAppraiseWithUid:[USER_DEFAULTS objectForKey:User_uid] vid:[NSString stringWithFormat:@"%ld",(long)self.vDetailModel.vid] vaid:_vaid content:content completed:^(id obj) {
                if (obj != nil) {
                    [self showAlert];
                }
            }];
        }
    }
}
- (void)showAlert
{
    [XZCustomViewManager showSystemAlertViewWithTitle:@"温馨提示" message:@"评价成功！ 感谢您的评价" cancelButtonTitle:@"" otherButtonTitle:@"返回" isTouchbackground:NO withAlertViewType:XZAlertViewTypeSystemAlert handler:^(XZCustomAlertView *alertView, XZAlertViewBtnTag buttonIndex, XZAlertViewType alertViewType) {
        if ([self.delegate respondsToSelector:@selector(evaluateSuccessAndReload)]) {
            [self.navigationController popViewControllerAnimated:YES];
            [self.delegate evaluateSuccessAndReload];
        }
    }];
}

#pragma mark - 导航按钮
- (void)baseNaviButtonClickedWithBtnType:(naviBtnType)btnType
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
