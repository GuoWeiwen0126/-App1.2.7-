//
//  QuestionCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/8.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "QuestionCell.h"
#import "Tools.h"
#import "QuestionModel.h"

@implementation QuestionCell

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
    
    self.questionLabel.text = @"";
    NSString *questionStr = @"";
    if (questionModel.stem.length == 0) {
        questionStr = questionModel.issue;
    } else {
        questionStr = [NSString stringWithFormat:@"%@\n\n%@",questionModel.stem,questionModel.issue];
    }
    [self.questionLabel.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (questionModel.stemTail.length == 0) {
        if ([questionModel.issue containsString:@"<sub>"] || [questionModel.issue containsString:@"</sub>"] || [questionModel.issue containsString:@"<sup>"] || [questionModel.issue containsString:@"</sup>"]) {
            if ([questionStr containsString:@"「"] || [questionStr containsString:@"」"]) {  //包含图片
                [self qIssueImgWithQModel:questionModel questionStr:questionStr];
            } else {
                self.questionLabel.attributedText = [[NSAttributedString alloc] initWithData:[questionStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
            }
        } else {
            if ([questionStr containsString:@"「"] || [questionStr containsString:@"」"]) {  //包含图片
                [self qIssueImgWithQModel:questionModel questionStr:questionStr];
            } else {
                self.questionLabel.text = questionStr;
            }
        }
    } else {
        if ([questionStr containsString:@"「"] || [questionStr containsString:@"」"]) {  //包含图片
            [self qIssueImgWithQModel:questionModel questionStr:questionStr];
        } else {
            self.questionLabel.attributedText = [ManagerTools getMutableAttributedStringWithContent:[NSString stringWithFormat:@"%@  （%@）",questionStr,questionModel.stemTail] rangeStr:[NSString stringWithFormat:@"（%@）",questionModel.stemTail] color:MAIN_RGB_TEXT font:[USER_DEFAULTS floatForKey:QLabelFont] - 2];
        }
    }
}
#pragma mark - 题干图片处理
- (void)qIssueImgWithQModel:(QuestionModel *)qModel questionStr:(NSString *)qStr
{
    NSArray *imgArray = [qStr queryNameWithQIssueStr:[qStr mutableCopy] fromStr:@"「" toStr:@"」"];
    NSMutableArray *textArray = [NSMutableArray arrayWithCapacity:10];
    NSString *questionStr = [NSString stringWithString:qStr];
    //遍历拼接题干
    for (int i = 0; i < imgArray.count; i ++) {
        NSArray *temArray = [questionStr componentsSeparatedByString:imgArray[i]];
        [textArray addObject:temArray.firstObject];
        [textArray addObject:imgArray[i]];
        //删除已经拼接过的题干
        questionStr = [questionStr stringByReplacingCharactersInRange:NSMakeRange(0, [NSString stringWithFormat:@"%@",temArray.firstObject].length) withString:@""];
        questionStr = [questionStr stringByReplacingCharactersInRange:NSMakeRange(0, [NSString stringWithString:imgArray[i]].length) withString:@""];
        if (i == imgArray.count - 1 && questionStr.length > 0) {
            [textArray addObject:questionStr];
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
                urlStr = [NSString stringWithFormat:@"%@/%@/%ld/%ld/%@",QuestionImgHOSTURL,[USER_DEFAULTS objectForKey:EIID],(long)qModel.courseId,(long)qModel.sid,resultStr];
            } else {
                urlStr = [NSString stringWithFormat:@"%@/%@/%ld/%ld/%@.jpg",QuestionImgHOSTURL,[USER_DEFAULTS objectForKey:EIID],(long)qModel.courseId,(long)qModel.sid,resultStr];
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
            [self.questionLabel addSubview:temImgView];
            totalHeight = totalHeight + temImgView.height;
        } else {  //文本部分
            if (text.length != 0) {
                float labelHeight = [ManagerTools adaptHeightWithString:text FontSize:[USER_DEFAULTS floatForKey:QLabelFont] SizeWidth:UI_SCREEN_WIDTH - 20*2];
                UILabel *temLabel = [[UILabel alloc] init];
                temLabel.frame = CGRectMake(0, totalHeight, self.questionLabel.width, labelHeight);
                temLabel.text = text;
                temLabel.textColor = MAIN_RGB_MainTEXT;
                temLabel.font = FontOfSize([USER_DEFAULTS floatForKey:QLabelFont]);
                temLabel.numberOfLines = 0;
                [self.questionLabel addSubview:temLabel];
                totalHeight = totalHeight + labelHeight;
            }
        }
    }
    [self.questionLabel sizeToFit];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
