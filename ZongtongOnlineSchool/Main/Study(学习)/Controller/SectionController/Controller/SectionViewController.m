//
//  SectionViewController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/4.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "SectionViewController.h"
#import "Tools.h"
#import "HomeManager.h"
#import "HomeModel.h"
#import "SectionManager.h"
#import "UserStatisticManager.h"
#import "QModeButton.h"
#import "ZNLXTableView.h"
#import "ZNLXCellModel.h"
#import "QuestionViewController.h"
#import "ShareInfoManager.h"
#import "WebViewController.h"

@interface SectionViewController () <OptionButtonViewDelegate, AdverViewDelegate>
{
    NSString *_sidJson;
}
@property (nonatomic, strong) AdverView *adView;
@property (nonatomic, strong) NSMutableArray *adArray;
@property (nonatomic, strong) ZNLXTableView *znlxTableView;
@property (nonatomic, strong) OptionButtonView *optionBtnView;  //做题模式切换
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation SectionViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_sidJson.length > 0) {
        [self getSectionList];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self createUI];
}
#pragma mark -
#pragma mark - 创建UI
- (void)createUI
{
    [self configNavigationBarWithNaviTitle:self.naviTitle naviFont:18.0f leftBtnTitle:@"back.png" rightBtnTitle:[self judgeIsModule] ? @"":@"" bgColor:MAIN_RGB];
    
    //广告列表
    [HomeManager homeManagerAdInfoServeBasicListWithPlace:[ManagerTools getAdverViewPlaceWithType:self.type] system:@"1" completed:^(id obj) {
        self.adArray = [NSMutableArray arrayWithCapacity:10];
        NSArray *temArray = (NSArray *)obj;
        self.adView = [[AdverView alloc] initWithFrame:CGRectMake(0, self.navigationBar.bottom, UI_SCREEN_WIDTH, UI_SCREEN_WIDTH*3.0/8)];
        self.adView.delegate = self;
        [self.view addSubview:self.adView];
        if (temArray.count == 0) {
            self.adView.frame = CGRectMake(0, self.navigationBar.bottom, UI_SCREEN_WIDTH, 0);
        }
        for (NSDictionary *adDic in temArray) {
            AdInfoModel *adInfoModel = [AdInfoModel yy_modelWithDictionary:adDic];
            [self.adArray addObject:adInfoModel];
        }
        if (self.adArray.count == 0) {
            AdInfoModel *temAdInfoModel = [[AdInfoModel alloc] init];
            temAdInfoModel.imgUrl = [self getImgNameWithType:self.type];
            [self.adArray addObject:temAdInfoModel];
        }
        [self.adView refreshWithAdArray:self.adArray];
        
        self.optionBtnView = [[OptionButtonView alloc] initWithFrame:CGRectMake(0, [self judgeIsModule] ? self.adView.bottom:self.navigationBar.bottom, UI_SCREEN_WIDTH, 50) optionArray:@[@"练习模式", @"模考模式", @"浏览模式"] selectedColor:MAIN_RGB lineSpace:15 haveLineView:YES selectIndex:[USER_DEFAULTS integerForKey:Question_Mode]];
        self.optionBtnView.optionViewDelegate = self;
        if (self.type == 7) {
            self.optionBtnView.hidden = YES;
        }
        [self.view addSubview:self.optionBtnView];
        
        self.optionBtnView = [[OptionButtonView alloc] initWithFrame:CGRectMake(0, [self judgeIsModule] ? self.adView.bottom:self.navigationBar.bottom, UI_SCREEN_WIDTH, 50) optionArray:@[@"练习模式", @"模考模式", @"浏览模式"] selectedColor:MAIN_RGB lineSpace:15 haveLineView:YES selectIndex:[USER_DEFAULTS integerForKey:Question_Mode]];
        self.optionBtnView.optionViewDelegate = self;
        if (self.type == 7) {  //模考大赛
            self.optionBtnView.hidden = YES;
        }
        [self.view addSubview:self.optionBtnView];
        
        //章节下全部信息
        [SectionManager sectionManagerSectionInfoWithCourseid:[USER_DEFAULTS objectForKey:COURSEID] sid:self.sid completed:^(id obj) {
            if (obj == nil) {
                return;
            } else {
                //题分类
                [SectionManager sectionManagerQtypeBasicListWithCompleted:^(id obj_Qtype) {
                    if (obj != nil) {
                        NSDictionary *dataDic = (NSDictionary *)obj;
                        
                        if ([dataDic[@"isUsing"] integerValue] == 1) {
                            [XZCustomViewManager showSystemAlertViewWithTitle:@"温馨提示" message:dataDic[@"errMsg"] cancelButtonTitle:@"" otherButtonTitle:@"确定" isTouchbackground:NO withAlertViewType:XZAlertViewTypeSystemAlert handler:^(XZCustomAlertView *alertView, XZAlertViewBtnTag buttonIndex, XZAlertViewType alertViewType) {
                                
                            }];
                            return;
                        }
                        
                        self.dataArray = [NSMutableArray arrayWithCapacity:10];
                        for (NSDictionary *dic in dataDic[@"basicList"]) {
                            ZNLXCellModel *model = [ZNLXCellModel modelWithDic:dic];
                            [self.dataArray addObject:model];
                        }
                        self.znlxTableView = [[ZNLXTableView alloc] initWithFrame:CGRectMake(0, self.type == 7 ? self.navigationBar.bottom:self.optionBtnView.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - self.navigationBar.height - (self.type == 7 ? 0:self.optionBtnView.height) - ([self judgeIsModule] ? self.adView.height:0)) style:UITableViewStylePlain];
                        self.znlxTableView.dataArray = self.dataArray;
                        [self.view addSubview:self.znlxTableView];
                        //注册通知
                        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ZNLXTableViewCellWriteBtnClicked:) name:@"ZNLXTableViewCellWriteBtnClicked" object:nil];
                        //                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DataShareToQQAndWeChat) name:@"DataShareToQQAndWeChat" object:nil];
                        //本地存储 题分类 信息
                        [SectionManager saveQtypeListInfoWithArray:(NSArray *)obj_Qtype];
                        //拼接sid
                        _sidJson = @"";
                        for (ZNLXCellModel *temModel1 in self.dataArray) {
                            if (temModel1.isQues == 0) {  //没有子集
                                _sidJson = [_sidJson stringByAppendingFormat:@"%ld,",(long)temModel1.sid];
                            } else {
                                for (ZNLXCellModel *temModel2 in temModel1.basicList) {
                                    if (temModel2.isQues == 0) {  //没有子集
                                        _sidJson = [_sidJson stringByAppendingFormat:@"%ld,",(long)temModel2.sid];
                                    } else {
                                        for (ZNLXCellModel *temModel3 in temModel2.basicList) {
                                            if (temModel3.isQues == 0) {  //没有子集
                                                _sidJson = [_sidJson stringByAppendingFormat:@"%ld,",(long)temModel3.sid];
                                            } else {}  //暂定三层
                                        }
                                    }
                                }
                            }
                        }
                        if (_sidJson.length > 0) {
                            _sidJson = [_sidJson substringToIndex:_sidJson.length - 1];
                            //章节列表统计
                            [self getSectionList];
                        }
                    }
                }];
            }
        }];
    }];
}
#pragma mark - 章节列表统计
- (void)getSectionList
{
    //章节列表统计
    [UserStatisticManager userSectionMiniListWithUid:[USER_DEFAULTS objectForKey:User_uid] sidJson:_sidJson completed:^(id obj) {
        if (obj != nil) {
            NSArray *secListArray = (NSArray *)obj;
            for (ZNLXCellModel *temModel1 in self.dataArray) {
                if (temModel1.isQues == 0) {  //没有子集
                    for (NSDictionary *dic in secListArray) {
                        if (temModel1.sid == [dic[@"sid"] integerValue]) {
                            temModel1.exQNum = [dic[@"exQNum"] integerValue];
                        }
                    }
                } else {
                    NSInteger totalExQNum1 = 0;
                    for (ZNLXCellModel *temModel2 in temModel1.basicList) {
                        if (temModel2.isQues == 0) {
                            for (NSDictionary *dic in secListArray) {
                                if (temModel2.sid == [dic[@"sid"] integerValue]) {
                                    temModel2.exQNum = [dic[@"exQNum"] integerValue];
                                    totalExQNum1 = totalExQNum1 + temModel2.exQNum;
                                }
                            }
                        } else {
                            NSInteger totalExQNum2 = 0;
                            for (ZNLXCellModel *temModel3 in temModel2.basicList) {
                                if (temModel3.isQues == 0) {
                                    for (NSDictionary *dic in secListArray) {
                                        if (temModel3.sid == [dic[@"sid"] integerValue]) {
                                            temModel3.exQNum = [dic[@"exQNum"] integerValue];
                                            totalExQNum1 = totalExQNum1 + temModel3.exQNum;
                                            totalExQNum2 = totalExQNum2 + temModel3.exQNum;
                                        }
                                    }
                                } else {
                                    NSInteger totalExQNum3 = 0;
                                    for (ZNLXCellModel *temModel4 in temModel3.basicList) {
                                        if (temModel4.isQues == 0) {
                                            for (NSDictionary *dic in secListArray) {
                                                if (temModel4.sid == [dic[@"sid"] integerValue]) {
                                                    temModel4.exQNum = [dic[@"exQNum"] integerValue];
                                                    totalExQNum1 = totalExQNum1 + temModel4.exQNum;
                                                    totalExQNum2 = totalExQNum2 + temModel4.exQNum;
                                                    totalExQNum3 = totalExQNum3 + temModel4.exQNum;
                                                }
                                            }
                                        } else {
                                            NSInteger totalExQNum4 = 0;
                                            for (ZNLXCellModel *temModel5 in temModel4.basicList) {
                                                if (temModel5.isQues == 0) {
                                                    for (NSDictionary *dic in secListArray) {
                                                        if (temModel5.sid == [dic[@"sid"] integerValue]) {
                                                            temModel5.exQNum = [dic[@"exQNum"] integerValue];
                                                            totalExQNum1 = totalExQNum1 + temModel5.exQNum;
                                                            totalExQNum2 = totalExQNum2 + temModel5.exQNum;
                                                            totalExQNum3 = totalExQNum3 + temModel5.exQNum;
                                                            totalExQNum4 = totalExQNum4 + temModel5.exQNum;
                                                        }
                                                    }
                                                } else {
                                                    
                                                }
                                            }
                                            temModel4.exQNum = totalExQNum4;
                                        }
                                    }
                                    temModel3.exQNum = totalExQNum3;
                                }
                            }
                            temModel2.exQNum = totalExQNum2;
                        }
                    }
                    temModel1.exQNum = totalExQNum1;
                }
            }
            self.znlxTableView.dataArray = self.dataArray;
            [self.znlxTableView reloadData];
        }
    }];
}

#pragma mark -
#pragma mark - 点击广告
- (void)adverViewClickedWithAdModel:(id)model
{
    AdInfoModel *adModel = (AdInfoModel *)model;
    if ([adModel.operateType isEqualToString:@"link"]) {
        WebViewController *webVC = [[WebViewController alloc] init];
        webVC.naviTitle = adModel.title;
        webVC.webVCUrl = adModel.operateValue;
        [self.navigationController pushViewController:webVC animated:YES];
    } else if ([adModel.operateType isEqualToString:@"keywords"]) {
        if ([adModel.operateValue containsString:@"contactus"]) {
            NSString *qqStr;
            if ([adModel.operateValue containsString:@"_"]) {
                qqStr = [adModel.operateValue substringFromIndex:10];
            } else {
                qqStr = [USER_DEFAULTS objectForKey:ServiceQQ];
            }
            //联系客服
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",[ManagerTools deleteSpaceAndNewLineWithString:qqStr]]]]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",[ManagerTools deleteSpaceAndNewLineWithString:qqStr]]]];
            } else {
                [XZCustomWaitingView showAutoHidePromptView:@"打开失败" background:nil showTime:1.2];
            }
        } else if ([adModel.operateValue isEqualToString:@"livevideolist"]) {
            self.tabBarController.selectedIndex = 2;
        }
    }
}

#pragma mark -
#pragma mark - 点击做题按钮
- (void)ZNLXTableViewCellWriteBtnClicked:(NSNotification *)noti
{
    ZNLXCellModel *cellModel = noti.object;
//    NSLog(@"pid:%ld******isBuy:%d",(long)cellModel.pid,cellModel.isBuy);
    if (cellModel.pid == 0 && cellModel.isBuy == YES && [self judgeIsModule]) {
        if ([ManagerTools sectionIsVerificationWithEiid:[USER_DEFAULTS objectForKey:EIID] courseid:[USER_DEFAULTS objectForKey:COURSEID] type:[NSString stringWithFormat:@"%ld",(long)self.type]] == NO) {
//            [self DataShareToQQAndWeChat];
            [XZCustomViewManager showSystemAlertViewWithTitle:@"温馨提示" message:@"暂时无法查看，请联系客服" cancelButtonTitle:@"取消" otherButtonTitle:@"联系客服" isTouchbackground:YES withAlertViewType:XZAlertViewTypeSystemAlert handler:^(XZCustomAlertView *alertView, XZAlertViewBtnTag buttonIndex, XZAlertViewType alertViewType) {
                if (buttonIndex == XZAlertViewBtnTagSure) {
                    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",[ManagerTools deleteSpaceAndNewLineWithString:[USER_DEFAULTS objectForKey:ServiceQQ]]]]]) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",[ManagerTools deleteSpaceAndNewLineWithString:[USER_DEFAULTS objectForKey:ServiceQQ]]]]];
                    } else {
                        [XZCustomWaitingView showAutoHidePromptView:@"打开失败" background:nil showTime:1.2];
                    }
                }
            }];
            return;
        }
    }
    if (cellModel.isBuy == YES) {
        //需要购买
        if (IsLocalAccount) {
            [XZCustomViewManager showSystemAlertViewWithTitle:@"温馨提示" message:@"当前为试用账号，试用账号购买后，仅在当前设备有效，一旦卸载或更换设备，权限将自动关闭，是否购买？" cancelButtonTitle:@"取消" otherButtonTitle:@"确认购买" isTouchbackground:NO withAlertViewType:XZAlertViewTypeSystemAlert handler:^(XZCustomAlertView *alertView, XZAlertViewBtnTag buttonIndex, XZAlertViewType alertViewType) {
                if (buttonIndex == XZAlertViewBtnTagSure) {
                    [XZCustomViewManager showSystemAlertViewWithTitle:@"温馨提示" message:@"您暂无权限查看该章节，请您购买后查看。" cancelButtonTitle:@"取消" otherButtonTitle:@"点击购买" isTouchbackground:NO withAlertViewType:XZAlertViewTypeSystemAlert handler:^(XZCustomAlertView *alertView, XZAlertViewBtnTag buttonIndex, XZAlertViewType alertViewType) {
                        if (buttonIndex == XZAlertViewBtnTagSure) {
                            [OrderManager orderManagerAdvanceWithVC:self examid:[USER_DEFAULTS objectForKey:EIID] courseid:[USER_DEFAULTS objectForKey:COURSEID] uid:[USER_DEFAULTS objectForKey:User_uid] pid:[NSString stringWithFormat:@"%ld",(long)cellModel.pid] num:@"1" key:@"" ciid:@"" cdkey:@"" remark:@"" payType:[USER_DEFAULTS objectForKey:Payment] appType:[NSString stringWithFormat:@"%ld",(long)cellModel.appType]];
                        }
                        return;
                    }];
                }
            }];
        } else {
            [XZCustomViewManager showSystemAlertViewWithTitle:@"温馨提示" message:@"您暂无权限查看该章节，请您购买后查看。" cancelButtonTitle:@"取消" otherButtonTitle:@"点击购买" isTouchbackground:NO withAlertViewType:XZAlertViewTypeSystemAlert handler:^(XZCustomAlertView *alertView, XZAlertViewBtnTag buttonIndex, XZAlertViewType alertViewType) {
                if (buttonIndex == XZAlertViewBtnTagSure) {
                    [OrderManager orderManagerAdvanceWithVC:self examid:[USER_DEFAULTS objectForKey:EIID] courseid:[USER_DEFAULTS objectForKey:COURSEID] uid:[USER_DEFAULTS objectForKey:User_uid] pid:[NSString stringWithFormat:@"%ld",(long)cellModel.pid] num:@"1" key:@"" ciid:@"" cdkey:@"" remark:@"" payType:[USER_DEFAULTS objectForKey:Payment] appType:[NSString stringWithFormat:@"%ld",(long)cellModel.appType]];
                }
                return;
            }];
        }
        return;
    }
    
    if (cellModel.isUsing == 1) {
        [XZCustomViewManager showSystemAlertViewWithTitle:@"温馨提示" message:cellModel.sErrMsg cancelButtonTitle:@"" otherButtonTitle:@"确定" isTouchbackground:NO withAlertViewType:XZAlertViewTypeSystemAlert handler:^(XZCustomAlertView *alertView, XZAlertViewBtnTag buttonIndex, XZAlertViewType alertViewType) {
            
        }];
        return;
    }
    
    [USER_DEFAULTS setBool:NO forKey:Question_IsAnalyse];
    [USER_DEFAULTS synchronize];
    if (self.type == 7) {
        [USER_DEFAULTS setInteger:1 forKey:Question_Mode];
        [USER_DEFAULTS synchronize];
    }
    QuestionViewController *questionVC = [[QuestionViewController alloc] init];
    questionVC.naviTitle = cellModel.title;
    questionVC.sid = cellModel.sid;
    NSLog(@"sid：%d",cellModel.sid);
    [self.navigationController pushViewController:questionVC animated:YES];
}

#pragma amrk - 分享
- (void)DataShareToQQAndWeChat
{
    [XZCustomViewManager showCustomActionSheetWithTitle:@"尚未解锁，请分享解锁" cancelButtonTitle:@"取消" otherButtonTitles:@[@"分享至微信朋友圈或者QQ空间", @"分享至微信群或者QQ群"] handle:^(XZCustomActionSheetView *actionSheetView, NSInteger index) {
        NSArray *shareArray = [NSArray array];
        if (index == 0) {
            return;
        } else if (index == 1) {  //朋友圈、空间
            shareArray = @[@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_Qzone)];
            //显示分享面板
            [UMSocialUIManager setPreDefinePlatforms:shareArray];
            [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
                // 根据获取的platformType确定所选平台进行下一步操作
                NSLog(@"分享平台：%ld",(long)platformType);
                [self shareWebPageToPlatformType:platformType];
            }];
        } else if (index == 2) {  //群聊
            shareArray = @[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_QQ)];
            //显示分享面板
            [UMSocialUIManager setPreDefinePlatforms:shareArray];
            [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
                // 根据获取的platformType确定所选平台进行下一步操作
                NSLog(@"分享平台：%ld",(long)platformType);
                [self shareWebPageToPlatformType:platformType];
            }];
        }
    }];
}
#pragma mark - 分享功能
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    [ShareInfoManager shareInfoManagerShareNumberWithUid:[USER_DEFAULTS objectForKey:User_uid] shareType:@"1" courseid:@"0" completed:^(id obj) {
        if (obj != nil) {
            UMSocialMessageObject *shareMessage = [UMSocialMessageObject messageObject];
            UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"总统网校" descr:@"" thumImage:nil];
            shareObject.webpageUrl = ShareAppURL;
            shareMessage.shareObject = shareObject;
            [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:shareMessage currentViewController:self completion:^(id result, NSError *error) {
                if (error) {
                    NSLog(@"************Share fail with error %@*********",error);
                    [XZCustomWaitingView showAutoHidePromptView:@"分享失败" background:nil showTime:1.0];
                } else {
                    NSLog(@"response data is %@",result);
                }
            }];
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString *filePath = [ManagerTools getFilePathWithFileName:LocalDataPlist];
            NSString *currentKey = [NSString stringWithFormat:@"%@-%@-%ld",[USER_DEFAULTS objectForKey:EIID],[USER_DEFAULTS objectForKey:COURSEID],(long)self.type];
            if ([fileManager fileExistsAtPath:filePath]) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
                if ([[dic allKeys] containsObject:currentKey]) {
                    for (NSString *key in [dic allKeys]) {
                        if ([key isEqualToString:currentKey]) {
                            NSMutableDictionary *currentDic = dic[currentKey];
                            if (platformType == UMSocialPlatformType_WechatTimeLine || platformType == UMSocialPlatformType_Qzone) {
                                [currentDic setObject:@"1" forKey:@"Zone"];
                            } else if (platformType == UMSocialPlatformType_WechatSession || platformType == UMSocialPlatformType_QQ) {
                                [currentDic setObject:@"1" forKey:@"Group"];
                            }
                            if ([currentDic[@"Group"] boolValue] && [currentDic[@"Zone"] boolValue]) {
                                [currentDic setObject:[[[NSDateFormatter alloc] init] stringFromDate:[NSDate date]] forKey:@"time"];
                            }
                            [dic setObject:currentDic forKey:currentKey];
                        }
                        break;
                    }
                } else {
                    NSMutableDictionary *temDic = [NSMutableDictionary dictionaryWithCapacity:10];
                    [temDic setObject:@"0" forKey:@"Zone"];
                    [temDic setObject:@"0" forKey:@"Group"];
                    if (platformType == UMSocialPlatformType_WechatTimeLine || platformType == UMSocialPlatformType_Qzone) {
                        [temDic setObject:@"1" forKey:@"Zone"];
                    } else if (platformType == UMSocialPlatformType_WechatSession || platformType == UMSocialPlatformType_QQ) {
                        [temDic setObject:@"1" forKey:@"Group"];
                    }
                    if ([temDic[@"Group"] boolValue] && [temDic[@"Zone"] boolValue]) {
                        [temDic setObject:[[[NSDateFormatter alloc] init] stringFromDate:[NSDate date]] forKey:@"time"];
                    }
                    [dic setObject:temDic forKey:currentKey];
                }
                //写入文件
                if ([dic writeToFile:filePath atomically:YES]) {
                    NSLog(@"LocalDataPlist.Plist写入成功");
                } else {
                    NSLog(@"LocalDataPlist.Plist写入失败");
                }
            } else {
                [fileManager createFileAtPath:filePath contents:nil attributes:nil];
                
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:10];
                NSMutableDictionary *temDic = [NSMutableDictionary dictionaryWithCapacity:10];
                [temDic setObject:@"0" forKey:@"Zone"];
                [temDic setObject:@"0" forKey:@"Group"];
                if (platformType == UMSocialPlatformType_WechatTimeLine || platformType == UMSocialPlatformType_Qzone) {
                    [temDic setObject:@"1" forKey:@"Zone"];
                } else if (platformType == UMSocialPlatformType_WechatSession || platformType == UMSocialPlatformType_QQ) {
                    [temDic setObject:@"1" forKey:@"Group"];
                }
                if ([temDic[@"Group"] boolValue] && [temDic[@"Zone"] boolValue]) {
                    [temDic setObject:[[[NSDateFormatter alloc] init] stringFromDate:[NSDate date]] forKey:@"time"];
                }
                [dic setObject:temDic forKey:currentKey];
                //写入文件
                if ([dic writeToFile:filePath atomically:YES]) {
                    NSLog(@"LocalDataPlist.Plist写入成功");
                } else {
                    NSLog(@"LocalDataPlist.Plist写入失败");
                }
            }
        }
    }];
}

#pragma mark - OptionButtonView 代理方法
- (void)optionViewButtonClickedWithBtnTag:(NSInteger)btnTag
{
    [USER_DEFAULTS setInteger:btnTag forKey:Question_Mode];
    [USER_DEFAULTS synchronize];
}

#pragma mark - 判断是否为学霸必备模块儿
- (BOOL)judgeIsModule
{
    if (self.type == 5 || self.type == 6 || self.type == 13 || self.type == 14) {
        return YES;
    }
    return NO;
}
- (NSString *)getImgNameWithType:(NSInteger)type
{
    if (self.type == 5) {  //高频数据
        return @"gaopinshujubanner.png";
    } else if (self.type == 6) {  //教材强化
        return @"jiaocaiqianghuabanner.png";
    } else if (self.type == 13) {  //历年真题
        return @"linianzhentibanner.png";
    } else if (self.type == 14) {  //冲刺密卷
        return @"chongcimijuanbanner.png";
    } else {
        return @"banner.png";
    }
}

#pragma mark -
#pragma mark - 导航按钮
- (void)baseNaviButtonClickedWithBtnType:(naviBtnType)btnType
{
    if (btnType == LeftBtnType) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if (btnType == RightBtnType) {
//        [self DataShareToQQAndWeChat];
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
