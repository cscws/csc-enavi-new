//
//  RouteStyleHisModel.h
//  eNavi
//
//  Created by zuotoujing on 16/5/12.
//  Copyright © 2016年 csc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RouteStyleHisModel : NSObject<NSCoding>
@property (nonatomic, copy) NSString *startName;
@property (nonatomic, copy) NSString *midName;
@property (nonatomic, copy) NSString *endName;
@property (nonatomic, copy) NSString *btnType;
@property (nonatomic, assign) int sX;
@property (nonatomic, assign) int sY;
@property (nonatomic, assign) int mX;
@property (nonatomic, assign) int mY;
@property (nonatomic, assign) int eX;
@property (nonatomic, assign) int eY;
@end
