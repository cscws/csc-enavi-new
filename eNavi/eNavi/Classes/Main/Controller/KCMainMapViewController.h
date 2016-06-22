//
//  KCMainMapViewController.h
//  eNavi
//
//  Created by zuotoujing on 16/4/27.
//  Copyright © 2016年 csc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iNaviCore/MBGpsLocation.h>
#import <iNaviCore/MBMapView.h>
@interface KCMainMapViewController : UIViewController
/**
 *  地图
 */
@property (nonatomic ,strong) MBMapView *mapView;
/**
 *  GPS 定位
 */
@property (nonatomic ,strong) MBGpsLocation *gpsLocation;

/**
 *  起点
 */
@property (nonatomic ,assign) MBPoint startPoint;
/**
 *  终点
 */
@property (nonatomic ,assign) MBPoint endPoint;


@property (nonatomic ,weak) UIView *bg;
@property (nonatomic ,weak) UIView *topView;
@property (nonatomic ,weak) UIImageView *imgV;

- (void)setNavigationBarWithTitle:(NSString *)title;

@end
