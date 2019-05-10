//
//  StudyCollectionViewCell.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/29.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "StudyCollectionViewCell.h"
#import "Tools.h"
#import "HomeModel.h"

@implementation StudyCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.imgViewLeading.constant = SCREEN_FIT_WITH(20, 20, 24, 20, 50);
    self.imgViewTrailing.constant = SCREEN_FIT_WITH(20, 20, 24, 20, 50);
    self.imgViewTop.constant = SCREEN_FIT_WITH(20*0.75, 20*0.75, 24*0.75, 20*0.75, 50*0.75);
    self.titleLabel.font = FontOfSize(SCREEN_FIT_WITH(12, 13, 14, 13, 20));
}
#pragma mark - setter方法
- (void)setModuleModel:(HomeModuleModel *)moduleModel
{
    if (_moduleModel != moduleModel)
    {
        _moduleModel = moduleModel;
    }
    if ([USER_DEFAULTS objectForKey:BufferIcover]) {
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:moduleModel.imgUrl] placeholderImage:nil options:SDWebImageRefreshCached];
    } else {
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:moduleModel.imgUrl]];
    }
    self.titleLabel.text = moduleModel.title;
    
    if (moduleModel.mark > 1) {
        self.markImgView.hidden = NO;
        [self.markImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://videoimg.zongtongedu.com/icon/mark/%ld.png",(long)moduleModel.mark]]];
    } else {
        self.markImgView.hidden = YES;
    }
}


@end
