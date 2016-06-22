//
//  miShuView.h
//  eNavi
//
//  Created by zuotoujing on 16/5/23.
//  Copyright © 2016年 csc. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol miShuViewDelegate <NSObject>
@optional
- (void)sendButtonOnMishuView:(UIButton *)button;

@end
@interface miShuView : UIView
@property (nonatomic, weak)id <miShuViewDelegate> delegate;
@end
