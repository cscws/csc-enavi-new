//
//  KCDriveDetailViewController.h
//  eNavi
//
//  Created by zuotoujing on 16/4/1.
//  Copyright © 2016年 csc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iNaviCore/MBRouteBase.h>
#import <iNaviCore/MBPoi.h>
#import "DetailButton.h"
@interface KCDriveDetailViewController : UIViewController
@property (nonatomic, strong) MBRouteBase *routeBase;
@property (nonatomic, copy) NSString *startStr;
@property (nonatomic, copy) NSString *endStr;
@property (nonatomic, copy) NSString *distanceStr;
@property (nonatomic, copy) NSString *timeStr;
@property (nonatomic, assign) MBPoint startPoint;
@property (nonatomic, assign) MBPoint endPoint;
@property (nonatomic, assign) MBPoint midPoint;

- (IBAction)startNavi:(UIButton *)sender;

- (IBAction)startSimNavi:(DetailButton *)sender;

- (IBAction)checkReturnBtn:(DetailButton *)sender;

- (IBAction)shareBtn:(DetailButton *)sender;

@end
