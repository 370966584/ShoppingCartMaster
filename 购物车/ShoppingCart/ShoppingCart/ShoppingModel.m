//
//  ShoppingModel.m
//  INongBao
//
//  Created by 宇玄丶 on 16/7/23.
//  Copyright © 2016年 common. All rights reserved.
//

#import "ShoppingModel.h"


@implementation ShoppingModel
+ (NSDictionary *)objectClassInArray {
    return @{
             @"list" : @"ShoppingCellModel"
             };
}

- (void)resetHeadClickState {
    if (_list.count == 0) {
        self.headClickState = 0;
        return;
    }
    for (ShoppingCellModel *cellmodel in _list) {
        if (cellmodel.cellClickState == 0) {
            self.headClickState = 0;
            return;
        }
    }
    self.headClickState = 1;
}

- (void)resetCellClickState {
    for (ShoppingCellModel *cellmodel in _list) {
        cellmodel.cellClickState = self.headClickState;
    }
}

- (void)resetAllState:(BOOL)state {
    self.headClickState = state;
    for (ShoppingCellModel *cellmodel in _list) {
        cellmodel.cellClickState = state;
    }
}

@end

@implementation ShoppingCellModel

@end