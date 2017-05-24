//
//  SXUIViewAdditions.m
//  Forum
//
//  Created by SunX on 14-5-7.
//  Copyright (c) 2014年 SunX. All rights reserved.
//

#import "UIView+Additions.h"
#import <objc/runtime.h>
//#import "TDDNSObjectAdditions.h"
//#import "TDDCornerRadiusView.h"

static char *viewClickKey;

@implementation UIView(Additions)

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height {
    return self.size.height;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width {
    return self.size.width;
}

- (void)setLeft:(CGFloat)left {
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

- (CGFloat)left {
    return self.origin.x;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)top {
    return self.origin.y;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right-frame.size.width;
    self.frame = frame;
}

- (CGFloat)right {
    return self.left+self.width;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom-frame.size.height;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.top+self.height;
}

- (void)removeAllSubviews {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
}

- (void)handleClick:(UIViewClickHandle)handle {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClick)];
    [self addGestureRecognizer:tap];
    objc_setAssociatedObject(self, &viewClickKey, handle, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)viewClick {
    UIViewClickHandle callBack = objc_getAssociatedObject(self, &viewClickKey);
    if (callBack!= nil)
    {
        callBack(self);
    }
}


//- (UIView *)addLineOnBottom
//{
//    UIView *lineView = [UIView newAutoLayoutView];
//    lineView.backgroundColor = COLOR_LINE;
//    [self addSubview:lineView];
//    [lineView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
//    [lineView autoSetDimension:ALDimensionHeight toSize:0.5];
//    return lineView;
//}

//-(void)tddAddCornerRadiusWithRadius:(CGFloat)radius
//                     cornerHexColor:(NSInteger)cornerHexColor
//                     borderHexColor:(NSInteger)borderColor
//                        borderWidth:(CGFloat)borderWidth
//{
//    [TDDCornerRadiusView showInView:self withFrame:self.bounds cornerHexColor:cornerHexColor
//                          cornerRadius:radius borderHexColor:borderColor borderWidth:borderWidth];
//}
//
//- (UIView*)addLineWithY:(CGFloat)originY {
//    UIView *line =  [[UIView alloc] initWithFrame:CGRectMake(0, originY,
//                                                             self.width, LINE_HEIGHT)];
//    line.backgroundColor = LINE_COLOR;
//    [self addSubview:line];
//    return line;
//}
//
//- (UIImage*)createImageWithScale:(CGFloat)scale
//{
//    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, scale);
//    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
//    
//    UIImage *origPic = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return origPic;
//}

@end
