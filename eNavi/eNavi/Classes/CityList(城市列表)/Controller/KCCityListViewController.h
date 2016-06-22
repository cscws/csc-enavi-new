//
//  KCCityListViewController.h
//  eNavi
//
//  Created by zuotoujing on 16/3/14.
//  Copyright © 2016年 csc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MBWmrNode;
@protocol KCCityListViewControllerDelegate <NSObject>
@optional
- (void)bringCityNameToKCViewVCWithNode:(MBWmrNode *)node cityName:(NSString *)cityName;
- (void)bringCityNameToKCSencondSearchViewVCWithNode:(MBWmrNode *)node cityName:(NSString *)cityName;
-(void)bringCityNameToKCNaviDetailWithNode:(MBWmrNode *)node cityName:(NSString *)cityName;
@end
@interface KCCityListViewController : UIViewController
@property (nonatomic, weak)id<KCCityListViewControllerDelegate>delegate;
@property (nonatomic, strong)Class VCClass;
@end
