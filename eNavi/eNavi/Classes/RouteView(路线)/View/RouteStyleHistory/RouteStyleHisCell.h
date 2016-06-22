//
//  RouteStyleHisCell.h
//  eNavi
//
//  Created by zuotoujing on 16/5/12.
//  Copyright © 2016年 csc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RouteStyleHisModel;
@interface RouteStyleHisCell : UITableViewCell
@property (nonatomic, strong) RouteStyleHisModel *model;
- (void)buttonOnCellClicked:(void(^)(RouteStyleHisModel *model))block;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
