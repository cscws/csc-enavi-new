//
//  KCSecondSearchViewController.h
//  eNavi
//
//  Created by zuotoujing on 16/4/11.
//  Copyright © 2016年 csc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iNaviCore/MBPoi.h>
#import "KCCityListViewController.h"
@interface KCSecondSearchViewController : UIViewController<KCCityListViewControllerDelegate>
@property (nonatomic, weak) UIButton *cityBtn;
@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, assign) MBPoint centerPOI;
@property (nonatomic, strong) MBWmrNode *cityNode;
@end
