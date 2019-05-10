//
//  MKAnalyseCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2019/3/19.
//  Copyright © 2019年 ZongTongEdu. All rights reserved.
//

#import "MKAnalyseCell.h"
#import "Tools.h"
#import "QuestionModel.h"

@implementation MKAnalyseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setQuestionModel:(QuestionModel *)questionModel
{
    if (_questionModel != questionModel)
    {
        _questionModel = questionModel;
    }
    
    self.backgroundColor = [USER_DEFAULTS boolForKey:Question_DayNight] ? Night_RGB_BGColor:[UIColor whiteColor];
    
    self.analyseLabel.text = @"";
    for(UIView *temView in [self.analyseLabel subviews])
    {
        [temView removeFromSuperview];
    }
    
    if ([questionModel.analysis containsString:@"「"] || [questionModel.analysis containsString:@"」"]) {  //包含图片
        [self qAnalysisImgWithQModel:questionModel];
    } else {
        self.analyseLabel.text = questionModel.analysis;
    }
}
#pragma mark - 解析图片处理
- (void)qAnalysisImgWithQModel:(QuestionModel *)qModel
{
    NSArray *imgArray = [qModel.analysis queryNameWithQIssueStr:[qModel.analysis mutableCopy] fromStr:@"「" toStr:@"」"];
    NSMutableArray *textArray = [NSMutableArray arrayWithCapacity:10];
    NSString *temAnalysis = [NSString stringWithString:qModel.analysis];
    //遍历拼接题干
    for (int i = 0; i < imgArray.count; i ++) {
        NSArray *temArray = [temAnalysis componentsSeparatedByString:imgArray[i]];
        [textArray addObject:temArray.firstObject];
        [textArray addObject:imgArray[i]];
        //删除已经拼接过的题干
        temAnalysis = [temAnalysis stringByReplacingCharactersInRange:NSMakeRange(0, [NSString stringWithFormat:@"%@",temArray.firstObject].length) withString:@""];
        temAnalysis = [temAnalysis stringByReplacingCharactersInRange:NSMakeRange(0, [NSString stringWithString:imgArray[i]].length) withString:@""];
        if (i == imgArray.count - 1 && temAnalysis.length > 0) {
            [textArray addObject:temAnalysis];
        }
    }
    //UI布局
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
                urlStr = [NSString stringWithFormat:@"%@/%@/%@/%ld/%@",QuestionImgHOSTURL,[USER_DEFAULTS objectForKey:EIID],[USER_DEFAULTS objectForKey:COURSEID],(long)qModel.sid,resultStr];
            } else {
                urlStr = [NSString stringWithFormat:@"%@/%@/%@/%ld/%@.jpg",QuestionImgHOSTURL,[USER_DEFAULTS objectForKey:EIID],[USER_DEFAULTS objectForKey:COURSEID],(long)qModel.sid,resultStr];
            }
            NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
            UIImage *temImage = [UIImage imageWithData:imgData];
            UIImageView *temImgView = [[UIImageView alloc] init];
            temImgView.image = temImage;
            if (temImage.size.width < UI_SCREEN_WIDTH - 20*2)
            {
                temImgView.frame = CGRectMake(UI_SCREEN_WIDTH/2 - temImage.size.width/2, totalHeight, temImage.size.width, temImage.size.height);
            }
            else
            {
                temImgView.frame = CGRectMake(0, totalHeight, UI_SCREEN_WIDTH - 20*2, (UI_SCREEN_WIDTH - 20*2)*(temImage.size.height/temImage.size.width));
            }
            [self.analyseLabel addSubview:temImgView];
            totalHeight = totalHeight + temImgView.height;
        } else {  //文本部分
            if (text.length != 0) {
                float labelHeight = [ManagerTools adaptHeightWithString:text FontSize:[USER_DEFAULTS floatForKey:QLabelFont] SizeWidth:UI_SCREEN_WIDTH - 20*2];
                UILabel *temLabel = [[UILabel alloc] init];
                temLabel.frame = CGRectMake(0, totalHeight, self.analyseLabel.width, labelHeight);
                temLabel.text = text;
                temLabel.textColor = MAIN_RGB_MainTEXT;
                temLabel.font = FontOfSize([USER_DEFAULTS floatForKey:QLabelFont]);
                temLabel.numberOfLines = 0;
                [self.analyseLabel addSubview:temLabel];
                totalHeight = totalHeight + labelHeight;
            }
        }
    }
    [self.analyseLabel sizeToFit];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
