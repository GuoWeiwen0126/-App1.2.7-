//
//  ApplyForTrialViewController.m
//  TalkfunSDKDemo
//
//  Created by 孙兆能 on 16/5/16.
//  Copyright © 2016年 talk-fun. All rights reserved.
//

#import "ApplyForTrialViewController.h"

@interface ApplyForTrialViewController ()<NSURLConnectionDataDelegate>

@property (weak, nonatomic ) IBOutlet UITextView    *textView;
@property (nonatomic,strong) NSMutableData * mutableData;

@end

@implementation ApplyForTrialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBar.hidden = YES;
    
    NSData * data = [[NSUserDefaults standardUserDefaults] objectForKey:@"applyData"];
    if (data) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        self.textView.text = dict[@"data"][@"message"];
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSURLRequest * request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://api.talk-fun.com/app/demo.php"]];
    
    NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

//MARK:NSURLConnection 代理方法
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.mutableData = [[NSMutableData alloc] init];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.mutableData appendData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:self.mutableData options:0 error:nil];
    self.textView.text = dict[@"data"][@"message"];
    
    [self saveData:self.mutableData];
}

//MARK:ok按钮和×按钮点击事件
- (IBAction)okBtnClicked:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)saveData:(NSData *)data{
    
//    NSString * filePath = [NSHomeDirectory() stringByAppendingString:@"/Library"];
//    [data writeToFile:filePath atomically:YES];
    
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"applyData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

@end
