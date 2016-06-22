//
//  KCgroupOneModel.m
//  eNavi
//
//  Created by zuotoujing on 16/3/8.
//  Copyright © 2016年 csc. All rights reserved.
//

#import "KCItemModel.h"

@implementation KCItemModel
+(instancetype)modelWithIcon:(NSString *)icon title:(NSString *)title
{
    KCItemModel *modelOne = [[self alloc] init];
    modelOne.title = title;
    modelOne.icon = icon;
    return modelOne;
}
@end
