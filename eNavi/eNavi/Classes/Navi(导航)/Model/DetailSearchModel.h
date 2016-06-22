//
//  DetailSearchModel.h
//  eNavi
//
//  Created by zuotoujing on 16/5/4.
//  Copyright © 2016年 csc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iNaviCore/MBPoiQuery.h>
@interface DetailSearchModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, assign) MBPoint poi;
@property (nonatomic, assign) NSInteger i;
@property (nonatomic, assign) NSInteger distance;
@end
