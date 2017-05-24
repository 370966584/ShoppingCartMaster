//
//  GoodsInfoModel.m
//  ShoppingList_Demo
//
//  Created by 李金华 on 15/4/21.
//  Copyright (c) 2015年 LJH. All rights reserved.
//

#import "GoodsInfoModel.h"

@implementation GoodsInfoModel


-(instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        self.imageName = dict[@"imageName"];
        self.goodsTitle = dict[@"goodsTitle"];
        self.goodsPrice = dict[@"goodsPrice"];
        self.goodsNum = [dict[@"goodsNum"]intValue];
        self.selectState = [dict[@"selectState"]boolValue];
    }
    return  self;
}

@end
