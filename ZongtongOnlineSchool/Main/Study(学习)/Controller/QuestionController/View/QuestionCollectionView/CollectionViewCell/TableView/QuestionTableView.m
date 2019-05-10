//
//  QuestionTableView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/7.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "QuestionTableView.h"
#import "Tools.h"
#import "QuestionCell.h"
#import "OptionCell.h"
#import "LookAnalyseCell.h"
#import "AnswerCell.h"
#import "AnalyseCell.h"
#import "VideoCell.h"
#import "FeedbackCell.h"
#import "NoteCell.h"
#import "NoteHaveCell.h"

@interface QuestionTableView () <UITableViewDelegate, UITableViewDataSource>

@end
static NSString *cellID_Question = @"cellID_Question";
static NSString *cellID_Option   = @"cellID_Option";
static NSString *cellID_LookAnalyse = @"cellID_LookAnalyse";
static NSString *cellID_Answer   = @"cellID_Answer";
static NSString *cellID_Analyse  = @"cellID_Analyse";
static NSString *cellID_Video    = @"cellID_Video";
static NSString *cellID_Feedback = @"cellID_Feedback";
static NSString *cellID_Note     = @"cellID_Note";
static NSString *cellID_NoteHave = @"cellID_NoteHave";
@implementation QuestionTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"QuestionCell" bundle:nil] forCellReuseIdentifier:cellID_Question];
        [self registerNib:[UINib nibWithNibName:@"OptionCell"   bundle:nil] forCellReuseIdentifier:cellID_Option];
        [self registerNib:[UINib nibWithNibName:@"LookAnalyseCell"   bundle:nil] forCellReuseIdentifier:cellID_LookAnalyse];
        [self registerNib:[UINib nibWithNibName:@"AnswerCell"   bundle:nil] forCellReuseIdentifier:cellID_Answer];
        [self registerNib:[UINib nibWithNibName:@"AnalyseCell"  bundle:nil] forCellReuseIdentifier:cellID_Analyse];
        [self registerNib:[UINib nibWithNibName:@"VideoCell"    bundle:nil] forCellReuseIdentifier:cellID_Video];
        [self registerNib:[UINib nibWithNibName:@"FeedbackCell" bundle:nil] forCellReuseIdentifier:cellID_Feedback];
        [self registerNib:[UINib nibWithNibName:@"NoteCell"     bundle:nil] forCellReuseIdentifier:cellID_Note];
        [self registerNib:[UINib nibWithNibName:@"NoteHaveCell" bundle:nil] forCellReuseIdentifier:cellID_NoteHave];
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.sectionHeaderHeight = 0;
        self.sectionFooterHeight = 0;
        self.estimatedRowHeight = 0;
    }
    
    return self;
}

#pragma mark - tableView协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    self.backgroundColor = [USER_DEFAULTS boolForKey:Question_DayNight] ? Night_RGB_BGColor:[UIColor whiteColor];
    if ([USER_DEFAULTS integerForKey:Question_Mode] == 2 || [USER_DEFAULTS boolForKey:Question_IsAnalyse] == YES) {
        return 3;
    }
    if ([USER_DEFAULTS integerForKey:Question_Mode] == 0 && self.questionModel.isLookAnswer == YES) {
        return 3;
    }
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)  //题干、选项
    {
        if (self.questionModel.optionList.count > 10) {
            return 1 + 10;
        }
        if (self.questionModel.qTypeListModel.showKey == 0) {
            return 1 + 1;
        }
        if ([USER_DEFAULTS integerForKey:Question_Mode] == 0 && self.questionModel.isLookAnswer == NO && [USER_DEFAULTS boolForKey:Question_IsAnalyse] == NO) {
            return 1 + self.questionModel.optionList.count + 1;
        }
        return 1 + self.questionModel.optionList.count;
    }
    else if (section == 1)  //答案、解析、视频解析
    {
        return 3;
    }
    else  //云笔记
    {
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)  //题干、选项
    {
        if (indexPath.row == 0)  //题干
        {
            NSString *questionStr = @"";
            if (self.questionModel.stem.length == 0) {
                questionStr = self.questionModel.issue;
            } else {
                questionStr = [NSString stringWithFormat:@"%@\n\n%@",self.questionModel.stem,self.questionModel.issue];
            }
            if (self.questionModel.stemTail.length == 0) {
                if ([questionStr containsString:@"「"] || [questionStr containsString:@"」"]) {  //包含图片
                    return [self getImageCellHeightWithQStr:questionStr] + 20;
                } else {
                    return [ManagerTools adaptHeightWithString:questionStr FontSize:[USER_DEFAULTS floatForKey:QLabelFont] SizeWidth:UI_SCREEN_WIDTH - 20*2] + 20;
                }
            } else {
                if ([questionStr containsString:@"「"] || [questionStr containsString:@"」"]) {  //包含图片
                    return [self getImageCellHeightWithQStr:questionStr] + 20;
                } else {
                    return [ManagerTools adaptHeightWithString:[NSString stringWithFormat:@"%@  （%@）",questionStr,self.questionModel.stemTail] FontSize:[USER_DEFAULTS floatForKey:QLabelFont] SizeWidth:UI_SCREEN_WIDTH - 20*2] + 20;
                }
            }
        }
        else  //选项
        {
            if (self.questionModel.qTypeListModel.showKey == 0) {
                return 160;
            }
            if ([USER_DEFAULTS integerForKey:Question_Mode] == 0 && self.questionModel.isLookAnswer == NO && indexPath.row == self.questionModel.optionList.count + 1) {
                return 60;
            }
            return [ManagerTools adaptHeightWithString:[ManagerTools deleteSpaceAndNewLineWithString:self.questionModel.optionList[indexPath.row - 1].option] FontSize:[USER_DEFAULTS floatForKey:QLabelFont] SizeWidth:UI_SCREEN_WIDTH - 70] + 20;
        }
    }
    else if (indexPath.section == 1)  //答案、解析、视频解析、问题反馈
    {
        if (indexPath.row == 0)  //答案
        {
            return 160.0f;
        }
        else if (indexPath.row == 1)  //解析
        {
            float analyseHeight = 0;
            if ([self.questionModel.analysis containsString:@"「"] || [self.questionModel.analysis containsString:@"」"]) {  //包含图片
                analyseHeight = [self getImageCellHeightWithQStr:self.questionModel.analysis];
            } else {
                analyseHeight = [ManagerTools adaptHeightWithString:self.questionModel.analysis FontSize:[USER_DEFAULTS floatForKey:QLabelFont] SizeWidth:UI_SCREEN_WIDTH - 20*2];
            }
            
            return analyseHeight + 40;
        }
        else  //视频解析
        {
            return self.questionModel.vid == 0 ? 0.0f:100.0f;
        }
    }
    else  //云笔记
    {
        if ([self.questionModel.qNoteModel.isNoteLook integerValue] == 1) {
            if (self.questionModel.qNoteModel.content) {
                return [ManagerTools adaptHeightWithString:self.questionModel.qNoteModel.content FontSize:14.0 SizeWidth:UI_SCREEN_WIDTH - 115] + 150;
            } else {
                return 120.f;
            }
        } else {
            return 40.0f;
        }
    }
}
#pragma mark - 返回有图片的cell高度
- (CGFloat)getImageCellHeightWithQStr:(NSString *)Str
{
    NSArray *imgArray = [Str queryNameWithQIssueStr:[Str mutableCopy] fromStr:@"「" toStr:@"」"];
    NSMutableArray *textArray = [NSMutableArray arrayWithCapacity:10];
    NSString *temIssue = [NSString stringWithString:Str];
    //遍历拼接题干
    for (int i = 0; i < imgArray.count; i ++) {
        NSArray *temArray = [temIssue componentsSeparatedByString:imgArray[i]];
        [textArray addObject:temArray.firstObject];
        [textArray addObject:imgArray[i]];
        //删除已经拼接过的题干
        temIssue = [temIssue stringByReplacingCharactersInRange:NSMakeRange(0, [NSString stringWithFormat:@"%@",temArray.firstObject].length) withString:@""];
        temIssue = [temIssue stringByReplacingCharactersInRange:NSMakeRange(0, [NSString stringWithString:imgArray[i]].length) withString:@""];
        if (i == imgArray.count - 1 && temIssue.length > 0) {
            [textArray addObject:temIssue];
        }
    }
    NSLock *aLock = [[NSLock alloc] init];
    [aLock lock];
    //计算总高度
    float totalHeight = 0;
    for (NSString *text in textArray) {
        if ([text containsString:@"「"] || [text containsString:@"」"]) {  //图片部分
            //去掉两边符号
            NSString *resultStr = [text mutableCopy];
            resultStr = [resultStr substringFromIndex:1];
            resultStr = [resultStr substringToIndex:resultStr.length - 1];
            //先拼接图片URL
            NSString *urlStr = @"";
            if ([resultStr containsString:@"jpg"] || [resultStr containsString:@"png"] || [resultStr containsString:@"bmp"] || [resultStr containsString:@"gif"]) {
                urlStr = [NSString stringWithFormat:@"%@/%@/%ld/%ld/%@",QuestionImgHOSTURL,[USER_DEFAULTS objectForKey:EIID],(long)self.questionModel.courseId,(long)self.questionModel.sid,resultStr];
            } else {
                urlStr = [NSString stringWithFormat:@"%@/%@/%ld/%ld/%@.jpg",QuestionImgHOSTURL,[USER_DEFAULTS objectForKey:EIID],(long)self.questionModel.courseId,(long)self.questionModel.sid,resultStr];
            }
            NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
            UIImage *temImage = [UIImage imageWithData:imgData];
            if (temImage.size.width < UI_SCREEN_WIDTH - 20*2)
            {
                totalHeight = totalHeight + temImage.size.height;
            }
            else
            {
                totalHeight = totalHeight + (UI_SCREEN_WIDTH - 20*2)*(temImage.size.height/temImage.size.width);
            }
        } else {  //文本部分
            if (text.length == 0) {
                totalHeight = totalHeight + 0;
            } else {
                totalHeight = totalHeight + [ManagerTools adaptHeightWithString:text FontSize:[USER_DEFAULTS floatForKey:QLabelFont] SizeWidth:UI_SCREEN_WIDTH - 20*2];
            }
        }
    }
    [aLock unlock];
    return totalHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)  //题干、选项
    {
        if (indexPath.row == 0)
        {
            QuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID_Question forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.questionLabel.font = FontOfSize([USER_DEFAULTS floatForKey:QLabelFont]);
            cell.questionModel = self.questionModel;
            
            return cell;
        }
        else
        {
            if ([USER_DEFAULTS integerForKey:Question_Mode] == 0 && self.questionModel.isLookAnswer == NO && indexPath.row == self.questionModel.optionList.count + 1) {
                LookAnalyseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID_LookAnalyse forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.questionModel = self.questionModel;
                
                return cell;
            } else {
                OptionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID_Option forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.optionLabel.font = FontOfSize([USER_DEFAULTS floatForKey:QLabelFont]);
                cell.uAnswer = self.questionModel.userQModel ? self.questionModel.userQModel.uAnswer:self.questionModel.qExerinfoBasicModel.uAnswer;
                cell.answer = self.questionModel.answer;
                cell.qTypeShowKey = self.questionModel.qTypeListModel.showKey;
                if (self.questionModel.qTypeListModel.showKey == 0) {
                    QuestionOptionModel *optionModel = [[QuestionOptionModel alloc] init];
                    cell.optionModel = optionModel;
                } else {
                    QuestionOptionModel *optionModel = self.questionModel.optionList[indexPath.row - 1];
                    cell.optionModel = optionModel;
                }
                
                return cell;
            }
        }
    }
    if (indexPath.section == 1)  //答案、解析、视频解析、问题反馈
    {
        if (indexPath.row == 0)
        {
            AnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID_Answer forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.questionModel = self.questionModel;
            
            return cell;
        }
        else if (indexPath.row == 1)
        {
            AnalyseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID_Analyse forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.statisticLabel.font = FontOfSize([USER_DEFAULTS floatForKey:QLabelFont]);
            cell.analyseLabel.font = FontOfSize([USER_DEFAULTS floatForKey:QLabelFont]);
            cell.questionModel = self.questionModel;
            
            return cell;
        }
        else
        {
            VideoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID_Video forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.backgroundColor = [USER_DEFAULTS boolForKey:Question_DayNight] ? Night_RGB_BGColor:[UIColor whiteColor];
            
            return cell;
        }
    }
    else  //云笔记
    {
        if (!self.questionModel.qNoteModel.content)
        {
            NoteCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID_Note forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.backgroundColor = [USER_DEFAULTS boolForKey:Question_DayNight] ? Night_RGB_BGColor:[UIColor whiteColor];
            
            return cell;
        }
        else
        {
            NoteHaveCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID_NoteHave forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.qNoteModel = self.questionModel.qNoteModel;
            cell.backgroundColor = [USER_DEFAULTS boolForKey:Question_DayNight] ? Night_RGB_BGColor:[UIColor whiteColor];
            
            return cell;
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([USER_DEFAULTS integerForKey:Question_Mode] == 2 || [USER_DEFAULTS boolForKey:Question_IsAnalyse] == YES || self.questionModel.qTypeListModel.showKey == 0) {
        return;
    }
    if ([USER_DEFAULTS integerForKey:Question_Mode] == 0 && self.questionModel.isLookAnswer == NO && indexPath.row == self.questionModel.optionList.count + 1) {
        return;
    }
    if (indexPath.section == 0 && indexPath.row > 0)  //点击选项
    {
        if (self.questionModel.userQModel)  //用户统计接口获取的数据
        {
            switch (self.questionModel.qTypeListModel.showKey) {
                case DanXuan:
                {
                    if ([self.questionModel.userQModel.uAnswer integerValue] == indexPath.row) {
                        return;
                    } else {
                        self.questionModel.userQModel.uAnswer = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"DanOrPanOptionClicked" object:self.questionModel.userQModel.uAnswer];
                    }
                }
                    break;
                case PanDuan:
                {
                    if (self.questionModel.userQModel.uAnswer.length == 0) {
                        self.questionModel.userQModel.uAnswer = [NSString stringWithFormat:@"%d",indexPath.row == 1 ? 1:0];
                    } else {
                        if ([self.questionModel.userQModel.uAnswer integerValue] == 1) {
                            if (indexPath.row == 1) {
                                return;
                            } else {
                                self.questionModel.userQModel.uAnswer = @"0";
                            }
                        } else {
                            if (indexPath.row == 2) {
                                return;
                            } else {
                                self.questionModel.userQModel.uAnswer = @"1";
                            }
                        }
                    }
                    
                    if (self.questionModel.userQModel.uAnswer.length > 0) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"DanOrPanOptionClicked" object:self.questionModel.userQModel.uAnswer];
                    }
                }
                    break;
                case DuoXuan:
                {
                    NSString *optionStr = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
                    if (self.questionModel.userQModel.uAnswer.length == 0)  //未勾选
                    {
                        self.questionModel.userQModel.uAnswer = optionStr;
                    }
                    else  //已勾选
                    {
                        NSMutableArray *optionArray = [NSMutableArray arrayWithArray:[self.questionModel.userQModel.uAnswer componentsSeparatedByString:@"|"]];
                        //添加或删除 选项
                        if ([optionArray containsObject:optionStr]) {
                            [optionArray removeObject:optionStr];
                        } else {
                            [optionArray addObject:optionStr];
                        }
                        //改变选项
                        if (optionArray.count == 0) {
                            self.questionModel.userQModel.uAnswer = @"";
                        } else {
                            //选项排序
                            NSMutableArray *newArray = [[NSMutableArray alloc] initWithArray:[optionArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                                return [obj1 compare:obj2 options:NSForcedOrderingSearch];
                            }]];
                            //拼接成正确格式
                            NSString *newAnswer = @"";
                            for (NSString *temStr in newArray) {
                                newAnswer = [newAnswer stringByAppendingFormat:@"%@|",temStr];
                            }
                            newAnswer = [newAnswer substringToIndex:newAnswer.length - 1];
                            self.questionModel.userQModel.uAnswer = newAnswer;
                        }
                    }
                }
                    break;
                    
                default:
                    break;
            }
            if (self.questionModel.qTypeListModel.showKey == DuoXuan) {
                [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationNone];
            } else {
                [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
            }
            if ([USER_DEFAULTS integerForKey:Question_Mode] == 2) {
                [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
            }
            //计算是否正确
            if ([self.questionModel.userQModel.uAnswer isEqualToString:self.questionModel.answer]) {
                self.questionModel.qExerinfoBasicModel.isRight = 1;
            } else if (self.questionModel.qTypeListModel.showKey == 0 || self.questionModel.userQModel.uAnswer.length == 0) {
                self.questionModel.qExerinfoBasicModel.isRight = 0;
            } else {
                self.questionModel.qExerinfoBasicModel.isRight = 2;
            }
            //修改为已做过
            self.questionModel.isWrite = YES;
            //发送通知--保存答案
            [[NSNotificationCenter defaultCenter] postNotificationName:@"QuestionUpUserAnswer" object:self.questionModel];
        }
        else
        {
            switch (self.questionModel.qTypeListModel.showKey) {
                case DanXuan:
                {
                    if ([self.questionModel.qExerinfoBasicModel.uAnswer integerValue] == indexPath.row) {
                        return;
                    } else {
                        self.questionModel.qExerinfoBasicModel.uAnswer = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"DanOrPanOptionClicked" object:self.questionModel.qExerinfoBasicModel.uAnswer];
                    }
                }
                    break;
                case PanDuan:
                {
                    if (self.questionModel.qExerinfoBasicModel.uAnswer.length == 0) {
                        self.questionModel.qExerinfoBasicModel.uAnswer = [NSString stringWithFormat:@"%d",indexPath.row == 1 ? 1:0];
                    } else {
                        if ([self.questionModel.qExerinfoBasicModel.uAnswer integerValue] == 1) {
                            if (indexPath.row == 1) {
                                return;
                            } else {
                                self.questionModel.qExerinfoBasicModel.uAnswer = @"0";
                            }
                        } else {
                            if (indexPath.row == 2) {
                                return;
                            } else {
                                self.questionModel.qExerinfoBasicModel.uAnswer = @"1";
                            }
                        }
                    }
                    
                    if (self.questionModel.qExerinfoBasicModel.uAnswer.length > 0) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"DanOrPanOptionClicked" object:self.questionModel.qExerinfoBasicModel.uAnswer];
                    }
                }
                    break;
                case DuoXuan:
                {
                    NSString *optionStr = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
                    if (self.questionModel.qExerinfoBasicModel.uAnswer.length == 0)  //未勾选
                    {
                        self.questionModel.qExerinfoBasicModel.uAnswer = optionStr;
                    }
                    else  //已勾选
                    {
                        NSMutableArray *optionArray = [NSMutableArray arrayWithArray:[self.questionModel.qExerinfoBasicModel.uAnswer componentsSeparatedByString:@"|"]];
                        //添加或删除 选项
                        if ([optionArray containsObject:optionStr]) {
                            [optionArray removeObject:optionStr];
                        } else {
                            [optionArray addObject:optionStr];
                        }
                        //改变选项
                        if (optionArray.count == 0) {
                            self.questionModel.qExerinfoBasicModel.uAnswer = @"";
                        } else {
                            //选项排序
                            NSMutableArray *newArray = [[NSMutableArray alloc] initWithArray:[optionArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                                return [obj1 compare:obj2 options:NSForcedOrderingSearch];
                            }]];
                            //拼接成正确格式
                            NSString *newAnswer = @"";
                            for (NSString *temStr in newArray) {
                                newAnswer = [newAnswer stringByAppendingFormat:@"%@|",temStr];
                            }
                            newAnswer = [newAnswer substringToIndex:newAnswer.length - 1];
                            self.questionModel.qExerinfoBasicModel.uAnswer = newAnswer;
                        }
                    }
                }
                    break;
                    
                default:
                    break;
            }
            if (self.questionModel.qTypeListModel.showKey == DuoXuan) {
                [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationNone];
            } else {
                [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
            }
            if ([USER_DEFAULTS integerForKey:Question_Mode] == 2) {
                [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
            }
            //计算是否正确
            if ([self.questionModel.qExerinfoBasicModel.uAnswer isEqualToString:self.questionModel.answer]) {
                self.questionModel.qExerinfoBasicModel.isRight = 1;
            } else if (self.questionModel.qTypeListModel.showKey == 0 || self.questionModel.qExerinfoBasicModel.uAnswer.length == 0) {
                self.questionModel.qExerinfoBasicModel.isRight = 0;
            } else {
                self.questionModel.qExerinfoBasicModel.isRight = 2;
            }
            //修改为已做过
            self.questionModel.isWrite = YES;
            //发送通知--保存答案
            [[NSNotificationCenter defaultCenter] postNotificationName:@"QuestionUpUserAnswer" object:self.questionModel];
        }
    }
}

@end
