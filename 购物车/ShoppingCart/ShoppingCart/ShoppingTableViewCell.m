//
//  ShoppingTableViewCell.m
//  ShoppingCart
//
//  Created by 宇玄丶 on 16/8/30.
//  Copyright © 2016年 宇玄丶. All rights reserved.
//

#import "ShoppingTableViewCell.h"
#import "ShoppingModel.h"
#define SCREEN_WIDTH     [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT    [UIScreen mainScreen].bounds.size.height
//-----------------------------------  font  ------------------------------------
#define FONT_NORMAL     [UIFont systemFontOfSize:15]
#define FONT_MID        [UIFont systemFontOfSize:12]
#define FONT_SMALL      [UIFont systemFontOfSize:10]
#define FONT(size)      [UIFont systemFontOfSize:size]
@interface ShoppingTableViewCell ()

@property(nonatomic,strong)ShoppingModel *shopModel;
@end

@implementation ShoppingTableViewCell
{
    NSIndexPath *indexPath;
    // 图片
    UIImageView *headImageView;
    // 标题
    UILabel *titleLabel;
    // 价格
    UILabel *priceLabel;
    // 规格
    UILabel *styleLabel;
    // 库存
    UILabel *stockLabel;
    // 确定
    UIButton *selectBtn;
    BOOL isbool;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initWithView];
    }
    return  self;
}

#pragma mark - 初始化视图
- (void)initWithView {
    // 勾选按钮
    UIImage *btimg = [UIImage imageNamed:@"tool_button_buy_bianji_bor"];
    UIImage *selectImg = [UIImage imageNamed:@"tool_button_buy_bianji_sel"];
    
    selectBtn = [[UIButton alloc]initWithFrame:CGRectMake(12, 0, btimg.size.width, 100)];
    [selectBtn setImage:btimg forState:UIControlStateNormal];
    [selectBtn setImage:selectImg forState:UIControlStateSelected];
    
    [selectBtn addTarget:self action:@selector(selectBtnAction:) forControlEvents:UIControlEventTouchDown];
    [self.contentView addSubview:selectBtn];
    
    // 商品图片图片
    headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(selectBtn.frame) + 10, 10, 71, 71)];
    headImageView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:headImageView];
    
    // 商品名称
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headImageView.frame) + 10, 12, SCREEN_WIDTH - CGRectGetMaxX(headImageView.frame) - 20, 15)];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = FONT_NORMAL;
    titleLabel.text = @"这是商品的名称这是商品的名称这是商品的名称这是商品的名称";
    [self.contentView addSubview:titleLabel];
    
    // 规格
    styleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headImageView.frame) + 10, CGRectGetMaxY(titleLabel.frame) + 10, SCREEN_WIDTH - CGRectGetMaxX(headImageView.frame) - 12, 14)];
    styleLabel.textColor = [UIColor blackColor];
    styleLabel.font = FONT(14);
    styleLabel.text = @"规格：200kg/袋/车";
    [self.contentView addSubview:styleLabel];
    
    // 等分宽度
    CGFloat Width = SCREEN_WIDTH - CGRectGetMaxX(headImageView.frame) - 12;
    
    // 价格
    priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headImageView.frame) + 10, CGRectGetMaxY(styleLabel.frame) + 10, Width / 2, 14)];
    priceLabel.textColor = [UIColor blackColor];
    priceLabel.textAlignment = NSTextAlignmentLeft;
    priceLabel.font = FONT(17);
    [self.contentView addSubview:priceLabel];
    
    // 库存
    stockLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 10 - 30 - 48 - 33 - 30, CGRectGetMaxY(styleLabel.frame) + 10, 100, 14)];
    stockLabel.textColor = [UIColor clearColor];
    stockLabel.textAlignment = NSTextAlignmentLeft;
    stockLabel.font = FONT(10);
    [self.contentView addSubview:stockLabel];
    
    // 点击商品信息跳转详情 （考虑加减按钮也在cell上，点击加减总是跳转详情，所以单独写个事件）
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(60, 0, SCREEN_WIDTH - 100 - Width/2, 71);
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn];

    // 加、减、数量
    self.minusBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 10 - 30 - 48 - 33 , CGRectGetMaxY(styleLabel.frame) + 5, 30, 28)];
    [self.minusBtn setTitle:@"-" forState:UIControlStateNormal];
    [self.minusBtn setTitleColor:[UIColor blackColor] forState:0];
    [self.minusBtn setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
    [self.minusBtn addTarget:self action:@selector(MinusBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.minusBtn];
    
    _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 10 - 30 - 48, CGRectGetMaxY(styleLabel.frame) + 5, 45, 28)];
    _numLabel.text = @"1";
    _numLabel.textAlignment = NSTextAlignmentCenter;
    _numLabel.textColor = [UIColor blackColor];
    _numLabel.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    _numLabel.font = FONT(13);
    [self.contentView addSubview:_numLabel];
    
    self.addBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 10 - 30, CGRectGetMaxY(styleLabel.frame) + 5, 30, 28)];
    [self.addBtn setTitleColor:[UIColor blackColor] forState:0];
    [self.addBtn setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
    [self.addBtn setTitle:@"+" forState:UIControlStateNormal];
    [self.addBtn addTarget:self action:@selector(AddBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.addBtn];
}

#pragma mark - 跳转到商品详情页面
- (void)btnClick:(UIButton *)btn {
    if (self.jumpDetailsActionBlock) {
        self.jumpDetailsActionBlock();
    }
}

#pragma mark - 减
- (void)MinusBtn:(UIButton *)sender {
    if (self.numberMinusBlock) {
        self.numberMinusBlock();
    }
}
#pragma mark - 加
- (void)AddBtn:(UIButton *)sender {
    if (self.numberAddBlock) {
        self.numberAddBlock();
    }
}

#pragma mark - 赋值
- (void)setModel:(ShoppingCellModel *)model {
    _model = model;
    indexPath = [NSIndexPath indexPathForRow:model.row inSection:model.section];
    // 商品名称
    titleLabel.text = model.goods_name;
    // 商品图片  (自行导入SD的库)
//    [headImageView sd_setImageWithURL:[NSURL URLWithString:[model.goods_img stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"placeholderMid"]];
    [headImageView setImage:[UIImage imageNamed:@"placeholderMid"]];
    // 规格
    styleLabel.text = [NSString stringWithFormat:@"规格: %@", model.goods_version];
    // 商品数量
    _numLabel.text = [NSString stringWithFormat:@"%@", model.goods_num];
    // 商品价格
    priceLabel.text = [NSString stringWithFormat:@"￥%@", model.goods_price];
    // 库存
    stockLabel.text = [NSString stringWithFormat:@"%@",model.goods_stock];
    // 判断选中状态
    if (model.cellClickState == 1) {
        isbool = YES;
        [selectBtn setImage:[UIImage imageNamed:@"tool_button_buy_bianji_sel"] forState:UIControlStateNormal];
    } else {
        isbool = NO;
        [selectBtn setImage:[UIImage imageNamed:@"tool_button_buy_bianji_bor"] forState:UIControlStateNormal];
    }
}

#pragma mark - 选中状态
- (void)selectBtnAction:(UIButton *)sendel {
    
    if (isbool) { 
        _model.cellClickState = 0;
        [selectBtn setImage:[UIImage imageNamed:@"tool_button_buy_bianji_bor"] forState:UIControlStateNormal];
        isbool = NO;
    }else{
        _model.cellClickState = 1;
        [selectBtn setImage:[UIImage imageNamed:@"tool_button_buy_bianji_sel"] forState:UIControlStateNormal];
        isbool = YES;
    }
    
    if (_selectedBlock) {
        _selectedBlock(isbool);
    }
}

- (void)awakeFromNib {
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
