//
//  popView.h
//  eNavi
//
//  Created by zuotoujing on 16/4/26.
//  Copyright © 2016年 csc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol popViewDelegate <NSObject>
@optional
- (void)sendButtonOnPopView:(UIButton *)button;

@end
@interface popView : UIView
@property (nonatomic, weak)id <popViewDelegate> delegate;
@end
