//
//  LiveCourseListViewController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/12/5.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "LiveCourseListViewController.h"
#import "Tools.h"
#import "LiveModel.h"
#import "LiveManager.h"
#import "LiveCourseTableView.h"
#import "TalkfunViewController.h"
#import "TalkfunPlaybackViewController.h"
#import "LiveLocalPlayViewController.h"
#import "LiveDownloadViewController.h"
#import "AliLiveViewController.h"

@interface LiveCourseListViewController ()
{
    NSInteger _ltid;
}
@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, strong) LiveCourseTableView *courseTableView;
@end

@implementation LiveCourseListViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self configNavigationBarWithNaviTitle:self.naviTitle naviFont:18.0f leftBtnTitle:@"back.png" rightBtnTitle:@"videoxiazai.png" bgColor:MAIN_RGB];
    self.listArray = [NSMutableArray arrayWithCapacity:10];
    
    //获取班级信息
    [LiveManager liveManagerClassAllInfoWithLtid:[NSString stringWithFormat:@"%ld",(long)self.ltid] Completed:^(id obj) {
        if (obj != nil) {
            NSDictionary *dic = (NSDictionary *)obj;
            LiveClassListModel *model = [LiveClassListModel yy_modelWithJSON:dic];
            for (LiveClassListModel *listModel in model.typeList) {
                [self.listArray addObject:listModel];
            }
            if (self.listArray.count == 0) {
                [XZCustomWaitingView showAutoHidePromptView:@"暂无直播课程" background:nil showTime:0.8];
                return;
            }
            
            BOOL isHasDefalut = NO;
            for (LiveClassListModel *model in self.listArray) {
                if (model.isDefault == 1) {
                    isHasDefalut = YES;
                    //获取直播列表
                    [self getBasicListWithModel:model];
                    //注册通知
                    [self registerNotification];
                    break;
                }
            }
            if (isHasDefalut == NO) {
                LiveClassListModel *firstModel = self.listArray[0];
                firstModel.isDefault = YES;
                //获取直播列表
                [self getBasicListWithModel:firstModel];
                //注册通知
                [self registerNotification];
            }
        }
    }];
}
#pragma mark - 获取直播列表
- (void)getBasicListWithModel:(LiveClassListModel *)model {
    [LiveManager liveManagerBasicListWithLtid:[NSString stringWithFormat:@"%ld",(long)model.ltid] Completed:^(id obj) {
        if (obj != nil) {
            NSArray *array = (NSArray *)obj;
            _ltid = model.ltid;
            NSMutableArray *basicArray = [NSMutableArray arrayWithCapacity:10];
            for (NSDictionary *dic in array) {
                LiveBasicListModel *basicModel = [LiveBasicListModel yy_modelWithJSON:dic];
                [basicArray addObject:basicModel];
            }
            model.basicList = [basicArray mutableCopy];
            model.isDefault = YES;
            if (self.courseTableView) {
                self.courseTableView.dataArray = self.listArray;
                [self.courseTableView reloadData];
            }
        }
    }];
}
#pragma mark - 注册通知
- (void)registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LiveCourseClicked:) name:@"LiveCourseClicked" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CourseHeaderViewClicked:) name:@"CourseHeaderViewClicked" object:nil];
}
#pragma mark ========= 通知方法 =========
- (void)CourseHeaderViewClicked:(NSNotification *)noti {
    LiveClassListModel *listModel = [self.listArray objectAtIndex:[noti.object integerValue]];
    if (listModel.isDefault == YES) {
        for (LiveClassListModel *model in self.listArray) {
            model.isDefault = NO;
        }
        self.courseTableView.dataArray = self.listArray;
        [self.courseTableView reloadData];
    } else {
        [self getBasicListWithModel:listModel];
    }
}
- (void)LiveCourseClicked:(NSNotification *)noti {
    LiveBasicListModel *basicModel = (LiveBasicListModel *)noti.object;
    if ([ManagerTools timestampJudgeWithStarttime:basicModel.lvStart endTime:basicModel.lvEnd] == 0) {  //直播未开始
        [XZCustomWaitingView showAutoHidePromptView:@"直播暂未开始" background:nil showTime:1.0];
        return;
    } else if ([ManagerTools timestampJudgeWithStarttime:basicModel.lvStart endTime:basicModel.lvEnd] == 1 || [ManagerTools timestampJudgeWithStarttime:basicModel.lvStart endTime:basicModel.lvEnd] == -1) {  //正在直播（用户可以提前5分钟进入）
        if (basicModel.lvPlayType == 1) {
            AliLiveViewController *aliLiveVC = [[AliLiveViewController alloc] init];
            aliLiveVC.isLive = YES;
            aliLiveVC.basicModel = basicModel;
            aliLiveVC.ltid = _ltid;
            [self.navigationController pushViewController:aliLiveVC animated:YES];
        } else {
            [LiveManager LiveManagerLivePlayUrlWithLid:[NSString stringWithFormat:@"%ld",(long)basicModel.lid] uid:[USER_DEFAULTS objectForKey:User_uid] wxappid:@"" Completed:^(id obj) {
                if (obj != nil) {
                    NSDictionary *dic = (NSDictionary *)obj;
                    [self goToHuanTuoLiveWithAccessToken:dic[@"access_token"]];
                }
            }];
        }
    } else if ([ManagerTools timestampJudgeWithStarttime:basicModel.lvStart endTime:basicModel.lvEnd] == 2) {  //直播结束，使用录播接口
        if (basicModel.lvPlayType == 1) {
            AliLiveViewController *aliLiveVC = [[AliLiveViewController alloc] init];
            aliLiveVC.isLive = NO;
            aliLiveVC.basicModel = basicModel;
            aliLiveVC.ltid = _ltid;
            [self.navigationController pushViewController:aliLiveVC animated:YES];
        } else {
            [LiveManager LiveManagerVideoUrlWithLid:[NSString stringWithFormat:@"%ld",(long)basicModel.lid] uid:[USER_DEFAULTS objectForKey:User_uid] wxappid:@"" Completed:^(id obj) {
                if (obj != nil) {
                    NSDictionary *dic = (NSDictionary *)obj;
                    if ([dic[@"sourceList"] count] == 0) {
                        [self goToHuanTuoPlaybackWithAccessToken:dic[@"access_token"]];
                    } else {
//                        AliLiveViewController *aliLiveVC = [[AliLiveViewController alloc] init];
//                        aliLiveVC.isLive = NO;
//                        aliLiveVC.basicModel = basicModel;
//                        aliLiveVC.ltid = _ltid;
//                        [self.navigationController pushViewController:aliLiveVC animated:YES];
                        LiveLocalPlayViewController *localPlayVC = [[LiveLocalPlayViewController alloc] init];
                        localPlayVC.naviTitle = basicModel.lvTitle;
                        localPlayVC.sourceList = dic[@"sourceList"];
                        localPlayVC.basicModel = basicModel;
                        localPlayVC.ltid = _ltid;
                        [self.navigationController pushViewController:localPlayVC animated:YES];
                    }
                }
            }];
        }
    }
}
#pragma mark - 跳转到欢拓直播
- (void)goToHuanTuoLiveWithAccessToken:(NSString *)accessToken {
    TalkfunViewController *TalkfunVC = [[TalkfunViewController alloc] init];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [data setObject:accessToken forKey:@"access_token"];
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [result setObject:data forKey:@"data"];
    [result setObject:@(0) forKey:@"code"];
    TalkfunVC.res = result;
    [self presentViewController:TalkfunVC animated:NO completion:nil];
}
#pragma mark - 跳转到欢拓录播
- (void)goToHuanTuoPlaybackWithAccessToken:(NSString *)accessToken {
    TalkfunPlaybackViewController *TalkfunPlaybackVC = [[TalkfunPlaybackViewController alloc] init];
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [data setObject:accessToken forKey:@"access_token"];
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [result setObject:data forKey:@"data"];
    [result setObject:@(0) forKey:@"code"];
    TalkfunPlaybackVC.res = result;
    [self presentViewController:TalkfunPlaybackVC animated:NO completion:nil];
}

#pragma mark - 导航按钮点击
- (void)baseNaviButtonClickedWithBtnType:(naviBtnType)btnType
{
    if (btnType == LeftBtnType) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        LiveDownloadViewController *liveDownloadVC = [[LiveDownloadViewController alloc] init];
        [self.navigationController pushViewController:liveDownloadVC animated:YES];
    }
}
- (LiveCourseTableView *)courseTableView {
    if (!_courseTableView) {
        _courseTableView = [[LiveCourseTableView alloc] initWithFrame:CGRectMake(0, self.navigationBar.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - self.navigationBar.height) style:UITableViewStylePlain];
        [self.view addSubview:_courseTableView];
    }
    return _courseTableView;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
