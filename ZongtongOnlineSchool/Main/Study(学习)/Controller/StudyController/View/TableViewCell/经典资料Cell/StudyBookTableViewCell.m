//
//  StudyBookTableViewCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/8/9.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "StudyBookTableViewCell.h"
#import "Tools.h"
#import "HomeModel.h"
#import "StudyBookButton.h"

@interface StudyBookTableViewCell ()
@property (weak, nonatomic) IBOutlet UIView *verticalLineOne;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalLineHeight;
@property (weak, nonatomic) IBOutlet UIView *verticalLineTwo;
@property (weak, nonatomic) IBOutlet UIView *horizontalLineOne;
@property (weak, nonatomic) IBOutlet UIView *horizontalLineTwo;
@property (weak, nonatomic) IBOutlet UIView *horizontalLineThree;

@property (nonatomic, strong) NSMutableArray *btnArray;
@property (nonatomic, strong) StudyBookButton *bookBtn1;
@property (nonatomic, strong) StudyBookButton *bookBtn2;
@property (nonatomic, strong) StudyBookButton *bookBtn3;
@property (nonatomic, strong) StudyBookButton *bookBtn4;
@property (nonatomic, strong) StudyBookButton *bookBtn5;

@end

@implementation StudyBookTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.verticalLineHeight.constant = UI_SCREEN_WIDTH/2;
    
    [self addSubview:self.bookBtn1];
    [self addSubview:self.bookBtn2];
    [self addSubview:self.bookBtn3];
    [self addSubview:self.bookBtn4];
    [self addSubview:self.bookBtn5];
    self.btnArray = [NSMutableArray arrayWithCapacity:10];
    [self.btnArray addObject:self.bookBtn1];
    [self.btnArray addObject:self.bookBtn2];
    [self.btnArray addObject:self.bookBtn3];
    [self.btnArray addObject:self.bookBtn4];
    [self.btnArray addObject:self.bookBtn5];
}
#pragma mark - 配置UI
- (void)configViewWithArray:(NSMutableArray *)array {
    for (int i = 0; i < array.count; i ++) {
        HomeModuleModel *moduleModel = array[i];
        StudyBookButton *temButton = self.btnArray[i];
        temButton.moduleModel = moduleModel;
        if (moduleModel.type == 11) {  //资料下载
            temButton.topLabel.textColor = RGBA(125, 65, 236, 1.0);
            temButton.detailLabel.text = @"名师宝典海量资源";
        } else if (moduleModel.type == 5) {  //高频数据
            temButton.topLabel.textColor = RGBA(3, 153, 255, 1.0);
            temButton.detailLabel.text = @"专业老师精心编制";
        } else if (moduleModel.type == 6) {  //教材强化
            temButton.topLabel.textColor = RGBA(51, 51, 51, 1.0);
            temButton.detailLabel.text = @"多做多练提高快";
        } else if (moduleModel.type == 12) {  //视频解析
            temButton.topLabel.textColor = RGBA(51, 51, 51, 1.0);
            temButton.detailLabel.text = @"及时解惑高效提分";
        } else if (moduleModel.type == 14) {  //冲刺密卷
            temButton.topLabel.textColor = RGBA(241, 40, 59, 1.0);
            temButton.detailLabel.text = @"重点集锦干货云集";
        }
    }
//    for (HomeModuleModel *moduleModel in array) {
//        NSLog(@"***%@***%ld***%@***",moduleModel.title,(long)moduleModel.type,moduleModel.imgUrl);
//        if (moduleModel.type == 11) {  //资料下载
//            _bookBtn1.moduleModel = moduleModel;
//            _bookBtn1.detailLabel.text = @"名师宝典海量资源";
//        } else if (moduleModel.type == 5) {  //高频数据
//            _bookBtn2.moduleModel = moduleModel;
//            _bookBtn2.detailLabel.text = @"专业老师精心编制";
//        } else if (moduleModel.type == 6) {  //教材强化
//            _bookBtn3.moduleModel = moduleModel;
//            _bookBtn3.detailLabel.text = @"多做多练提高快";
//        } else if (moduleModel.type == 12) {  //视频解析
//            _bookBtn4.moduleModel = moduleModel;
//            _bookBtn4.detailLabel.text = @"及时解惑高效提分";
//        } else if (moduleModel.type == 14) {  //冲刺密卷
//            _bookBtn5.moduleModel = moduleModel;
//            _bookBtn5.detailLabel.text = @"重点集锦干货云集";
//        }
//    }
}
#pragma mark - 模块按钮点击
- (void)bookBtnClicked:(StudyBookButton *)btn {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BookBtnClicked" object:btn.moduleModel];
}

#pragma mark - 懒加载
- (StudyBookButton *)bookBtn1 {
    if (!_bookBtn1) {
        _bookBtn1 = [[StudyBookButton alloc] initWithFrame:CGRectMake(0, 30, UI_SCREEN_WIDTH/2, UI_SCREEN_WIDTH/2)];
        _bookBtn1.tag = 10;
        [_bookBtn1 addTarget:self action:@selector(bookBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_bookBtn1];
    }
    return _bookBtn1;
}
- (StudyBookButton *)bookBtn2 {
    if (!_bookBtn2) {
        _bookBtn2 = [[StudyBookButton alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH/2, 30, UI_SCREEN_WIDTH/2, UI_SCREEN_WIDTH/4)];
        _bookBtn2.tag = 11;
        [_bookBtn2 addTarget:self action:@selector(bookBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_bookBtn2];
    }
    return _bookBtn2;
}
- (StudyBookButton *)bookBtn3 {
    if (!_bookBtn3) {
        _bookBtn3 = [[StudyBookButton alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH/2, 30 + UI_SCREEN_WIDTH/4, UI_SCREEN_WIDTH/2, UI_SCREEN_WIDTH/4)];
        _bookBtn3.tag = 12;
        [_bookBtn3 addTarget:self action:@selector(bookBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_bookBtn3];
    }
    return _bookBtn3;
}
- (StudyBookButton *)bookBtn4 {
    if (!_bookBtn4) {
        _bookBtn4 = [[StudyBookButton alloc] initWithFrame:CGRectMake(0, 30 + 10 + UI_SCREEN_WIDTH/2, UI_SCREEN_WIDTH/2, UI_SCREEN_WIDTH/4)];
        _bookBtn4.tag = 13;
        [_bookBtn4 addTarget:self action:@selector(bookBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_bookBtn4];
    }
    return _bookBtn4;
}
- (StudyBookButton *)bookBtn5 {
    if (!_bookBtn5) {
        _bookBtn5 = [[StudyBookButton alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH/2, 30 + 10 + UI_SCREEN_WIDTH/2, UI_SCREEN_WIDTH/2, UI_SCREEN_WIDTH/4)];
        _bookBtn5.tag = 14;
        [_bookBtn5 addTarget:self action:@selector(bookBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_bookBtn5];
    }
    return _bookBtn5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
