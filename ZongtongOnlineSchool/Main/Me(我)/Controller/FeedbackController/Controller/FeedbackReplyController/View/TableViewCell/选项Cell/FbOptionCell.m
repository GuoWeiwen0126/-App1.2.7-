//
//  FbOptionCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2018/1/5.
//  Copyright © 2018年 ZongTongEdu. All rights reserved.
//

#import "FbOptionCell.h"
#import "Tools.h"
#import "QuestionModel.h"

typedef NS_ENUM(NSInteger, CellShowKey)
{
    DanXuanOption = 1,
    DuoXuanOption = 2,
    PanDuanOption = 3,
};
@interface FbOptionCell ()
{
    NSString *temAnswer;
    NSArray *_danImgArray;
    NSArray *_danImgSelectedArray;
    NSArray *_duoImgArray;
    NSArray *_duoImgSelectedArray;
    NSArray *_panImgArray;
    NSArray *_panImgSelectedArray;
}
@end

@implementation FbOptionCell

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
    
    self.optionLabel.text = [ManagerTools deleteSpaceAndNewLineWithString:optionModel.option];
    switch (self.qTypeShowKey)
    {
        case DanXuanOption:
            {
                if ([self.answer integerValue] == optionModel.value) {
                    self.imgView.image = [UIImage imageNamed:_danImgSelectedArray[optionModel.value]];
                } else {
                    self.imgView.image = [UIImage imageNamed:_danImgArray[optionModel.value]];
                }
            }
            break;
        case PanDuanOption:
        {
            if (self.answer.length == 0) {
                if (optionModel.value == 1) {
                    self.imgView.image = [UIImage imageNamed:@"a.png"];
                } else {
                    self.imgView.image = [UIImage imageNamed:@"b.png"];
                }
            } else {
                if ([self.answer integerValue] == 1) {
                    if (optionModel.value == 1) {
                        self.imgView.image = [UIImage imageNamed:@"a1.png"];
                    } else {
                        self.imgView.image = [UIImage imageNamed:@"b.png"];
                    }
                } else {
                    if (optionModel.value == 2) {
                        self.imgView.image = [UIImage imageNamed:@"b1.png"];
                    } else {
                        self.imgView.image = [UIImage imageNamed:@"a.png"];
                    }
                }
            }
        }
            break;
        case DuoXuanOption:
        {
            if ([self.answer containsString:[NSString stringWithFormat:@"%ld",(long)optionModel.value]]) {
                self.imgView.image = [UIImage imageNamed:_duoImgSelectedArray[optionModel.value]];
            } else {
                self.imgView.image = [UIImage imageNamed:_duoImgArray[optionModel.value]];
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
