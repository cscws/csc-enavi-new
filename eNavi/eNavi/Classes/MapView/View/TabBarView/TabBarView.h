//
//  TabBarView.h
//  eNavi
//
//  Created by zuotoujing on 16/2/22.
//  Copyright © 2016年 zuotoujing. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TabBarView;
@protocol TabBarDelegate <NSObject>

- (void)tabBarView:(UIView *)view pushToOtherVCWithBtnTag:(int)btnTag;

@end

@interface TabBarView : UIView
@property(nonatomic, weak)id<TabBarDelegate>delegate;

@end
