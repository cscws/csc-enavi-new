//
//  moreTableViewCell.h
//  eNavi
//
//  Created by zuotoujing on 16/3/8.
//  Copyright © 2016年 csc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KCItemModel;
@interface moreTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong)KCItemModel *model;
@end
