//
//  StudyTableView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/11/29.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "StudyTableView.h"
#import "Tools.h"
#import "StudyFirstTableViewCell.h"
#import "StudyModuleTableViewCell.h"
#import "StudyAdverTableViewCell.h"
#import "StudyBookTableViewCell.h"
#import "StudyScheduleCell.h"
#import "StudyVideoTableViewCell.h"
#import "VideoSectionModel.h"
#import "HomeModel.h"

typedef NS_ENUM(NSUInteger, HeaderViewStatus)
{
    Course   = 0,
    Handout  = 1,
};

@interface StudyTableView () <UITableViewDelegate, UITableViewDataSource, StudyScheduleCellDelegate>
@property (nonatomic, assign) HeaderViewStatus headerViewStatus;
@end

@implementation StudyTableView

static NSString *cellID_First    = @"cellID_First";
static NSString *cellID_Module   = @"cellID_Module";
static NSString *cellID_Adver    = @"cellID_Adver";
static NSString *cellID_Book     = @"cellID_Book";
static NSString *cellID_Schedule = @"cellID_Schedule";
static NSString *cellID_Video    = @"cellID_Video";

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        self.headerViewStatus = Course;
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"StudyFirstTableViewCell" bundle:nil] forCellReuseIdentifier:cellID_First];
        [self registerNib:[UINib nibWithNibName:@"StudyModuleTableViewCell" bundle:nil] forCellReuseIdentifier:cellID_Module];
        [self registerNib:[UINib nibWithNibName:@"StudyAdverTableViewCell" bundle:nil] forCellReuseIdentifier:cellID_Adver];
        [self registerNib:[UINib nibWithNibName:@"StudyBookTableViewCell" bundle:nil] forCellReuseIdentifier:cellID_Book];
        [self registerNib:[UINib nibWithNibName:@"StudyScheduleCell" bundle:nil] forCellReuseIdentifier:cellID_Schedule];
        [self registerNib:[UINib nibWithNibName:@"StudyVideoTableViewCell" bundle:nil] forCellReuseIdentifier:cellID_Video];
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.estimatedRowHeight = 0;
        self.estimatedSectionHeaderHeight = 0;
        self.estimatedSectionFooterHeight = 0;
        self.bounces = NO;
    }
    
    return self;
}

#pragma mark - tableView协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
//    return self.videoCourseArray.count + 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {  //模块儿Cell
        return (self.moduleArray.count < 8 ? (UI_SCREEN_WIDTH/2 + 4):(UI_SCREEN_WIDTH/2 + 40 + 4)) + 25;
    } else if (indexPath.row == 1) {  //广告Cell
        if (self.adArray.count == 0) {
            return 0.0f;
        }
        return DEVICE_IS_IPAD ? 80.0f:(UI_SCREEN_WIDTH/6.67);
    } else {  //经典资料Cell
        if (self.bookArray.count <= 2) {
            return 30 + 10 + UI_SCREEN_WIDTH*0.5;
        }
        return 30 + 10*2 + UI_SCREEN_WIDTH*0.75;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)  //模块儿Cell
    {
        StudyModuleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID_Module forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.collectionView.moduleDataArray = _moduleArray;
        [cell.collectionView reloadData];
        cell.pageControl.hidden = self.moduleArray.count < 8 ? YES:NO;
        
        return cell;
    }
    else if (indexPath.row == 1)  //广告Cell
    {
        StudyAdverTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID_Adver forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.clipsToBounds = YES;
        
        if (!cell.cycleScrollView) {
            cell.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, DEVICE_IS_IPAD ? 100:(UI_SCREEN_WIDTH/6.67)) delegate:cell placeholderImage:nil];
            cell.cycleScrollView.backgroundColor = [UIColor clearColor];
            cell.cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
            cell.cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            cell.cycleScrollView.autoScrollTimeInterval = 2;
            [cell.contentView addSubview:cell.cycleScrollView];
        }
        NSMutableArray *adImgArray = [NSMutableArray arrayWithCapacity:10];
        for (AdInfoModel *adModel in self.adArray) {
            [adImgArray addObject:adModel.imgUrl];
        }
        cell.cycleScrollView.imageURLStringsGroup = adImgArray;
        cell.adArray = self.adArray;
        
        return cell;
    }
    else  //经典资料Cell
    {
        StudyBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID_Book forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.bookArray = self.bookArray;
        [cell configViewWithArray:self.bookArray];
        
        return cell;
    }
//    else if (indexPath.row == 2) {  //进度Cell
//        StudyScheduleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID_Schedule forIndexPath:indexPath];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.cellDelegate = self;
//
//        cell.videoSrTime = self.videoSrTime;
//        cell.videoVtime = self.videoVtime;
//        cell.videoPercent = self.videoPercent;
//
//        return cell;
//    }
//    else  //视频课程Cell
//    {
//        StudyVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID_Video forIndexPath:indexPath];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//
//        cell.headerStatus = self.headerViewStatus;
//        cell.vSectionModel = self.videoCourseArray[indexPath.row - 3];
//
//        return cell;
//    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > 2)
    {
        VideoSectionModel *vSectionModel = self.videoCourseArray[indexPath.row - 3];
        NSLog(@"~~~%ld",(long)indexPath.row);
        [tableView beginUpdates];
        if (vSectionModel.belowCount == 0)
        {
            //Data
            NSArray *infoList = [vSectionModel open];
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row-3 + 1, infoList.count)];
            [self.videoCourseArray insertObjects:infoList atIndexes:indexSet];
            //Rows
            NSMutableArray *indexArray = [NSMutableArray arrayWithCapacity:10];
            for (int i = 0; i < infoList.count; i ++)
            {
                NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:(indexPath.row + 1 + i) inSection:indexPath.section];
                [indexArray addObject:insertIndexPath];
            }
            [tableView insertRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];
        }
        else
        {
            //Data
            NSArray *infoList = [self.videoCourseArray subarrayWithRange:NSMakeRange(indexPath.row-3 + 1, vSectionModel.belowCount)];
            [vSectionModel closeWithInfoList:infoList];
            [self.videoCourseArray removeObjectsInArray:infoList];
            //Rows
            NSMutableArray *indexArray = [NSMutableArray arrayWithCapacity:10];
            for (int i = 0; i < infoList.count; i ++)
            {
                NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:(indexPath.row + 1 + i) inSection:indexPath.section];
                [indexArray addObject:insertIndexPath];
            }
            [tableView deleteRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];
        }
        [tableView endUpdates];
        [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - StudyScheduleCellDelegate代理方法
- (void)segmentValueCHnagedWithSegIndex:(NSInteger)segIndex
{
    if (self.headerViewStatus == segIndex) {
        return;
    }
    self.headerViewStatus = segIndex;
    [self reloadData];
}

@end
