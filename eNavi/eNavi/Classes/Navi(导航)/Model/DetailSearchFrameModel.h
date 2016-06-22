//
//  DetailSearchFrameModel.h
//  eNavi
//
//  Created by zuotoujing on 16/5/4.
//  Copyright © 2016年 csc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DetailSearchModel;

@interface DetailSearchFrameModel : NSObject
@property (nonatomic, strong)DetailSearchModel *model;
@property (nonatomic, assign)CGRect iconF;
@property (nonatomic, assign)CGRect numberF;
@property (nonatomic, assign)CGRect nameF;
@property (nonatomic, assign)CGRect addressF;
@property (nonatomic, assign)CGRect distanceF;
@property (nonatomic, assign)CGFloat viewH;
@end
