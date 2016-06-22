//
//  NaviDetailHisModel.h
//  eNavi
//
//  Created by zuotoujing on 16/5/5.
//  Copyright © 2016年 csc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iNaviCore/MBPoi.h>
@class DetailSearchFrameModel;
@interface NaviDetailHisModel : NSObject<NSCoding>
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *adress;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, assign) int sX;
@property (nonatomic, assign) int sY;
@property (nonatomic, assign) int eX;
@property (nonatomic, assign) int eY;
+ (instancetype)modelWithModel:(DetailSearchFrameModel *)frameModel startPoint:(CGPoint)SPoint;
@end
