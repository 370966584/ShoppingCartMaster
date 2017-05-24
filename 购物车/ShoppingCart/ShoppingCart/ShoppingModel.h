//
//  ShoppingModel.h
//  INongBao
//
//  Created by 宇玄丶 on 16/7/23.
//  Copyright © 2016年 common. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface ShoppingModel : NSObject

@property (nonatomic, copy) NSDictionary *headPriceDict;
/******************************商家信息******************************/
/** 商家id */
@property (nonatomic, copy) NSString *company_id;
/** 商家名称 */
@property (nonatomic, copy) NSString *nickname;
/** 头部状态 */
@property (nonatomic, assign) NSInteger headState;
/** 头部选中状态 */
@property (nonatomic, assign) NSInteger headClickState;
/** 总价 */
@property (nonatomic, copy) NSString *amount;
/** 分组数据 */
@property (nonatomic, copy) NSArray *list;

- (void)resetHeadClickState;
- (void)resetCellClickState;
- (void)resetAllState:(BOOL)state;
@end

/******************************商品信息******************************/
// cell
@interface ShoppingCellModel : NSObject

@property (nonatomic, copy) NSDictionary *cellPriceDict;
/** cart_id */
@property (nonatomic, copy) NSString *cart_id;
/** userid */
@property (nonatomic, copy) NSString *userid;
/** goods_id */
@property (nonatomic, copy) NSString *goods_id;
/** 商品名称 */
@property (nonatomic, copy) NSString *goods_name;
/** 商品数量 */
@property (nonatomic, copy) NSString *goods_num;
/** 商品价格 */
@property (nonatomic, copy) NSString *goods_price;
/** 商品市场价格 */
@property (nonatomic, copy) NSString *goods_market_price;
/** 商品总价 */
@property (nonatomic, copy) NSString *goods_amount;
/** 商品图片 */
@property (nonatomic, copy) NSString *goods_img;
/** 商品规格 */
@property (nonatomic, copy) NSString *goods_version;
/** 数量 */
@property (nonatomic, assign) NSInteger numInt;
/** 库存 */
@property(nonatomic, copy) NSString *goods_stock;
/** 编辑状态 */
@property (nonatomic, assign) NSInteger cellEditState;
/** cell 选中状态 */
@property (nonatomic, assign) NSInteger cellClickState;

@property (nonatomic, assign) NSInteger row;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, assign) NSInteger indexState;
@end