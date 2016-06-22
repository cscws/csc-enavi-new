//
//  KCNaviDetailViewController.h
//  eNavi
//
//  Created by zuotoujing on 16/3/6.
//  Copyright © 2016年 csc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iNaviCore/MBPoi.h>

typedef void(^bringNodeBlock)(MBWmrNode *node);
@interface KCNaviDetailViewController : UIViewController
@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, assign) MBPoint startPoint;
/**
 Wmr信息
 */
@property (nonatomic ,strong)MBWmrNode *cityNode;
@property (nonatomic, copy)bringNodeBlock nodeBlock;
- (void)bringCityNode:(bringNodeBlock)block;
@end
