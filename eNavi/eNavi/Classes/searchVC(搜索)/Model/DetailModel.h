//
//  DetailModel.h
//  eNavi
//
//  Created by zuotoujing on 16/3/10.
//  Copyright © 2016年 csc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iNaviCore/MBPoi.h>
@interface DetailModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, assign) MBPoint poi;
@property (nonatomic, assign) NSInteger i;
@property (nonatomic, assign) CGFloat distance;
//@property (nonatomic, copy)NSString *detailIcon;
@end
