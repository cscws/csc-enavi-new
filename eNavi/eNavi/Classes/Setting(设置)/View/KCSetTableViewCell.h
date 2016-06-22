//
//  KCSetTableViewCell.h
//  eNavi
//
//  Created by zuotoujing on 16/6/14.
//  Copyright © 2016年 csc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KCSetModel;
@interface KCSetTableViewCell : UITableViewCell

@property (nonatomic, strong)KCSetModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
