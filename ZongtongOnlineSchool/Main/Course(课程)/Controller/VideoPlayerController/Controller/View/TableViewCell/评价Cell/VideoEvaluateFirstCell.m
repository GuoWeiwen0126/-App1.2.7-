//
//  VideoEvaluateFirstCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/29.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "VideoEvaluateFirstCell.h"
#import "Tools.h"
#import "VideoDetailModel.h"

@interface VideoEvaluateFirstCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *totalGrade;
@property (weak, nonatomic) IBOutlet UIView *bgTotalStarView;
@property (weak, nonatomic) IBOutlet UIView *bgZyStarView;
@property (weak, nonatomic) IBOutlet UIView *bgKtStarView;
@property (weak, nonatomic) IBOutlet UIView *bgZlStarView;
@property (weak, nonatomic) IBOutlet UILabel *zyGrade;
@property (weak, nonatomic) IBOutlet UILabel *ktGrade;
@property (weak, nonatomic) IBOutlet UILabel *zlGrade;

@property (nonatomic, strong) ZTStarView *totalStarView;
@property (nonatomic, strong) ZTStarView *zyStarView;
@property (nonatomic, strong) ZTStarView *ktStarView;
@property (nonatomic, strong) ZTStarView *zlStarView;

@end

@implementation VideoEvaluateFirstCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.totalStarView = [[ZTStarView alloc] initWithFrame:self.bgTotalStarView.bounds isEnable:NO];
    [self.bgTotalStarView addSubview:self.totalStarView];
    self.zyStarView = [[ZTStarView alloc] initWithFrame:self.bgZyStarView.bounds isEnable:NO];
    [self.bgZyStarView addSubview:self.zyStarView];
    self.ktStarView = [[ZTStarView alloc] initWithFrame:self.bgKtStarView.bounds isEnable:NO];
    [self.bgKtStarView addSubview:self.ktStarView];
    self.zlStarView = [[ZTStarView alloc] initWithFrame:self.bgZlStarView.bounds isEnable:NO];
    [self.bgZlStarView addSubview:self.zlStarView];
}
- (void)setVDetailModel:(VideoDetailModel *)vDetailModel
{
    if (_vDetailModel != vDetailModel)
    {
        _vDetailModel = vDetailModel;
    }
    self.totalStarView.grade = vDetailModel.grade;
    self.totalGrade.text = [NSString stringWithFormat:@"%ld分",(long)vDetailModel.grade];
    /*
     *  专业能力 = 1,  课堂风采 = 2,  资料提供 = 3
     */
    NSLog(@"%@",vDetailModel.item);
    for (NSString *keyStr in [vDetailModel.item allKeys]) {
        if ([keyStr integerValue] == 1) {
            self.zyStarView.grade = [[vDetailModel.item objectForKey:keyStr] integerValue];
            self.zyGrade.text = [self changeGradeLabelWithGrade:self.zyStarView.grade];
        } else if ([keyStr integerValue] == 2) {
            self.ktStarView.grade = [[vDetailModel.item objectForKey:keyStr] integerValue];
            self.ktGrade.text = [self changeGradeLabelWithGrade:self.ktStarView.grade];
        } else {
            self.zlStarView.grade = [[vDetailModel.item objectForKey:keyStr] integerValue];
            self.zlGrade.text = [self changeGradeLabelWithGrade:self.zlStarView.grade];
        }
    }
}
#pragma mark - 修改得分Label
- (NSString *)changeGradeLabelWithGrade:(NSInteger)grade
{
    if (SCREEN_IS_3_5 || SCREEN_IS_4_0) {
        return [NSString stringWithFormat:@"%ld分",(long)grade];
    } else if (SCREEN_IS_4_7) {
        return [NSString stringWithFormat:@"%ld.0  分",(long)grade];
    } else {
        return [NSString stringWithFormat:@"  %ld.0  分",(long)grade];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
