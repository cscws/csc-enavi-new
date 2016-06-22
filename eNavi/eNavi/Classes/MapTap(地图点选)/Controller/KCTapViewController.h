//
//  KCTapViewController.h
//  eNavi
//
//  Created by zuotoujing on 16/3/10.
//  Copyright © 2016年 csc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KCMainMapViewController.h"
@interface KCTapViewController : KCMainMapViewController
/**
 记录哪个button跳转过来
 */
@property (nonatomic, assign) NSInteger index;
//@property (nonatomic, assign) MBPoint point;
@end
