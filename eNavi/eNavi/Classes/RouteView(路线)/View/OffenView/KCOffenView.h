//
//  KCOffenView.h
//  eNavi
//
//  Created by zuotoujing on 16/5/26.
//  Copyright © 2016年 csc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol offenViewDelegate <NSObject>
@optional
- (void)sendBtnOneOfenView:(UIButton *)btn;

@end

@interface KCOffenView : UIView
@property (nonatomic, weak) UIButton *homeNameBtn;
@property (nonatomic, weak) UIButton *companyNameBtn;
@property (nonatomic, weak)id<offenViewDelegate>delegate;
@end
