//
//  AreaOptionViewController.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/14.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "AreaOptionViewController.h"
#import "Tools.h"
#import "AreaOptionTableView.h"

@interface AreaOptionViewController () <AreaOptionTableViewDelegate>
{
    NSArray *_provinceArray;
    NSString *_province;
}
@property (nonatomic, strong) AreaOptionTableView *provinceTableView;
@property (nonatomic, strong) AreaOptionTableView *cityTableView;

@end

@implementation AreaOptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configNavigationBarWithNaviTitle:@"选择地区" naviFont:18.0 leftBtnTitle:@"back.png" rightBtnTitle:@"" bgColor:MAIN_RGB];
    
    //读取本地省市Json
    _provinceArray = [ManagerTools getLocalJsonWithResource:@"citys" type:@"json"];
    
    //省
    self.provinceTableView = [[AreaOptionTableView alloc] initWithFrame:CGRectMake(0, self.navigationBar.bottom, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - self.navigationBar.height) style:UITableViewStylePlain areaArray:_provinceArray isExamArea:self.isExamArea];
    self.provinceTableView.areaType = ProvinceType;
    self.provinceTableView.areaOptionDelegate = self;
    [self.view addSubview:self.provinceTableView];
    //市
    self.cityTableView = [[AreaOptionTableView alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH, self.navigationBar.bottom, UI_SCREEN_WIDTH/2, UI_SCREEN_HEIGHT - self.navigationBar.height) style:UITableViewStylePlain areaArray:_provinceArray[0][@"citys"] isExamArea:self.isExamArea];
    self.cityTableView.areaType = CityType;
    self.cityTableView.areaOptionDelegate = self;
    [self.view addSubview:self.cityTableView];
}

#pragma mark - 省市点击代理方法
- (void)areaOptionClickedWithAreaType:(AreaType)areaType index:(NSInteger)index provinceStr:(NSString *)provinceStr cityStr:(NSString *)cityStr
{
    if (areaType == ProvinceType)
    {
        _province = provinceStr;
        self.cityTableView.areaArray = _provinceArray[index][@"citys"];
        [self.cityTableView reloadData];
        if (self.cityTableView.center.x > UI_SCREEN_WIDTH)
        {
            [UIView animateWithDuration:0.1f animations:^{
                self.cityTableView.frame = CGRectMake(UI_SCREEN_WIDTH/2, self.navigationBar.bottom, UI_SCREEN_WIDTH/2, UI_SCREEN_HEIGHT - self.navigationBar.height);
            }];
        }
    }
    else
    {
        if ([self.areaOptionDelegate respondsToSelector:@selector(areaOptionPopWithProvinceStr:cityStr:)])
        {
            NSLog(@"---省：%@---市：%@---",_province,cityStr);
            if (self.isExamArea) {
                [USER_DEFAULTS setObject:_province forKey:User_province];
                [USER_DEFAULTS setObject:cityStr forKey:User_city];
                [USER_DEFAULTS synchronize];
            }
            [self.areaOptionDelegate areaOptionPopWithProvinceStr:_province cityStr:cityStr];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
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
