//
//  HistoryTableViewCell.h
//  eNavi
//
//  Created by zuotoujing on 16/3/30.
//  Copyright © 2016年 csc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class historyModel;
@interface HistoryTableViewCell : UITableViewCell
@property (nonatomic ,strong) historyModel *model;
@end
