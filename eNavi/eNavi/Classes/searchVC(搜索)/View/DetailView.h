//
//  DetailView.h
//  eNavi
//
//  Created by zuotoujing on 16/5/5.
//  Copyright © 2016年 csc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DetailFrameModel;
@interface DetailView : UIView
@property (nonatomic, weak)UIImageView *imgView;
@property (nonatomic, weak)UILabel *numberLabel;
@property (nonatomic ,strong)DetailFrameModel *detailFrameModel;
-(void)buttonOncellClickedBlock:(void(^)(UIButton *btn,DetailFrameModel *frameModel))buttonblock;
@end
