//
//  searchTableViewCell.h
//  eNavi
//
//  Created by zuotoujing on 16/3/10.
//  Copyright © 2016年 csc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailView.h"
@interface searchTableViewCell : UITableViewCell
@property (nonatomic, weak)DetailView *bgView;
+(instancetype)cellWithTableView:(UITableView *)tableView andStr:(NSString *)str;
@end
