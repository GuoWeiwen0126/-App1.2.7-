//
//  TalkfunScanViewController.m
//  TalkfunSDKDemo
//
//  Created by Sunzn on 2017/4/19.
//  Copyright © 2017年 Talkfun. All rights reserved.
//

#import "TalkfunScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "TalkfunShadowView.h"
#import "TalkfunInputNameViewController.h"
#import "TalkfunNewLoginViewController.h"
#import "TalkfunPlaybackViewController.h"

#import "TalkfunViewController.h"
#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
#define customShowSize CGSizeMake(IsIPAD?400:200, IsIPAD?400:200);

@interface TalkfunScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;
/** 预览图层尺寸 */
@property (nonatomic, assign) CGSize layerViewSize;
/** 有效扫码范围 */
@property (nonatomic, assign) CGSize showSize;
/** 作者自定义的View视图 */
@property (nonatomic, strong) TalkfunShadowView *shadowView;

@end

@implementation TalkfunScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请启用相机-设置/隐私/相机" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] ;
            [alert show];
        });
        return;
        
    }

    //显示范围
    self.showSize = customShowSize;
    
    //添加扫码相册按钮
    //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"相册中选" style:UIBarButtonItemStylePlain target:self action:@selector(takeQRCodeFromPic:)];
    
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
    
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:_session];
    _preview.videoGravity =AVLayerVideoGravityResizeAspectFill;
    
    [self.view.layer insertSublayer:_preview atIndex:0];
    
    [_session startRunning];
    
    //设置可用扫码范围
    [self allowScanRect];
    
    //添加上层阴影视图
    self.shadowView = [[TalkfunShadowView alloc] initWithFrame:CGRectMake(0, 44, kWidth, kHeight-44)];
    [self.view addSubview:self.shadowView];
    self.shadowView.showSize = self.showSize;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _preview.frame =self.view.layer.bounds;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (!_session.isRunning) {
        [_session startRunning];
    }
}
- (NSString *)encodeString:(NSString*)unencodedString{
    
    NSString*encodedString=(NSString*)
    
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              
                                                              (CFStringRef)unencodedString,
                                                              
                                                              NULL,
                                                              
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
    
}



- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *stringValue;
    if ([metadataObjects count] >0){
        //停止扫描
        [_session stopRunning];
        
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
        
        TalkfunNewLoginViewController * newLoginVC = [TalkfunNewLoginViewController new];
        newLoginVC.isScanIn = YES;
        NSDictionary * requestDict = @{@"qrCodeUrl":[self encodeString:stringValue]};
        
        WeakSelf
        [TalkfunLoginRequest requestForScanIn:requestDict callback:^(id result) {
            NSLog(@"回调次数");
            
            if ([result isKindOfClass:[NSDictionary class]] &&[result[@"code"] intValue] == 0) {
                
                NSDictionary * data = result[@"data"];
                //输入密码进入  回放
                if ([data[@"type"] isEqualToString:@"playbackLogin"]) {
                    newLoginVC.isPlayback = YES;
                    newLoginVC.liveid =   [data[@"liveid"] stringValue] ;
                    
                }
                //只要昵称  直播
                else if ([data[@"type"] isEqualToString:@"tempLogin"]) {
                    
                    // 4为直播，5为回放
                    if ([[data[@"mode"]  stringValue]  isEqualToString:@"4"]) {
                        newLoginVC.isPlayback = NO;
                    }else if ([[data[@"mode"]  stringValue]  isEqualToString:@"5"]){
                        //回放
                        newLoginVC.isPlayback = YES;
                    }
                    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
                    
                    [parameters setObject:data[@"logo"] forKey:@"logo"];
                    [UserDefault setObject:@{
                                             @"logo":data[@"logo"]} forKey:@"LogoUrl"];
                    
                    newLoginVC.liveid = [data[@"roomid"] stringValue];
                    newLoginVC.role = data[@"role"] ;
                    newLoginVC.temporary = data[@"temporary"] ;
                    newLoginVC.et = data[@"et"] ;
                    newLoginVC.sign = data[@"sign"];
                    newLoginVC.logo = data[@"logo"];
                    newLoginVC.title1 = data[@"title"] ;
                    
                }
                //输入帐号密码 直播
                else if ([data[@"type"] isEqualToString:@"liveLogin"]){
                    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
                    [parameters setObject:data[@"logo"] forKey:@"logo"];
                    newLoginVC.liveid = [data[@"roomid"] stringValue];
                    newLoginVC.title1 = data[@"title"] ;
                    [UserDefault setObject:@{@"logo":parameters[@"logo"]} forKey:@"LogoUrl"];
                }
                
                
                //直接进入  直播
                else if ([data[@"type"] isEqualToString:@"live"])  {
                    
                    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
                    
                    NSMutableDictionary *temp = [NSMutableDictionary dictionary];
                    [temp setObject:data[@"access_token"] forKey:@"access_token"];
                    [temp setObject:data[@"title"] forKey:@"title"];
                    [temp setObject:data[@"logo"] forKey:@"logo"];
                    [parameters setObject:temp forKey:@"data"];
                    [parameters setObject:@"0" forKey:@"code"];
                    
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        TalkfunViewController*  myVC = [[TalkfunViewController alloc] init];
                        myVC.res = parameters;
                        
                        [weakSelf.navigationController pushViewController:myVC animated:YES];
                        
                    });
                    
                    
                    return;
                }
                //直接进入  回放
                else if ([data[@"type"] isEqualToString:@"playback"]) {
                    
                    NSDictionary *parameters = @{
                                                 @"offlineKey":  [NSString stringWithFormat:@"%@",data[@"liveid"]],
                                                 @"data" : @{
                                                         @"title" : data[@"title"],
                                                         @"logo"  : data[@"logo"],
                                                         @"access_token" : data[@"access_token"],
                                                         },
                                                 @"code" : @"0",
                                                 };
                    
                    
                    
                    [UserDefault setObject:@{
                                             @"logo":parameters[@"data"][@"logo"]} forKey:@"LogoUrl"];
                    
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        TalkfunPlaybackViewController*  playbackVC = [[TalkfunPlaybackViewController alloc] init];
                        
                        playbackVC.playbackID = @"1515263";
                        playbackVC.res = parameters;
                        
                        [weakSelf.navigationController pushViewController:playbackVC animated:YES];
                        
                        NSLog(@"跳转次数");
                        
                    });
                    
                    return;
                    
                    
               //课程登陆
                } else if ([data[@"type"] isEqualToString:@"courseLogin"]) {
                    if ([[data[@"mode"]  stringValue]  isEqualToString:@"4"]) {
                        newLoginVC.isPlayback = NO;
                       
                    }else if ([[data[@"mode"]  stringValue]  isEqualToString:@"5"]){
                        //回放
                        newLoginVC.isPlayback = YES;
                        
                    }
                     newLoginVC.liveid = [data[@"courseId"] stringValue];
//                    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//
//                    [parameters setObject:data[@"logo"]?data[@"logo"]:@"" forKey:@"logo"];
//                    [UserDefault setObject:@{
//                                             @"logo":data[@"logo"]?data[@"logo"]:@""} forKey:@"LogoUrl"];
//
                   
                    newLoginVC.role = data[@"role"] ;
//                    newLoginVC.temporary = data[@"temporary"] ;
//                    newLoginVC.et = data[@"et"] ;
//                    newLoginVC.sign = data[@"sign"];
                    newLoginVC.logo = data[@"logo"];
                    newLoginVC.title1 = data[@"title"] ;
                    
                }
                
            }
            else{
                
                if ([result isKindOfClass:[NSDictionary class]]){
                    if (result[@"msg"]){
                        
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [weakSelf.view toast:result[@"msg"] position:ToastPosition];
                            
                            
                        });
                        
                    }
                    
                    
                    [_session startRunning];
                    
                }
                return;
                
                
            }
            
            
            
            NSLog(@"来的次数");
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.navigationController pushViewController:newLoginVC animated:YES];
            });
            
        }];
        
        
        
    }
}

/** 配置扫码范围 */
-(void)allowScanRect{
    
    
    /** 扫描是默认是横屏, 原点在[右上角]
     *  rectOfInterest = CGRectMake(0, 0, 1, 1);
     *  AVCaptureSessionPresetHigh = 1920×1080   摄像头分辨率
     *  需要转换坐标 将屏幕与 分辨率统一
     */
    
    //剪切出需要的大小位置
    CGRect shearRect = CGRectMake((self.layerViewSize.width - self.showSize.width) / 2,
                                  (self.layerViewSize.height - self.showSize.height) / 3,
                                  self.showSize.height,
                                  self.showSize.height);
    
    
    CGFloat deviceProportion = 1920.0 / 1080.0;
    CGFloat screenProportion = self.layerViewSize.height / self.layerViewSize.width;
    
    //分辨率比> 屏幕比 ( 相当于屏幕的高不够)
    if (deviceProportion > screenProportion) {
        //换算出 分辨率比 对应的 屏幕高
        CGFloat finalHeight = self.layerViewSize.width * deviceProportion;
        // 得到 偏差值
        CGFloat addNum = (finalHeight - self.layerViewSize.height) / 2;
        
        // (对应的实际位置 + 偏差值)  /  换算后的屏幕高
        self.output.rectOfInterest = CGRectMake((shearRect.origin.y + addNum) / finalHeight,
                                                shearRect.origin.x / self.layerViewSize.width,
                                                shearRect.size.height/ finalHeight,
                                                shearRect.size.width/ self.layerViewSize.width);
        
    }else{
        
        CGFloat finalWidth = self.layerViewSize.height / deviceProportion;
        
        CGFloat addNum = (finalWidth - self.layerViewSize.width) / 2;
        
        self.output.rectOfInterest = CGRectMake(shearRect.origin.y / self.layerViewSize.height,
                                                (shearRect.origin.x + addNum) / finalWidth,
                                                shearRect.size.height / self.layerViewSize.height,
                                                shearRect.size.width / finalWidth);
    }
    
}

- (IBAction)backBtnClicked:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc{
    
}

@end
