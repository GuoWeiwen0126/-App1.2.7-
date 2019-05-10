//
//  MKOptionCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2019/3/19.
//  Copyright © 2019年 ZongTongEdu. All rights reserved.
//

#import "MKOptionCell.h"
#import "Tools.h"
#import "QuestionModel.h"

@interface MKOptionCell ()
{
    NSString *_temAnswer;
    NSArray *_danImgArray;
    NSArray *_danImgSelectedArray;
    NSArray *_duoImgArray;
    NSArray *_duoImgSelectedArray;
    NSArray *_panImgArray;
    NSArray *_panImgSelectedArray;
}
@end
@implementation MKOptionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _danImgArray = @[@"", @"a.png", @"b.png", @"c.png", @"d.png", @"e.png", @"f.png", @"g.png", @"h.png", @"i.png", @"j.png", @"k.png", @"l.png", @"m.png", @"n.png"];
    _danImgSelectedArray = @[@"", @"a1.png", @"b1.png", @"c1.png", @"d1.png", @"e1.png", @"f1.png", @"g1.png", @"h1.png", @"i1.png", @"j1.png", @"k1.png", @"l1.png", @"m1.png", @"n1.png"];
    _duoImgArray = @[@"", @"aduo.png", @"bduo.png", @"cduo.png", @"dduo.png", @"eduo.png", @"fduo.png", @"gduo.png", @"hduo.png", @"iduo.png", @"jduo.png", @"kduo.png", @"lduo.png", @"mduo.png", @"nduo.png"];
    _duoImgSelectedArray = @[@"", @"a1duo.png", @"b1duo.png", @"c1duo.png", @"d1duo.png", @"e1duo.png", @"f1duo.png", @"g1duo.png", @"h1duo.png", @"i1duo.png", @"j1duo.png", @"k1duo.png", @"l1duo.png", @"m1duo.png", @"n1duo.png"];
    _panImgArray = @[@"", @"a.png", @"b.png"];
    _panImgSelectedArray = @[@"",@"a1.png", @"b1.png"];
}
#pragma mark - setter方法
- (void)setOptionModel:(QuestionOptionModel *)optionModel
{
    if (_optionModel != optionModel)
    {
        _optionModel = optionModel;
    }
    
    self.backgroundColor = [USER_DEFAULTS boolForKey:Question_DayNight] ? Night_RGB_BGColor:[UIColor whiteColor];
    
    if (self.qTypeShowKey == 0) {
        self.optionLabel.hidden = YES;
        self.optionImgView.hidden = YES;
        self.detailLabel.hidden = NO;
        self.textView.hidden = NO;
        return;
    } else {
        self.optionLabel.text = [ManagerTools deleteSpaceAndNewLineWithString:optionModel.option];
        self.optionLabel.hidden = NO;
        self.optionImgView.hidden = NO;
        self.detailLabel.hidden = YES;
        self.textView.hidden = YES;
    }
    
    _temAnswer = ([USER_DEFAULTS boolForKey:Question_IsAnalyse] == YES) ? self.answer:self.uAnswer;
    
    switch (self.qTypeShowKey)
    {
        case DanXuanOption:
        {
            if ([_temAnswer integerValue] == optionModel.value) {
                self.optionImgView.image = [UIImage imageNamed:_danImgSelectedArray[optionModel.value]];
            } else {
                self.optionImgView.image = [UIImage imageNamed:_danImgArray[optionModel.value]];
            }
        }
            break;
        case PanDuanOption:
        {
            if (_temAnswer.length == 0) {
                if (optionModel.value == 1) {
                    self.optionImgView.image = [UIImage imageNamed:@"a.png"];
                } else {
                    self.optionImgView.image = [UIImage imageNamed:@"b.png"];
                }
            } else {
                if ([_temAnswer integerValue] == 1) {
                    if (optionModel.value == 1) {
                        self.optionImgView.image = [UIImage imageNamed:@"a1.png"];
                    } else {
                        self.optionImgView.image = [UIImage imageNamed:@"b.png"];
                    }
                } else {
                    if (optionModel.value == 2) {
                        self.optionImgView.image = [UIImage imageNamed:@"b1.png"];
                    } else {
                        self.optionImgView.image = [UIImage imageNamed:@"a.png"];
                    }
                }
            }
        }
            break;
        case DuoXuanOption:
        {
            if ([_temAnswer containsString:[NSString stringWithFormat:@"%ld",(long)optionModel.value]]) {
                self.optionImgView.image = [UIImage imageNamed:_duoImgSelectedArray[optionModel.value]];
            } else {
                self.optionImgView.image = [UIImage imageNamed:_duoImgArray[optionModel.value]];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
