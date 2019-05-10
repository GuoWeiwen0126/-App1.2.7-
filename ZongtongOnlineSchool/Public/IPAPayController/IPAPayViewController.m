//
//  IPAPayViewController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/16.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "IPAPayViewController.h"
#import "Tools.h"
#import <StoreKit/StoreKit.h>
#import "WalletModel.h"
#import "UserManager.h"

//沙箱环境URL
#define SANDBOX_VERIFY_RECEIPT_URL @"https://sandbox.itunes.apple.com/verifyReceipt"
//上线环境URL
#define Buy_Verify_Receipt_Url  @"https://buy.itunes.apple.com/verifyReceipt"

@interface IPAPayViewController () <SKProductsRequestDelegate,SKPaymentTransactionObserver>
@end

@implementation IPAPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self configNavigationBarWithNaviTitle:@"购买界面" naviFont:18.0f leftBtnTitle:@"back.png" rightBtnTitle:@"" bgColor:MAIN_RGB];
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    //开启内购检测
    if ([SKPaymentQueue canMakePayments])
    {
        [self requestProductDataWithProductId:self.proModel.iosPid];
    }
    else
    {
        NSLog(@"不允许应用内购买");
        [XZCustomViewManager showSystemAlertViewWithTitle:@"温馨提示" message:@"您的手机没有打开程序内付费购买功能" cancelButtonTitle:@"取消" otherButtonTitle:@"返回" isTouchbackground:NO withAlertViewType:XZAlertViewTypeSystemAlert handler:^(XZCustomAlertView *alertView, XZAlertViewBtnTag buttonIndex, XZAlertViewType alertViewType) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}
#pragma mark - 去苹果服务器请求商品
- (void)requestProductDataWithProductId:(NSString *)productId
{
    NSArray *productArray = [[NSArray alloc] initWithObjects:productId, nil];
    NSSet *productSet = [NSSet setWithArray:productArray];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:productSet];
    request.delegate = self;
    
    [request start];
    [XZCustomWaitingView showWaitingMaskView:@"正在连接苹果服务器" iconName:LoadingImage iconNumber:4];
}
#pragma mark - 收到产品返回信息
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSLog(@"-----------收到产品返回信息-----------");
    NSArray *productArray = response.products;
    if (productArray.count == 0)
    {
        NSLog(@"-----------无法获取商品信息，请重试-----------");
        [XZCustomWaitingView hideWaitingMaskView];
        [XZCustomWaitingView showAutoHidePromptView:@"商品信息获取失败" background:nil showTime:1.0];
        [OrderManager orderManagerIosPayBackWithOid:self.oid state:@"0" IOSPid:self.proModel.iosPid certificate:@"购买失败" payTime:self.proModel.insertTime completed:^(id obj) {}];
        return;
    }
    NSLog(@"productID:%@", response.invalidProductIdentifiers);
    NSLog(@"产品付费数量:%lu",(unsigned long)[productArray count]);
    
    SKProduct *product = nil;
    for (SKProduct *pro in productArray)
    {
        NSLog(@"产品返回信息：%@", [pro description]);
        NSLog(@"产品返回信息：%@", [pro localizedTitle]);
        NSLog(@"产品返回信息：%@", [pro localizedDescription]);
        NSLog(@"产品返回信息：%@", [pro price]);
        NSLog(@"产品返回信息：%@", [pro productIdentifier]);
        
        if([pro.productIdentifier isEqualToString:self.proModel.iosPid])
        {
            product = pro;
        }
    }
    
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    NSLog(@"发送购买请求");
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}
#pragma mark - 请求失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    [XZCustomWaitingView hideWaitingMaskView];
    [XZCustomWaitingView showAutoHidePromptView:@"支付失败\n苹果服务器请求失败" background:nil showTime:1.0];
    NSLog(@"-----------请求失败错误-----------:%@", error);
    [OrderManager orderManagerIosPayBackWithOid:self.oid state:@"0" IOSPid:self.proModel.iosPid certificate:@"购买失败" payTime:self.proModel.insertTime completed:^(id obj) {}];
}
#pragma mark - 反馈信息结束
- (void)requestDidFinish:(SKRequest *)request
{
    NSLog(@"-----------反馈信息结束-----------");
}
#pragma mark - 监听购买结果
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions
{
    for (SKPaymentTransaction *tran in transactions)
    {
        NSLog(@"打印错误日志：---%@",tran.error.description);
        switch (tran.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
            {
                NSLog(@"~~~交易完成");
                [XZCustomWaitingView hideWaitingMaskView];
                [XZCustomWaitingView showWaitingMaskView:@"验证支付结果" iconName:LoadingImage iconNumber:4];
                [self completeTransaction:tran];
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
            }
                break;
            case SKPaymentTransactionStatePurchasing:
            {
                NSLog(@"~~~商品添加进列表");
            }
                break;
            case SKPaymentTransactionStateRestored:
            {
                NSLog(@"~~~已购买过商品");
            }
                break;
            case SKPaymentTransactionStateFailed:
            {
                NSLog(@"~~~交易失败");
                [XZCustomWaitingView hideWaitingMaskView];
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                [XZCustomViewManager showSystemAlertViewWithTitle:@"温馨提示" message:@"交易失败\n苹果内购产品购买失败" cancelButtonTitle:@"" otherButtonTitle:@"确定" isTouchbackground:NO withAlertViewType:XZAlertViewTypeSystemAlert handler:^(XZCustomAlertView *alertView, XZAlertViewBtnTag buttonIndex, XZAlertViewType alertViewType) {}];
                [OrderManager orderManagerIosPayBackWithOid:self.oid state:@"0" IOSPid:self.proModel.iosPid certificate:@"购买失败" payTime:self.proModel.insertTime completed:^(id obj) {}];
            }
                break;
                
            default:
                break;
        }
    }
}
#pragma mark - 交易结束
- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"-----------交易结束-----------");
    //给服务器返回交易的相关数据
    NSLog(@"交易结束返回信息：%@",transaction.downloads);
    NSLog(@"交易结束返回信息：%@",transaction.transactionDate);
    NSLog(@"交易结束返回信息：%@",transaction.transactionIdentifier);
    //    NSLog(@"交易结束返回信息：%@",transaction.transactionReceipt);
    NSLog(@"交易结束返回信息：%@",transaction.payment.productIdentifier);
    NSLog(@"交易结束返回信息：%ld",(long)transaction.transactionState);
    
    [XZCustomWaitingView hideWaitingMaskView];
    if ([self verifyPruchase] == NO)
    {
        [XZCustomWaitingView showAutoHidePromptView:@"苹果服务器\n支付验证失败" background:nil showTime:1.0];
    }
    else
    {
        if (IsLocalAccount) {
            NSInteger pidNum = [[self.proModel.iosPid stringByReplacingOccurrencesOfString:@"ZongtongOnlineSchool" withString:@""] integerValue];
            if (pidNum == 18) {
                pidNum = 19;
            } else if (pidNum == 30) {
                pidNum = 32;
            } else if (pidNum == 88) {
                pidNum = 95;
            } else if (pidNum == 188) {
                pidNum = 200;
            }
            NSInteger goldNum = pidNum * 100;
            NSInteger totalGoldNum = [USER_DEFAULTS integerForKey:User_sum_LocalAccount] + goldNum;
            [USER_DEFAULTS setInteger:totalGoldNum forKey:User_sum_LocalAccount];
            [USER_DEFAULTS synchronize];
            [XZCustomViewManager showSystemAlertViewWithTitle:@"温馨提示" message:@"支付成功\n开启全新的学习之旅" cancelButtonTitle:@"" otherButtonTitle:@"确定" isTouchbackground:NO withAlertViewType:XZAlertViewTypeSystemAlert handler:^(XZCustomAlertView *alertView, XZAlertViewBtnTag buttonIndex, XZAlertViewType alertViewType) {
                [OrderManager paySuccessBackToMainWithVC:self];
            }];
        } else {
            NSURL *receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
            NSData *receiptData = [NSData dataWithContentsOfURL:receiptUrl];
            NSString *receipt = [receiptData base64EncodedStringWithOptions:0];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy-MM-dd hh:mm:ss";
            NSString *payTimeStr = [formatter stringFromDate:transaction.transactionDate];
            [XZCustomWaitingView showAdaptiveWaitingMaskView:@"验证支付结果" iconName:LoadingImage iconNumber:4];
            [OrderManager orderManagerIosPayBackWithOid:self.oid state:@"10086" IOSPid:self.proModel.iosPid certificate:receipt payTime:payTimeStr completed:^(id obj) {
                if (obj != nil) {
                    //更新金币余额
                    [UserManager UserSumWithUid:[USER_DEFAULTS objectForKey:User_uid] completed:^(id obj) {
                        if (obj != nil) {
                            if (IsLocalAccount == NO) {
                                [USER_DEFAULTS setInteger:[obj integerValue] forKey:User_sum];
                                [USER_DEFAULTS synchronize];
                            }
                        }
                    }];
                    [XZCustomViewManager showSystemAlertViewWithTitle:@"温馨提示" message:@"支付成功\n开启全新的学习之旅" cancelButtonTitle:@"" otherButtonTitle:@"确定" isTouchbackground:NO withAlertViewType:XZAlertViewTypeSystemAlert handler:^(XZCustomAlertView *alertView, XZAlertViewBtnTag buttonIndex, XZAlertViewType alertViewType) {
                        [OrderManager paySuccessBackToMainWithVC:self];
                    }];
                } else {
                    [XZCustomWaitingView showAutoHidePromptView:@"支付验证失败" background:nil showTime:1.0];
                }
            }];
        }
    }
}
#pragma mark - 验证购买凭证
- (BOOL)verifyPruchase
{
    //获取验证凭证
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    //从沙盒中获取购买凭证
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
    //验证URL POST请求
    NSURL *url = [NSURL URLWithString:Buy_Verify_Receipt_Url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    request.HTTPMethod = @"POST";
    //进行Base64加密
    NSString *encodeStr = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    NSString *payload = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", encodeStr];
    NSData *payloadData = [payload dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = payloadData;
    // 提交验证请求，并获得官方的验证JSON结果
    NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    // 官方验证结果为空
    if (result == nil) {
        NSLog(@"验证失败");
        return NO;
    }else{
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"线上环境验证结果%@",dict);
        //如果是沙盒环境
        if ([[dict objectForKey:@"status"] integerValue] == 21007) {
            if ([self verifyPruchaseInSandBox]) {
                return YES;
            } else {
                return NO;
            }
        }else if ([[dict objectForKey:@"status"] integerValue] == 0){
            NSLog(@"线上环境验证成功");
            return YES;
        }else{
            NSLog(@"线上环境验证失败");
            return NO;
        }
    }
}
#pragma mark - 在沙盒中验证
- (BOOL)verifyPruchaseInSandBox
{
    //获取验证凭证
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    //从沙盒中获取购买凭证
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
    //验证URL POST请求
    NSURL *url = [NSURL URLWithString:SANDBOX_VERIFY_RECEIPT_URL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    request.HTTPMethod = @"POST";
    //进行Base64加密
    NSString *encodeStr = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    NSString *payload = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", encodeStr];
    NSData *payloadData = [payload dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = payloadData;
    // 提交验证请求，并获得官方的验证JSON结果
    NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (result== nil) {
        NSLog(@"沙盒验证失败");
        return YES;
    }else{
        NSLog(@"沙盒验证成功");
        return YES;
    }
}

#pragma mark - dealloc
- (void)dealloc
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
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

@end
