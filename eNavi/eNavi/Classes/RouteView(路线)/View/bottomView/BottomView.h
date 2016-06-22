//
//  BottomView.h
//  eNavi
//
//  Created by zuotoujing on 16/3/18.
//  Copyright © 2016年 csc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class bottomModel,BottomView;
@protocol BottomViewDelegate <NSObject>
- (void)changeRoutePlanWithTag:(int)btnTag;
@end
@interface BottomView : UIView
@property (nonatomic, strong)bottomModel *model;
@property (nonatomic, weak)id<BottomViewDelegate>delegate;
@end
