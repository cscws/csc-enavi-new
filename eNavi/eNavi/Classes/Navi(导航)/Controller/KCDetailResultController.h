//
//  KCDetailResultController.h
//  eNavi
//
//  Created by zuotoujing on 16/5/4.
//  Copyright © 2016年 csc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iNaviCore/MBPoi.h>
@interface KCDetailResultController : UIViewController
@property (nonatomic, strong) NSArray *resultArr;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) MBPoint startPoint;
@end
