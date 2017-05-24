//
//  SXUIViewAdditions.h
//  Forum
//
//  Created by SunX on 14-5-7.
//  Copyright (c) 2014年 SunX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define LINE_HEIGHT     (1/[[UIScreen mainScreen] scale])

typedef void(^UIViewClickHandle)(UIView *view);

@interface UIView(Additions)

/**
 *  orgin.x
 */
@property (nonatomic, assign) CGFloat left;
/**
 *  origin.y
 */
@property (nonatomic, assign) CGFloat top;
/**
 *  origin.x+width
 */
@property (nonatomic, assign) CGFloat right;
/**
 *  y+height
 */
@property (nonatomic, assign) CGFloat bottom;
/**
 *  view.frame.size.width 宽
 */
@property (nonatomic, assign) CGFloat width;
/**
 *  view.frame.size.height 高
 */
@property (nonatomic, assign) CGFloat height;
/**
 *  view.frame.origin
 */
@property (nonatomic, assign) CGPoint origin;
/**
 *  view.frame.size
 */
@property (nonatomic, assign) CGSize  size;
/**
 *  清空所有子view
 */
-(void)removeAllSubviews;
/**
 *  增加UIView的点击事件
 */
-(void)handleClick:(UIViewClickHandle)handle;

/**
 *  底部增加一根线，自动布局方式
 */
- (UIView *)addLineOnBottom;

///**
// *  添加圆角
// *
// *  @param radius         角度
// *  @param cornerHexColor 圆角颜色 如 0xffffff
// *  @param borderColor    边框颜色 如 0xdddddd
// *  @param borderWidth    边框宽度
// */
//-(void)tddAddCornerRadiusWithRadius:(CGFloat)radius
//                     cornerHexColor:(NSInteger)cornerHexColor
//                     borderHexColor:(NSInteger)borderColor
//                        borderWidth:(CGFloat)borderWidth;
//
////增加一根线
//- (UIView*)addLineWithY:(CGFloat)originY;
//
////当前view截图
//- (UIImage*)createImageWithScale:(CGFloat)scale;

@end
