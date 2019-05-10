//
//  TalkfunNewLoginViewController.h
//  TalkfunSDKDemo
//
//  Created by Sunzn on 2017/4/18.
//  Copyright © 2017年 Talkfun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TalkfunNewLoginViewController : UIViewController
//@property(nonatomic,strong)NSString *qrCodeUrl;
@property (nonatomic,assign) BOOL isScanIn;
@property (nonatomic,copy) NSString * liveid;
@property (nonatomic,copy) NSString * roomid;
@property (nonatomic,copy) NSString * type;
//@property (nonatomic,copy) NSString * sign;
@property (nonatomic,copy) NSString * mode;

@property (nonatomic,copy) NSString *temporary;//公开课不要密码

//是回放才设置
@property(nonatomic,assign)BOOL isPlayback;



@property (nonatomic,strong) NSDictionary *res;


@property (nonatomic,copy)NSString * role;//用户身份
@property (nonatomic,copy)NSString * et;//过期时间
@property (nonatomic,copy)NSString *  sign;//验证字符串;

@property (nonatomic,copy)NSString *logo;//logo url

@property (nonatomic,copy)NSString *title1;
@end
