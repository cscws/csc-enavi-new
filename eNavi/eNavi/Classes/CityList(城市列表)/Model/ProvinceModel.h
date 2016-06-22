//
//  ProvinceModel.h
//  eNavi
//
//  Created by zuotoujing on 16/3/15.
//  Copyright © 2016年 csc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProvinceModel : NSObject
@property (nonatomic, copy)NSString *Pname;
@property (nonatomic, assign,getter=isOPen)BOOL Open;
@end
