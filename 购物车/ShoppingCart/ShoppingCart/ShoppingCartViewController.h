//
//  ShoppingCartViewController.h
//  ShoppingCart
//
//  Created by 宇玄丶 on 16/8/30.
//  Copyright © 2016年 宇玄丶. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^HandleControlEventWithBlock)();      // 组头按钮
@interface ShoppingCartViewController : UIViewController

/** 右上角编辑按钮 */
@property(nonatomic,strong)UIButton *editButton;
/** 底部视图 */
@property(nonatomic,strong)UIView *bottomView;
/** 全选按钮 */
@property(nonatomic,strong)UIButton *allSelectBtn;
/** 总价 */
@property(nonatomic,strong)UILabel *allPriceLabel;
/** 去支付按钮 */
@property(nonatomic,strong)UIButton *goPayButton;
/** 结算文字 */
@property(nonatomic,strong)UILabel *settlementLabel;

@property(nonatomic,copy)HandleControlEventWithBlock handleControlEventWithBlock;
@end
