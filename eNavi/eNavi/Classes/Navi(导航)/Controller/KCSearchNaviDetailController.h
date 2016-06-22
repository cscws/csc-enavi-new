//
//  KCSearchNaviDetailController.h
//  eNavi
//
//  Created by zuotoujing on 16/5/3.
//  Copyright © 2016年 csc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iNaviCore/MBWmrNode.h>
#import <iNaviCore/MBPoi.h>

@interface KCSearchNaviDetailController : UIViewController
@property (nonatomic, strong) MBWmrNode *cityNode;
@property (nonatomic, assign) MBPoint startPoint;
@property (nonatomic, assign) NSInteger index;
@end
