//
//  PoiDetailViewController.h
//  eNavi
//
//  Created by zuotoujing on 16/4/10.
//  Copyright © 2016年 csc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iNaviCore/MBPoi.h>
@interface KCPoiDetailViewController : UIViewController
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, assign) MBPoint startPoi;
@property (nonatomic, assign) MBPoint endPoi;
- (IBAction)ShouCBtnClicked:(id)sender;
- (IBAction)zhongDianBtnClicked:(UIButton *)sender;
- (IBAction)startNavi:(UIButton *)sender;
- (IBAction)searchAroundBtn:(UIButton *)sender;
- (IBAction)shareBtnClicked:(UIButton *)sender;

@end
