//
//  ShoppingTableViewCell.h
//  ShoppingCart
//
//  Created by 宇玄丶 on 16/8/30.
//  Copyright © 2016年 宇玄丶. All rights reserved..
//

#import <UIKit/UIKit.h>
#import "ShoppingModel.h"

typedef void(^NumberChangeBlock)();      // 数量改变
typedef void(^JumpDetailsActionBlock)(); // 跳转详情
typedef void (^BoolBlock)(BOOL value);   // 选中

@protocol ShoppingTableViewCellDelegate <NSObject>
- (void)ShoppingTableViewCell:(ShoppingCellModel *)model;
@end

@interface ShoppingTableViewCell : UITableViewCell

@property (nonatomic, weak) id<ShoppingTableViewCellDelegate>delegate;
@property (nonatomic, strong) ShoppingCellModel *model;

// -
@property (nonatomic, strong) UIButton *minusBtn;
// 商品数量
@property (nonatomic, strong) UILabel *numLabel;
// +
@property (nonatomic, strong) UIButton *addBtn;

// 数量改变
@property (nonatomic,copy) NumberChangeBlock numberAddBlock;
@property (nonatomic,copy) NumberChangeBlock numberMinusBlock;
// 跳转详情
@property (nonatomic,copy) JumpDetailsActionBlock jumpDetailsActionBlock;
// 选中
@property (nonatomic,copy) BoolBlock selectedBlock;

@end
