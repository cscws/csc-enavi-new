//
//  DetailFrameModel.h
//  eNavi
//
//  Created by zuotoujing on 16/3/10.
//  Copyright © 2016年 csc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DetailModel;
@interface DetailFrameModel : NSObject
@property (nonatomic, strong)DetailModel *model;
@property (nonatomic, assign)CGRect iconF;
@property (nonatomic, assign)CGRect numberF;
@property (nonatomic, assign)CGRect nameF;
@property (nonatomic, assign)CGRect addressF;
@property (nonatomic, assign)CGRect distanceF;
@property (nonatomic, assign)CGRect lineF;
@property (nonatomic, assign)CGRect verticalLineF;
@property (nonatomic, assign)CGRect naviBtnF;
@property (nonatomic, assign)CGRect detailBtnF;

@property (nonatomic, assign)CGFloat viewH;

@end
