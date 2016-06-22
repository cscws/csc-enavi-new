//
//  KCRouteDetailController.h
//  eNavi
//
//  Created by zuotoujing on 16/3/17.
//  Copyright © 2016年 csc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iNaviCore/MBPoi.h>
#import "KCRouteViewController.h"
@interface KCRouteDetailController : UIViewController
@property (nonatomic, assign)MBPoint startPoi;
@property (nonatomic, assign)MBPoint endPoi;
@property (nonatomic, assign)MBPoint midPoi;
@property (nonatomic, assign)buttonType btnType;
@property (nonatomic, copy) NSString *starStr;
@property (nonatomic, copy) NSString *midStr;
@property (nonatomic, copy) NSString *endStr;
@property (nonatomic, strong) MBWmrNode *node;
@property (nonatomic ,assign)MBWmrObjId parentObjId;
@end
