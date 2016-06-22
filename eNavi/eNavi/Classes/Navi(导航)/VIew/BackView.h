//
//  BackView.h
//  eNavi
//
//  Created by zuotoujing on 16/5/4.
//  Copyright © 2016年 csc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DetailSearchFrameModel;
@interface BackView : UIView
@property (nonatomic, weak)UIImageView *imgView;
@property (nonatomic, weak)UILabel *numberLabel;
@property (nonatomic, strong)DetailSearchFrameModel *frameModel;
@end
