//
//  DropView.h
//  eNavi
//
//  Created by zuotoujing on 16/5/18.
//  Copyright © 2016年 csc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DropView;
@protocol DropViewDelegate <NSObject>
@optional
- (void)dropdownMenuDidDismiss:(DropView *)menu;
- (void)dropdownMenuDidShow:(DropView *)menu;
@end

@interface DropView : UIView
@property (nonatomic, weak) id<DropViewDelegate> delegate;

+ (instancetype)menu;

/**
 *  显示
 */
- (void)showFrom:(UIView *)from;
/**
 *  销毁
 */
- (void)dismiss;

/**
 *  内容
 */
@property (nonatomic, strong) UIView *content;
/**
 *  内容控制器
 */
@property (nonatomic, strong) UIViewController *contentController;
@end
