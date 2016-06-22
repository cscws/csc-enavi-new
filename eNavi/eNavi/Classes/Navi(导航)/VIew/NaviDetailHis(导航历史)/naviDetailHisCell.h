//
//  naviDetailHisCell.h
//  eNavi
//
//  Created by zuotoujing on 16/5/6.
//  Copyright © 2016年 csc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NaviDetailHisModel;
@interface naviDetailHisCell : UITableViewCell
@property (nonatomic, strong)NaviDetailHisModel *model;
- (void)btnOnCellClicked:(void(^)(NaviDetailHisModel *model))block;
+ (instancetype)cellWithTableview:(UITableView *)tableview;
@end
