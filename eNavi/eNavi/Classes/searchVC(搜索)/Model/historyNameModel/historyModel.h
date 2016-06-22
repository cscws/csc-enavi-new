//
//  historyModel.h
//  eNavi
//
//  Created by zuotoujing on 16/4/6.
//  Copyright © 2016年 csc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface historyModel : NSObject <NSCoding>
@property (nonatomic ,copy) NSString *name;
+ (instancetype)modelWithName:(NSString *)name;
@end
