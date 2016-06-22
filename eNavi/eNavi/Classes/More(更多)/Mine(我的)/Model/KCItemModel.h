//
//  KCgroupOneModel.h
//  eNavi
//
//  Created by zuotoujing on 16/3/8.
//  Copyright © 2016年 csc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KCItemModel : NSObject
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *icon;
+(instancetype)modelWithIcon:(NSString *)icon title:(NSString *)title;
@end
