//
//  KCSearchViewController.h
//  eNavi
//
//  Created by zuotoujing on 16/3/10.
//  Copyright © 2016年 csc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iNaviCore/MBPoiQuery.h>
#import <iNaviCore/MBPoi.h>
#import <iNaviCore/MBWmrNode.h>
#import "KCSearchResultController.h"
@interface KCSearchViewController : UIViewController
/**
 *  poi 搜索类
 */
@property (nonatomic ,strong) MBPoiQuery *poiQuery;
@property (nonatomic ,assign) MBPoint startPoint;
@property (nonatomic ,assign) MBPoint    point;
@property (nonatomic ,strong) MBWmrNode *cityNode;
@property (nonatomic ,strong) Class VCclass;

@property (nonatomic ,assign) NSInteger index;
@end
