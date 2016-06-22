//
//  KCSetModel.m
//  eNavi
//
//  Created by zuotoujing on 16/6/14.
//  Copyright © 2016年 csc. All rights reserved.
//

#import "KCSetModel.h"

@implementation KCSetModel
+(instancetype)modelWithTitle:(NSString *)title index:(NSInteger)index
{
    KCSetModel *model = [[self alloc] init];
    model.title = title;
    model.index = index;
    return model;
}
@end
