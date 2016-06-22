//
//  DetailSearchTableViewCell.h
//  eNavi
//
//  Created by zuotoujing on 16/5/4.
//  Copyright © 2016年 csc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackView.h"
@interface DetailSearchTableViewCell : UITableViewCell
@property (nonatomic, weak) BackView *backView;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
