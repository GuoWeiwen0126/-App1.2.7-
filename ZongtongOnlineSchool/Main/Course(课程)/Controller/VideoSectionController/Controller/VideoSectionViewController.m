//
//  VideoSectionViewController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/26.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "VideoSectionViewController.h"
#import "Tools.h"
#import "VideoTypeModel.h"
#import "VideoManager.h"
#import "VideoSectionModel.h"
#import "VideoSectionTableView.h"
#import "ALiVideoPlayViewController.h"
#import "VideoDetailModel.h"
#import "VideoDownloadViewController.h"
#import "HandoutViewController.h"
#import "ZFDownloadManager.h"

@interface VideoSectionViewController () <OptionButtonViewDelegate>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) VideoSectionTableView *vSecTableView;
@end

@implementation VideoSectionViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.dataArray.count > 0) {
        [self getVideoRecord];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}
#pragma mark - 创建UI
- (void)createUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self configNavigationBarWithNaviTitle:self.naviTitle naviFont:16.0f leftBtnTitle:@"back.png" rightBtnTitle:@"videoxiazai.png" bgColor:MAIN_RGB];
    //完整类别信息
    [VideoManager VideoManagerInfoAboutVTypeWithCourseid:self.courseId vtfid:[NSString stringWithFormat:@"%ld",(long)self.vtfid] completed:^(id obj) {
        if (obj != nil) {
            NSDictionary *dataDic = (NSDictionary *)obj;
            if ([dataDic[@"isUsing"] integerValue] != 0) {
                [XZCustomWaitingView showAutoHidePromptView:dataDic[@"errMsg"] background:nil showTime:1.0];
                return;
            }
            self.dataArray = [NSMutableArray arrayWithCapacity:10];
            for (NSDictionary *dic in dataDic[@"infoList"]) {
                VideoSectionModel *videoSectionModel = [VideoSectionModel modelWithDic:dic];
                [self.dataArray addObject:videoSectionModel];
            }
            OptionButtonView *optionBtnView = [[OptionButtonView alloc] initWithFrame:CGRectMake(0, self.navigationBar.bottom, UI_SCREEN_WIDTH, 50) optionArray:@[@"课程", @"讲义"] selectedColor:MAIN_RGB lineSpace:10 haveLineView:YES selectIndex:0];
            optionBtnView.optionViewDelegate = self;
            [self.view addSubview:optionBtnView];
            
            self.vSecTableView = [[VideoSectionTableView alloc] initWithFrame:CGRectMake(0, optionBtnView.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - self.navigationBar.height - optionBtnView.height) style:UITableViewStylePlain];
            self.vSecTableView.vSecStatus = 0;
            self.vSecTableView.dataArray = self.dataArray;
            [self.view addSubview:self.vSecTableView];
            [self getVideoRecord];
            //注册通知
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(VideoTableViewCellPlayVideo:) name:@"VideoTableViewCellPlayVideo" object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(VideoTableViewCellOpenHandout:) name:@"VideoTableViewCellOpenHandout" object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(VideoTableViewCellDownloadVideo:) name:@"VideoTableViewCellDownloadVideo" object:nil];
        }
    }];
//    //获取完整的信息（包含子节点）
//    [VideoManager videoManagerBasicinfoWithCourseid:self.courseId vtid:[NSString stringWithFormat:@"%ld",(long)self.vtid] completed:^(id obj) {
//
//    }];
}
#pragma mark - 获取观看记录
- (void)getVideoRecord
{
    //所有观看记录
    [VideoManager videoManagerBasicListWithCourseid:self.courseId uid:[USER_DEFAULTS objectForKey:User_uid] completed:^(id obj) {
        if (obj != nil) {
            NSArray *timeArray = (NSArray *)obj;
            //遍历修改观看记录
            for (VideoSectionModel *vSecModel1 in self.dataArray) {
                if (vSecModel1.vid != 0) {  //没有子集
                    for (NSDictionary *dic in timeArray) {
                        if (vSecModel1.vid == [dic[@"vid"] integerValue]) {
                            vSecModel1.srid = [dic[@"srid"] integerValue];
                            vSecModel1.srTime = [dic[@"srTime"] integerValue];
                        }
                    }
                } else {
                    NSInteger totalSrTime1 = 0;
                    for (VideoSectionModel *vSecModel2 in vSecModel1.infoList) {
                        if (vSecModel2.vid != 0) {
                            for (NSDictionary *dic in timeArray) {
                                if (vSecModel2.vid == [dic[@"vid"] integerValue]) {
                                    vSecModel2.srid = [dic[@"srid"] integerValue];
                                    vSecModel2.srTime = [dic[@"srTime"] integerValue];
                                    totalSrTime1 = totalSrTime1 + vSecModel2.srTime;
                                }
                            }
                        } else {
                            NSInteger totalSrTime2 = 0;
                            for (VideoSectionModel *vSecModel3 in vSecModel2.infoList) {
                                if (vSecModel3.vid != 0) {
                                    for (NSDictionary *dic in timeArray) {
                                        if (vSecModel3.vid == [dic[@"vid"] integerValue]) {
                                            vSecModel3.srid = [dic[@"srid"] integerValue];
                                            vSecModel3.srTime = [dic[@"srTime"] integerValue];
                                            totalSrTime1 = totalSrTime1 + vSecModel3.srTime;
                                            totalSrTime2 = totalSrTime2 + vSecModel3.srTime;
                                        }
                                    }
                                } else {
                                    NSInteger totalSrTime3 = 0;
                                    for (VideoSectionModel *vSecModel4 in vSecModel3.infoList) {
                                        if (vSecModel4.vid != 0) {
                                            for (NSDictionary *dic in timeArray) {
                                                if (vSecModel4.vid == [dic[@"vid"] integerValue]) {
                                                    vSecModel4.srid = [dic[@"srid"] integerValue];
                                                    vSecModel4.srTime = [dic[@"srTime"] integerValue];
                                                    totalSrTime1 = totalSrTime1 + vSecModel4.srTime;
                                                    totalSrTime2 = totalSrTime2 + vSecModel4.srTime;
                                                    totalSrTime3 = totalSrTime3 + vSecModel4.srTime;
                                                }
                                            }
                                        } else {
                                            NSInteger totalSrTime4 = 0;
                                            for (VideoSectionModel *vSecModel5 in vSecModel4.infoList) {
                                                if (vSecModel5.vid != 0) {
                                                    for (NSDictionary *dic in timeArray) {
                                                        if (vSecModel5.vid == [dic[@"vid"] integerValue]) {
                                                            vSecModel5.srid = [dic[@"srid"] integerValue];
                                                            vSecModel5.srTime = [dic[@"srTime"] integerValue];
                                                            totalSrTime1 = totalSrTime1 + vSecModel5.srTime;
                                                            totalSrTime2 = totalSrTime2 + vSecModel5.srTime;
                                                            totalSrTime3 = totalSrTime3 + vSecModel5.srTime;
                                                            totalSrTime4 = totalSrTime4 + vSecModel5.srTime;
                                                        }
                                                    }
                                                } else {
                                                    
                                                }
                                            }
                                            vSecModel4.srTime = totalSrTime4;
                                        }
                                    }
                                    vSecModel3.srTime = totalSrTime3;
                                }
                            }
                            vSecModel2.srTime = totalSrTime2;
                        }
                    }
                    vSecModel1.srTime = totalSrTime1;
                }
            }
            self.vSecTableView.dataArray = self.dataArray;
            [self.vSecTableView reloadData];
        }
    }];
}
#pragma mark - 点击播放按钮
- (void)VideoTableViewCellPlayVideo:(NSNotification *)noti
{
    VideoSectionModel *vSectionModel = (VideoSectionModel *)noti.object;
    NSLog(@"%@---%ld",vSectionModel.title,(long)vSectionModel.vid);
    if (vSectionModel.isUsing != 0) {
        [XZCustomWaitingView showAutoHidePromptView:vSectionModel.vtErrMsg background:nil showTime:1.0];
        return;
    }
    if (vSectionModel.vid == 0) {
        [XZCustomWaitingView showAutoHidePromptView:@"视频还在录制中，敬请期待" background:nil showTime:1.0];
        return;
    }
    if (vSectionModel.isBuy == YES) {
        //需要购买
        if (IsLocalAccount) {
            [XZCustomViewManager showSystemAlertViewWithTitle:@"温馨提示" message:@"当前为试用账号，试用账号购买后，仅在当前设备有效，一旦卸载或更换设备，权限将自动关闭，是否购买？" cancelButtonTitle:@"取消" otherButtonTitle:@"确认购买" isTouchbackground:NO withAlertViewType:XZAlertViewTypeSystemAlert handler:^(XZCustomAlertView *alertView, XZAlertViewBtnTag buttonIndex, XZAlertViewType alertViewType) {
                if (buttonIndex == XZAlertViewBtnTagSure) {
                    [XZCustomViewManager showSystemAlertViewWithTitle:@"温馨提示" message:@"您暂无权限查看该章节，请您购买后查看。" cancelButtonTitle:@"取消" otherButtonTitle:@"点击购买" isTouchbackground:NO withAlertViewType:XZAlertViewTypeSystemAlert handler:^(XZCustomAlertView *alertView, XZAlertViewBtnTag buttonIndex, XZAlertViewType alertViewType) {
                        if (buttonIndex == XZAlertViewBtnTagSure) {
                            [OrderManager orderManagerAdvanceWithVC:self examid:[USER_DEFAULTS objectForKey:EIID] courseid:self.courseId uid:[USER_DEFAULTS objectForKey:User_uid] pid:[NSString stringWithFormat:@"%ld",(long)vSectionModel.pid] num:@"1" key:@"" ciid:@"" cdkey:@"" remark:@"" payType:[USER_DEFAULTS objectForKey:Payment] appType:[NSString stringWithFormat:@"%ld",(long)vSectionModel.appType]];
                        }
                        return;
                    }];
                }
            }];
        } else {
            [XZCustomViewManager showSystemAlertViewWithTitle:@"温馨提示" message:@"您暂无权限查看该章节，请您购买后查看。" cancelButtonTitle:@"取消" otherButtonTitle:@"点击购买" isTouchbackground:NO withAlertViewType:XZAlertViewTypeSystemAlert handler:^(XZCustomAlertView *alertView, XZAlertViewBtnTag buttonIndex, XZAlertViewType alertViewType) {
                if (buttonIndex == XZAlertViewBtnTagSure) {
                    [OrderManager orderManagerAdvanceWithVC:self examid:[USER_DEFAULTS objectForKey:EIID] courseid:self.courseId uid:[USER_DEFAULTS objectForKey:User_uid] pid:[NSString stringWithFormat:@"%ld",(long)vSectionModel.pid] num:@"1" key:@"" ciid:@"" cdkey:@"" remark:@"" payType:[USER_DEFAULTS objectForKey:Payment] appType:[NSString stringWithFormat:@"%ld",(long)vSectionModel.appType]];
                }
                return;
            }];
        }
        return;
    }
    //获取视频详情
    [VideoManager videoManagerBasicWithCourseid:self.courseId uid:[USER_DEFAULTS objectForKey:User_uid] vid:[NSString stringWithFormat:@"%ld",(long)vSectionModel.vid] completed:^(id obj) {
        if (obj != nil) {
            ALiVideoPlayViewController *videoPlayVC = [[ALiVideoPlayViewController alloc] init];
            videoPlayVC.vcType = SectionVideoType;
            videoPlayVC.vSecModel = vSectionModel;
            videoPlayVC.vDetailModel = [VideoDetailModel yy_modelWithDictionary:(NSDictionary *)obj];
            videoPlayVC.vDetailModel.srTime = vSectionModel.srTime;
            videoPlayVC.vDetailModel.srid = vSectionModel.srid;
            videoPlayVC.videoSectionDataArray = [NSMutableArray arrayWithArray:(NSArray *)self.dataArray];
            if ([videoPlayVC.vDetailModel.vUrl hasSuffix:@"html"]) {
                videoPlayVC.isHtmlVideo = YES;
            }
//            videoPlayVC.vtfid = vSectionModel.vtfid;
            //切换线路
            if ([USER_DEFAULTS integerForKey:VideoSource] != 0) {
                videoPlayVC.vDetailModel.vUrl = [videoPlayVC.vDetailModel.vUrl stringByReplacingOccurrencesOfString:VideoSource_moren withString:VideoSourceArray[[USER_DEFAULTS integerForKey:VideoSource]]];
            }
            [self.navigationController pushViewController:videoPlayVC animated:YES];
        }
    }];
}
#pragma mark - 打开讲义
- (void)VideoTableViewCellOpenHandout:(NSNotification *)noti
{
    VideoSectionModel *vSectionModel = (VideoSectionModel *)noti.object;
    if (vSectionModel.isUsing != 0) {
        [XZCustomWaitingView showAutoHidePromptView:vSectionModel.vtErrMsg background:nil showTime:1.0];
        return;
    }
    if (vSectionModel.vid == 0) {
        [XZCustomWaitingView showAutoHidePromptView:@"视频还在录制中，敬请期待" background:nil showTime:1.0];
        return;
    }
    //获取视频详情
    [VideoManager videoManagerBasicWithCourseid:self.courseId uid:[USER_DEFAULTS objectForKey:User_uid] vid:[NSString stringWithFormat:@"%ld",(long)vSectionModel.vid] completed:^(id obj) {
        if (obj != nil) {
            HandoutViewController *handoutVC = [[HandoutViewController alloc] init];
            handoutVC.naviTitle = vSectionModel.title;
            handoutVC.vid = vSectionModel.vid;
            [self.navigationController pushViewController:handoutVC animated:YES];
        }
    }];
}
#pragma mark - 视频下载
- (void)VideoTableViewCellDownloadVideo:(NSNotification *)noti
{
    VideoSectionModel *vSectionModel = (VideoSectionModel *)noti.object;
    if (vSectionModel.isUsing != 0) {
        [XZCustomWaitingView showAutoHidePromptView:vSectionModel.vtErrMsg background:nil showTime:1.0];
        return;
    }
    if (vSectionModel.vid == 0) {
        [XZCustomWaitingView showAutoHidePromptView:@"视频还在录制中，敬请期待" background:nil showTime:1.0];
        return;
    }
    //获取视频详情
    [VideoManager videoManagerBasicWithCourseid:self.courseId uid:[USER_DEFAULTS objectForKey:User_uid] vid:[NSString stringWithFormat:@"%ld",(long)vSectionModel.vid] completed:^(id obj) {
        if (obj != nil) {
            VideoDetailModel *vDetailModel = [VideoDetailModel yy_modelWithDictionary:(NSDictionary *)obj];
            [[ZFDownloadManager sharedDownloadManager] downFileUrl:[ManagerTools videoUrlChangeBlankWtihUrl:vDetailModel.vUrl]
                                                          fileEiid:[USER_DEFAULTS objectForKey:EIID]
                                                          fileVtid:[NSString stringWithFormat:@"%ld",(long)vSectionModel.vtfid]
                                                          filename:[NSString stringWithFormat:@"%@-%ld.mp4",[USER_DEFAULTS objectForKey:EIID],(long)vDetailModel.vid]
                                                      vDetailModel:vDetailModel
                                                            vTitle:vSectionModel.title
                                                          fileLtid:@""
                                                     liveListModel:nil];
            [ZFDownloadManager sharedDownloadManager].maxCount = 3;
        }
    }];
}

#pragma mark - OptionButtonViewDelegate
- (void)optionViewButtonClickedWithBtnTag:(NSInteger)btnTag
{
    self.vSecTableView.vSecStatus = btnTag;
    [self.vSecTableView reloadData];
}

#pragma mark -
#pragma mark - 导航按钮
- (void)baseNaviButtonClickedWithBtnType:(naviBtnType)btnType
{
    if (btnType == LeftBtnType) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        VideoDownloadViewController *videoDownloadVC = [[VideoDownloadViewController alloc] init];
        [self.navigationController pushViewController:videoDownloadVC animated:YES];
    }
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
