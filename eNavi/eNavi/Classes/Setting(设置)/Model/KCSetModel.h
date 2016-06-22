//
//  KCSetModel.h
//  eNavi
//
//  Created by zuotoujing on 16/6/14.
//  Copyright © 2016年 csc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KCSetModel : NSObject
@property(nonatomic, copy)NSString *title;
@property(nonatomic, assign)NSInteger index;
+(instancetype)modelWithTitle:(NSString *)title index:(NSInteger)index;
@end
