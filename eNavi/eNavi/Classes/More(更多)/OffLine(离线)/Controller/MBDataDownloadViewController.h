//
//  MBDataDownloadViewController.h
//  iOSSDKDemo
//
//  Created by zhouxg on 15/6/18.
//  Copyright (c) 2015年 zhouxg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iNaviCore/MBOfflineDataManager.h>

@interface MBDataDownloadViewController : UITableViewController <MBOfflineDataDelegate>
/**
 *  下载
 */
- (IBAction)downFile:(id)sender;
/**
 *  暂停
 */
- (IBAction)pause:(id)sender;
/**
 *  停止
 */
- (IBAction)stop:(id)sender;
/**
 *  数据字典
 */
@property(nonatomic,retain)NSArray* dataArray;
@end
