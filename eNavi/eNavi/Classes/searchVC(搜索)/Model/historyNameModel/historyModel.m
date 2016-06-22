//
//  historyModel.m
//  eNavi
//
//  Created by zuotoujing on 16/4/6.
//  Copyright © 2016年 csc. All rights reserved.
//

#import "historyModel.h"

@implementation historyModel

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_name forKey:@"name"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        _name = [aDecoder decodeObjectForKey:@"name"];
    }
    return self;
}
+ (instancetype)modelWithName:(NSString *)name
{
    historyModel *model = [[historyModel alloc] init];
    model.name = name;
    return model;
}
@end
