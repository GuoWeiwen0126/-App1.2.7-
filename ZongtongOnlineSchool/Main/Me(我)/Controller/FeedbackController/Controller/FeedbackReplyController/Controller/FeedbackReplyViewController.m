//
//  FeedbackReplyViewController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/5.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "FeedbackReplyViewController.h"
#import "Tools.h"
#import "FeedbackManager.h"
#import "FeedbackModel.h"
#import "QuestionModel.h"
#import "FeedbackReplyTableView.h"
#import "ReplyTableView.h"
#import "ReplyBottomView.h"
#import "ReplyEvaluateView.h"

@interface FeedbackReplyViewController () <ReplyEvaluateViewDelegate>
{
    NSInteger _page;
    NSInteger _pagesize;
    NSInteger _maxPage;
    NSInteger _rowCount;
}
@property (nonatomic, strong) FeedbackReplyTableView *fbtableView;
@property (nonatomic, strong) UIButton *showReplyBtn;
@property (nonatomic, strong) UIView *replyBgView;
@property (nonatomic, strong) ReplyTableView *replyTableView;
@property (nonatomic, strong) ZTStarView *starView;
@property (nonatomic, strong) ReplyBottomView *replyBottomView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) ReplyEvaluateView *replyEvaluateView;
@end

@implementation FeedbackReplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _page = 1;
    _pagesize = 10;
    self.dataArray = [NSMutableArray arrayWithCapacity:10];
    
    [self createUI];
    [self registerNotification];
    [self getFeedbackReplyListData];
}
#pragma mark - 获取反馈回复列表
- (void)getFeedbackReplyListData
{
    [FeedbackManager feedbackManagerFeedbackReplyBasicPageWithFid:[NSString stringWithFormat:@"%ld",(long)self.fbModel.fid] page:[NSString stringWithFormat:@"%ld",(long)_page] pagesize:[NSString stringWithFormat:@"%ld",(long)_pagesize] completed:^(id obj) {
        if (obj != nil) {
            NSDictionary *dic = (NSDictionary *)obj;
            if ([dic[@"List"] count] == 0) {
                self.replyTableView.dataArray = self.dataArray;
                [self.replyTableView reloadData];
            } else {
                _page     = [dic[@"NowPage"]  integerValue];
                _pagesize = [dic[@"PageSize"] integerValue];
                _maxPage  = [dic[@"MaxPage"]  integerValue];
                _rowCount = [dic[@"RowCount"] integerValue];
                /*** ***  利用信号量预防For循环内发送请求出现数据顺序混乱的情况  *** ***/
                //创建一个全局队列
                dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
                //创建一个信号量(0)
                dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
                dispatch_async(queue, ^ {
                    /* * * 遍历获取到全部的数据 * * */
                    for (NSInteger i = 1; i < _maxPage+1; i ++)
                    {
                        [FeedbackManager feedbackManagerFeedbackReplyBasicPageWithFid:[NSString stringWithFormat:@"%ld",(long)self.fbModel.fid] page:[NSString stringWithFormat:@"%ld",(long)i] pagesize:[NSString stringWithFormat:@"%ld",(long)_pagesize] completed:^(id obj) {
                            if (obj != nil) {
                                NSDictionary *dataDic = (NSDictionary *)obj;
                                for (NSDictionary *listDic in (NSArray *)dataDic[@"List"]) {
                                    FeedbackReplyModel *fbReplyModel = [FeedbackReplyModel yy_modelWithDictionary:listDic];
                                    [self.dataArray addObject:fbReplyModel];
                                }
                                if (self.dataArray.count == _rowCount) {  //加载完最后一条数据
                                    self.replyTableView.dataArray = self.dataArray;
                                    [self.replyTableView reloadData];
                                }
                                //信号量加 1
                                dispatch_semaphore_signal(semaphore);
                            }
                        }];
                        //信号量减 1
                        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
                    }
                });
            }
        }
    }];
}
#pragma mark - 配置UI
- (void)createUI
{
    [self configNavigationBarWithNaviTitle:@"反馈回复" naviFont:18.0f leftBtnTitle:@"back.png" rightBtnTitle:@"" bgColor:MAIN_RGB];
    
    self.showReplyBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, UI_SCREEN_HEIGHT - 44 - 5, UI_SCREEN_WIDTH - 10*2, 44)];
    self.showReplyBtn.backgroundColor = MAIN_RGB;
    [self.showReplyBtn setTitle:@"查看反馈回复" forState:UIControlStateNormal];
    [self.showReplyBtn addTarget:self action:@selector(showReplyTableView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.showReplyBtn];
    
    self.fbtableView = [[FeedbackReplyTableView alloc] initWithFrame:CGRectMake(0, self.navigationBar.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - self.navigationBar.height - self.showReplyBtn.height - 5*2) style:UITableViewStylePlain];
    self.fbtableView.qModel = self.qModel;
    [self.view addSubview:self.fbtableView];
    
    self.replyBgView = [[UIView alloc] initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT*0.6)];
    [self.view addSubview:self.replyBgView];
    self.replyTableView = [[ReplyTableView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT*0.6 - 50) style:UITableViewStylePlain];
    [self.replyBgView addSubview:self.replyTableView];
    self.starView = [[ZTStarView alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH - 120, 15, 100, 20) isEnable:NO];
    self.starView.grade = 0;
    [self.replyBgView addSubview:self.starView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapStarView)];
    [self.starView addGestureRecognizer:tap];
    self.replyBottomView = [[ReplyBottomView alloc] initWithFrame:CGRectMake(0, self.replyBgView.height - 50, UI_SCREEN_WIDTH, 50)];
    [self.replyBgView addSubview:self.replyBottomView];
}
#pragma mark - 注册通知
- (void)registerNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CloseReplyTableView) name:@"CloseReplyTableView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SendReplyContent:) name:@"SendReplyContent" object:nil];
}
#pragma mark - 展示反馈回复界面
- (void)showReplyTableView
{
    if (self.dataArray.count == 0) {
        [XZCustomWaitingView showAutoHidePromptView:@"暂无反馈回复" background:nil showTime:1.0];
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.fbtableView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT*0.4);
        self.replyBgView.frame = CGRectMake(0, UI_SCREEN_HEIGHT*0.4, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT*0.6);
    }];
}
#pragma mark - 点击评分按钮
- (void)tapStarView
{
    self.replyEvaluateView.hidden = NO;
}

#pragma mark -
#pragma mark - 通知方法
#pragma mark - 收起回复列表
- (void)CloseReplyTableView
{
    [self.replyBottomView.contentTF resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        self.fbtableView.frame = CGRectMake(0, self.navigationBar.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - self.navigationBar.height - self.showReplyBtn.height - 10*2);
        self.replyBgView.frame = CGRectMake(0, UI_SCREEN_HEIGHT, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT*0.6);
    }];
}
#pragma mark - 发送内容
- (void)SendReplyContent:(NSNotification *)noti
{
    [FeedbackManager feedbackManagerFeedbackReplyAddFRWithFrUid:[USER_DEFAULTS objectForKey:User_uid] fid:[NSString stringWithFormat:@"%ld",(long)self.fbModel.fid] userName:[USER_DEFAULTS objectForKey:User_name] content:(NSString *)noti.object completed:^(id obj) {
        if (obj != nil) {
            FeedbackReplyModel *fbReplyModel = [[FeedbackReplyModel alloc] init];
            fbReplyModel.userType = 1;
            fbReplyModel.userName = [USER_DEFAULTS objectForKey:User_name];
            fbReplyModel.content = (NSString *)noti.object;
            [self.dataArray addObject:fbReplyModel];
            self.replyTableView.dataArray = self.dataArray;
            [self.replyTableView reloadData];
#warning 这里需要数据做测试：当数据超过 self.replyTableView.height 的时候是否有异常
            if (self.replyTableView.contentSize.height > self.replyTableView.bounds.size.height) {
                [self.replyTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.replyTableView.dataArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
            //清空输入框
            [self.replyBottomView.contentTF resignFirstResponder];
            self.replyBottomView.contentTF.text = @"";
            self.replyBottomView.contentTF.placeholder = @"  请输入您要填写的内容";
        }
    }];
}

#pragma mark -
#pragma mark - 代理方法
#pragma mark - 反馈评分提交
- (void)submitReplyEvalauteWithGrade:(NSInteger)grade frComment:(NSString *)frComment
{
    [FeedbackManager feedbackManagerGradeWithFid:[NSString stringWithFormat:@"%ld",(long)self.fbModel.fid] uid:[USER_DEFAULTS objectForKey:User_uid] grade:[NSString stringWithFormat:@"%ld",(long)grade] frComment:frComment completed:^(id obj) {
        if (obj != nil) {
            [XZCustomWaitingView showAutoHidePromptView:@"评价成功" background:nil showTime:1.0];
            self.replyEvaluateView.hidden = YES;
            self.starView.grade = grade;
        }
    }];
}

#pragma mark -
#pragma mark - 导航按钮
- (void)baseNaviButtonClickedWithBtnType:(naviBtnType)btnType
{
    if (btnType == LeftBtnType)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark -
#pragma mark - 懒加载
- (ReplyEvaluateView *)replyEvaluateView {
    if (!_replyEvaluateView) {
        _replyEvaluateView = [[ReplyEvaluateView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
        _replyEvaluateView.hidden = YES;
        _replyEvaluateView.delegate = self;
        [self.view addSubview:_replyEvaluateView];
    }
    return _replyEvaluateView;
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
