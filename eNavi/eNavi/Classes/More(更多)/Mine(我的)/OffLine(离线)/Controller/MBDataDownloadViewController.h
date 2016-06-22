//
//  DetailSearchTableViewCell.h
//  eNavi
//
//  Created by zuotoujing on 16/5/4.
//  Copyright © 2016年 csc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iNaviCore/MBOfflineDataManager.h>

@interface MBDataDownloadViewController : UIViewController <MBOfflineDataDelegate>

/**
 *  数据字典
 */
@property (nonatomic, retain) NSArray *dataArray;
@property (nonatomic, copy) NSString *titleName;
@end
