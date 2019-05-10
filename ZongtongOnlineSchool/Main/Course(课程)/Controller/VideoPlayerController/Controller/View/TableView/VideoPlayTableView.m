//
//  VideoPlayTableView.m
//  ZongtongOnlineSchool
//
//  Created by GuoWeiwen on 2017/12/28.
//  Copyright © 2017年 ZongTongEdu. All rights reserved.
//

#import "VideoPlayTableView.h"
#import "Tools.h"
#import "VideoSectionModel.h"
#import "VideoCourseCell.h"
#import "VideoHandoutCell.h"
#import "VideoNoEvaluateCell.h"
#import "VideoEvaluateFirstCell.h"
#import "VideoEvaluateCell.h"
#import "VideoDetailModel.h"

@interface VideoPlayTableView () <UITableViewDelegate, UITableViewDataSource>

@end
static NSString *cellID_Course        = @"cellID_Course";
static NSString *cellID_Handout       = @"cellID_Handout";
static NSString *cellID_NoEvaluate    = @"cellID_NoEvaluate";
static NSString *cellID_EvaluateFirst = @"cellID_EvaluateFirst";
static NSString *cellID_Evaluate      = @"cellID_Evaluate";
@implementation VideoPlayTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:@"VideoCourseCell" bundle:nil] forCellReuseIdentifier:cellID_Course];
        [self registerNib:[UINib nibWithNibName:@"VideoHandoutCell" bundle:nil] forCellReuseIdentifier:cellID_Handout];
        [self registerNib:[UINib nibWithNibName:@"VideoNoEvaluateCell" bundle:nil] forCellReuseIdentifier:cellID_NoEvaluate];
        [self registerNib:[UINib nibWithNibName:@"VideoEvaluateFirstCell" bundle:nil] forCellReuseIdentifier:cellID_EvaluateFirst];
        [self registerNib:[UINib nibWithNibName:@"VideoEvaluateCell" bundle:nil] forCellReuseIdentifier:cellID_Evaluate];
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return self;
}
#pragma mark - tableView协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.tableViewType == VideoCourseType) {
        return self.videoSecDataArray.count;
    } else if (self.tableViewType == VideoHandoutType) {
        return 1;
    } else {
        if (self.evaluateArray.count == 0) {
            return 1;
        } else {
            if (self.isQVideoType) {
                return self.evaluateArray.count;
            } else {
                return self.evaluateArray.count + 1;
            }
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableViewType == VideoCourseType) {
        return 70.0f;
    } else if (self.tableViewType == VideoHandoutType) {
        return self.height;
    } else {
        if (self.evaluateArray.count == 0) {
            return 80.0f;
        } else {
            if (self.isQVideoType) {
                VideoEvaluateModel *model = self.evaluateArray[indexPath.row];
                return [ManagerTools adaptHeightWithString:model.content FontSize:14.0 SizeWidth:UI_SCREEN_WIDTH - 80] + 70;
            } else {
                if (indexPath.row == 0) {
                    return 100.0f;
                }
                VideoEvaluateModel *model = self.evaluateArray[indexPath.row - 1];
                return [ManagerTools adaptHeightWithString:model.content FontSize:14.0 SizeWidth:UI_SCREEN_WIDTH - 80] + 70;
            }
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableViewType == VideoCourseType) {
        VideoCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID_Course forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.vSectionModel = self.videoSecDataArray[indexPath.row];
        
        return cell;
    } else if (self.tableViewType == VideoHandoutType) {
        VideoHandoutCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID_Handout forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.vhid = [NSString stringWithFormat:@"%ld",(long)self.vDetailModel.vhid];
        
        return cell;
    } else {
        if (self.evaluateArray.count == 0) {
            VideoNoEvaluateCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID_NoEvaluate forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        } else {
            if (self.isQVideoType == YES) {
                VideoEvaluateCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID_Evaluate forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.isQVideoType = self.isQVideoType;
                cell.vEvaluateModel = self.evaluateArray[indexPath.row];
                
                return cell;
            } else {
                if (indexPath.row == 0) {
                    VideoEvaluateFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID_EvaluateFirst forIndexPath:indexPath];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    cell.vDetailModel = self.vDetailModel;
                    
                    return cell;
                } else {
                    VideoEvaluateCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID_Evaluate forIndexPath:indexPath];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    cell.isQVideoType = self.isQVideoType;
                    cell.vEvaluateModel = self.evaluateArray[indexPath.row - 1];
                    
                    return cell;
                }
            }
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableViewType == VideoCourseType) {
        VideoSectionModel *vSectionModel = self.videoSecDataArray[indexPath.row];
        [tableView beginUpdates];
        if (vSectionModel.belowCount == 0) {
            //Data
            NSArray *infoList = [vSectionModel open];
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row + 1, infoList.count)];
            [self.videoSecDataArray insertObjects:infoList atIndexes:indexSet];
            //Rows
            NSMutableArray *indexArray = [NSMutableArray arrayWithCapacity:10];
            for (int i = 0; i < infoList.count; i ++)
            {
                NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:(indexPath.row + 1 + i) inSection:indexPath.section];
                [indexArray addObject:insertIndexPath];
            }
            [tableView insertRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];
        } else {
            //Data
            NSArray *infoList = [self.videoSecDataArray subarrayWithRange:NSMakeRange(indexPath.row + 1, vSectionModel.belowCount)];
            [vSectionModel closeWithInfoList:infoList];
            [self.videoSecDataArray removeObjectsInArray:infoList];
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
        [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationNone];
    } else if (self.tableViewType == VideoHandoutType) {
        
    } else {
        
    }
    
}

@end
