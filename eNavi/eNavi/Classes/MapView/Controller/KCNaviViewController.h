//
//  KCNaviViewController.h
//  navimap
//
//  Created by zhouxg on 15/7/19.
//  Copyright (c) 2015年 iDIVA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iNaviCore/MBPoiFavorite.h>
#import <CoreLocation/CoreLocation.h>

@class MBBottomRadioButton;
@interface KCNaviViewController : UIViewController

#pragma mark - top

@property (nonatomic ,assign ,getter = isClickState) BOOL clickState;
/**
 *  按钮长按状态
 */
@property (nonatomic ,assign ,getter = isLongTapState) BOOL longTapState;
/**
 *  重新选择终点
 */

#pragma mark - bottom
#pragma mark -

#pragma mark - PublicMethod
#pragma mark -
/**
 *  起点 poi 坐标
 */
@property (nonatomic ,strong) MBPoiFavorite *startPoi;
/**
 *  终点 poi 坐标
 */
@property (nonatomic ,strong) MBPoiFavorite *endPoi;
/**
 *  终点 poi 坐标
 */
@property (nonatomic ,strong) MBPoiFavorite *midPoi;

/**
 *  起点坐标
 */
@property (nonatomic ,assign) MBPoint startPoint;
/**
 *  终点坐标
 */
@property (nonatomic ,assign) MBPoint endPoint;

/**
 *  途径点坐标
 */
@property (nonatomic ,assign) MBPoint midPoint;
/**
 *  选择导航模式的 index
 */
@property (nonatomic ,assign) NSInteger index;

@end
