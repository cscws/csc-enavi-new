//
//  KCRouteViewController.h
//  eNavi
//
//  Created by zhouxg on 16/3/3.
//  Copyright © 2016年 csc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iNaviCore/MBWmrNode.h>
#import <iNaviCore/MBPoi.h>

@interface KCRouteViewController : UIViewController<UITextFieldDelegate>
@property (nonatomic, strong) MBWmrNode *node;
@property (nonatomic, assign) MBPoint startPoi;
@property (nonatomic, assign) MBPoint endPoi;
@property (nonatomic, assign) MBPoint midPoi;
@property (nonatomic, assign) MBWmrObjId parentObjId;
@property (nonatomic, copy) NSString *endStr;
@end
