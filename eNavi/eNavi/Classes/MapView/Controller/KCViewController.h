//
//  KCViewController.h
//  navimap
//
//  Created by zhouxg on 15/7/17.
//  Copyright (c) 2015年 iDIVA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KCCityListViewController.h"
#import "KCMainMapViewController.h"
#import "WXApiObject.h"
@interface KCViewController : UIViewController <KCCityListViewControllerDelegate>

/**
 *  选择导航模式的 index
 */
@property (nonatomic ,assign) NSInteger index;
@property (nonatomic ,copy)NSString *cityName;
@end
