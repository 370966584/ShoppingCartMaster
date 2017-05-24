//
//  ShoppingCartViewController.m
//  ShoppingCart
//
//  Created by 宇玄丶 on 16/8/30.
//  Copyright © 2016年 宇玄丶. All rights reserved.
//

#import "ShoppingCartViewController.h"

//#import "DataCenter+ShopCartData.h"         // 网络请求
//#import "SureOrderViewController.h"         // 确认订单
//#import "GoodListModel.h"                   // 商品信息模型
//#import "GoodsSkuModel.h"                   // 规格模型
#import "ShoppingModel.h"                   // 数据模型
#import "ShoppingTableViewCell.h"           // 购物车视图
//#import "ProductDetailsViewController.h"    // 商品详情
//#import "CompanyRootViewController.h"       // 商家详情
#import "UIView+Additions.h"
#import "UIButton+Block.h"
#import "UIAlertController+Blocks.h"
#import "MJExtension.h"

#define SCREEN_WIDTH     [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT    [UIScreen mainScreen].bounds.size.height
//-----------------------------------  font  ------------------------------------
#define FONT_NORMAL     [UIFont systemFontOfSize:15]
#define FONT_MID        [UIFont systemFontOfSize:12]
#define FONT_SMALL      [UIFont systemFontOfSize:10]
#define FONT(size)      [UIFont systemFontOfSize:size]
#define AppWeakSelf __weak typeof(self) weakSelf = self;
@interface ShoppingCartViewController () <UITableViewDataSource,UITableViewDelegate>
{
    BOOL editbool;
    UIImageView *line;      // 线
}
@property(nonatomic,strong)UITableView *tableView;;
// 购物车列表模型
@property(nonatomic,strong)ShoppingModel *shoppingModel;
@property(nonatomic,strong)ShoppingCellModel *shoppingCellModel;
// 商品信息模型
//@property(nonatomic,strong)GoodListModel *goodsModel;
// 规格模型
//@property(nonatomic,strong)GoodsSkuModel *skuModel;
// 数据源
@property(nonatomic,strong)NSMutableArray *dataArray;
// 无商品时视图
@property(nonatomic,strong)UIView *noCountBackView;
@end

@implementation ShoppingCartViewController

#pragma mark - 生命周期
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    // 每次离开购物车界面的时候把选择状态置空
    [self.dataArray removeAllObjects];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 创建编辑、完成按钮
    [self createRightEditButton];
    [self loadData];
    
#pragma mark - 商品详情页面跳转购物车，此视图为一级控制器，所以做此判断
    NSArray *arr = self.navigationController.childViewControllers;
    if (arr.count > 1) { // 二级控制器push进入
        // 背景
        self.title = @"购物车";
        self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 69 - 45, SCREEN_WIDTH, 50)];
        self.bottomView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.bottomView];
        // 线
        line = [[UIImageView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 69 - 45, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:line];
        
        // 创建表格视图
        [self setInitView];
        self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 50);
        // 创建底部工具栏视图
        
        [self createFooterView];
        
    }else { // 一级控制器的视图
        [self loadData];
        [self setInitView];
        self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 50 - 49);
        // 背景
        self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 49 - 69 - 45, SCREEN_WIDTH, 50)];
        self.bottomView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.bottomView];
        // 线
        line = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 49 - 69 - 45, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:line];
        // 创建底部视图
        [self createFooterView];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"购物车";
    editbool = NO;
}

- (void)loadData {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"ShopCartPlist" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
//    NSLog(@"%@",data);
    
    self.dataArray = [ShoppingModel mj_objectArrayWithKeyValuesArray:data];
    [self.tableView reloadData];
    // 计算商品的价格
    [self CalculationPrice];
    [self resetAllBtnState];
    
}

/*
 网络获取数据
#pragma mark - 获取数据
- (void)loadData {
    [self showHUDToWindow];
    [[DataCenter sharedDataCenter] sendShopCartListRequestTarget:self successSEL:@selector(requestShopCartListRequestSuccess:) failSEL:@selector(requestShopCartListRequestFail:)];
}

#pragma mark - 展示购物车列表、成功失败的回调
- (void)requestShopCartListRequestSuccess:(ResponseItem *)Responsedata {
    [self hideHUD];
    [self loadDataFinished];

    self.dataArray = [ShoppingModel mj_objectArrayWithKeyValuesArray:Responsedata.responseArray];
    
    if (Responsedata.responseArray.count == 0) {  无商品时视图
        [self createNoCountView];
        self.bottomView.hidden = YES;
        line.hidden = YES;
        [self.bottomView removeFromSuperview];
        self.editButton.hidden = YES;
    }
    
    [self.tableView reloadData];
     计算商品的价格
    [self CalculationPrice];
    [self resetAllBtnState];
}
- (void)requestShopCartListRequestFail:(ResponseItem *)Responsedata {
    [self loadDataFinished];
}
*/
#pragma mark - 计算商品的价格
- (void)resetAllBtnState {
    for (ShoppingModel *model in self.dataArray) {
        for (ShoppingCellModel *cellmodel in model.list) {
            if (cellmodel.cellClickState == 0) {
                self.allSelectBtn.selected = NO;
                return;
            }
        }
    }
    self.allSelectBtn.selected = YES;
}

- (void)CalculationPrice {
    // 所有商品的总价
    CGFloat allPrict = 0.0;
    for (ShoppingModel *model in self.dataArray) {
        for (ShoppingCellModel *cellmodel in model.list) {
            // 计算每个cell的总价
            if (cellmodel.cellClickState == 1) {
                allPrict += [cellmodel.goods_num intValue] * [cellmodel.goods_price floatValue] ;
            }
        }
    }
    _allPriceLabel.text = [NSString stringWithFormat:@"合计: ￥%.2f", allPrict];
}

#pragma mark - 编辑
- (void)EditBtn:(UIButton *)sender {
    if (editbool) {
        self.goPayButton.backgroundColor = [UIColor blueColor];
        editbool = NO;
    }else {
        self.goPayButton.backgroundColor = [UIColor redColor];
        editbool = YES;
    }
    // 切换文字状态
    [self.editButton setTitle:editbool ? @"完成" : @"编辑" forState:UIControlStateNormal];
    // 设置结算按钮状态
    NSString *string = editbool ? @" 删除" : @"去支付";
    [self.goPayButton setTitle:[NSString stringWithFormat:@"%@", string] forState:UIControlStateNormal];
    _allPriceLabel.hidden = editbool;
}

#pragma mark - 去支付/删除
- (void)goPayBtn:(UIButton *)sender {
    AppWeakSelf;
    
    BOOL isSelected = NO;
    for (ShoppingModel *model in self.dataArray) {
        for (ShoppingCellModel *cellmodel in model.list) {
            if (cellmodel.cellClickState == 1) {
                isSelected = YES;
                break;
            }
        }
    }
    if (!isSelected) {
//        [ComLoadingView showMsgHUD:@"您还没有选择宝贝哦~" duration:HUD_DURATION_1 touchClose:YES];
        NSLog(@"您还没有选择宝贝哦~");
        return;
    }
    
    // 如果是编辑状态下，此处为删除按钮
    if (editbool) {
        [UIAlertController showInViewController:self withTitle:@"确定要删除该宝贝吗?" message:@"" preferredStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil popoverPresentationControllerBlock:^(UIPopoverPresentationController * _Nonnull popover) {
            
        } tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            if (buttonIndex == controller.destructiveButtonIndex) {
                NSLog(@"Delete");
                NSMutableArray *delIds = [NSMutableArray array];
                for (ShoppingModel *headmodel in weakSelf.dataArray) {
                    for (ShoppingCellModel *cellmodel in headmodel.list) {
                        if (cellmodel.cellClickState == 1) {
                            [delIds addObject:cellmodel.cart_id];
                        }
                    }
                }
                if (delIds.count > 0) {
                    // 删除购物车
                    /*
                    [[DataCenter sharedDataCenter] sendDeleteCartRequestWithCart_id:delIds target:self successSEL:@selector(requestDeleteShopCartSuccess:) failSEL:@selector(requestDeleteShopCartError:)];
                     */
                }
            } else if (buttonIndex == controller.cancelButtonIndex) {
                NSLog(@"Cancel");
            }
        }];

    }else {  // 去支付
        NSMutableArray *sendModelArray = [[NSMutableArray alloc] init];
        for (ShoppingModel *model in self.dataArray) {
            NSMutableArray *listArray = [[NSMutableArray alloc] init];
            for (ShoppingCellModel *cellmodel in model.list) {
                if (cellmodel.cellClickState == 1) {
                    // 将商品信息存到数组中
                    [listArray addObject:@{
                                           @"cart_id":cellmodel.cart_id,
                                           @"userid":cellmodel.userid,
                                           @"goods_id":cellmodel.goods_id,
                                           @"goods_num":cellmodel.goods_num,
                                           @"goods_amount":cellmodel.goods_amount,
                                           @"goods_name":cellmodel.goods_name,
                                           @"goods_price":cellmodel.goods_price,
                                           @"goods_stock":cellmodel.goods_stock,
                                           @"goods_img":cellmodel.goods_img,
                                           @"goods_version":cellmodel.goods_version
                                           }];
                }
            }
            if (listArray.count > 0) {
                [sendModelArray addObject:@{
                                            @"company_id":model.company_id,
                                            @"nickname":model.nickname,
                                            @"amount":model.amount,
                                            @"list":listArray
                                            }];
            }
        }
        
        /*
        // 跳转到提交订单页面
        SureOrderViewController *sureOrder = [[SureOrderViewController alloc] initWithSureOrderType:SureOrderTypeGoPay];
        // 属性传值，将订单信息传到下一个界面
        sureOrder.dataArray = [sendModelArray copy];
        sureOrder.allPrice = self.allPriceLabel.text; // 总价
        [self.navigationController pushViewController:sureOrder animated:YES];
         */
    }
}


#pragma mark - tableview delegate And DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ShoppingModel *model = self.dataArray[section];
    return model.list.count;
}
#pragma mark - 代理数据源
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifer = @"detacell";
    ShoppingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[ShoppingTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    ShoppingModel *shoppingmodel = self.dataArray[indexPath.section];
    ShoppingCellModel *cellmodel = shoppingmodel.list[indexPath.row];
    cellmodel.section = indexPath.section;
    cell.model = cellmodel;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    __weak typeof(self) weakSelf = self;
    __block ShoppingTableViewCell *weakCell = cell;
    // 跳转到商品详情页面
    cell.jumpDetailsActionBlock = ^{
        [weakSelf jumpDetailsActionBlockWithIndexPath:indexPath];
    };
    // 数量改变+
    cell.numberAddBlock = ^{
        
        // 之前用block加减，总是不能时时改变数量，换了此方法、先用NSInteger加减，再做转换，就可以了。
        NSInteger count = [weakCell.numLabel.text integerValue];
        count ++;
        if(count > 99) {
//            [ComLoadingView showMsgHUD:@"亲,超出最大范围啦~" duration:HUD_DURATION_1 touchClose:YES];
            NSLog(@"亲,超出最大范围啦~");
            return ;
        }
        if (count > [cellmodel.goods_stock intValue]) {
//            [ComLoadingView showMsgHUD:@"亲,木有那么多库存啦~" duration:HUD_DURATION_1 touchClose:YES];
            NSLog(@"亲,木有那么多库存啦~");
            return ;
        }
        NSString *numStr = [NSString stringWithFormat:@"%ld",(long)count];
        weakCell.numLabel.text = numStr;
        
        cellmodel.goods_num = [NSString stringWithFormat:@"%ld", (long)count];
        /*
         数量增加
        [[DataCenter sharedDataCenter] sendUpDateCartRequestCart_id:cellmodel.cart_id goods_num:weakCell.numLabel.text Target:self successSEL:@selector(requestUpdateSuccess:) failSEL:@selector(requestUpdateFail:)];
         */
        [weakSelf CalculationPrice];
    };
    // 数量改变-
    cell.numberMinusBlock = ^{
        
        NSInteger count = [weakCell.numLabel.text integerValue];
        count --;
        if(count <= 0) {
//            [ComLoadingView showMsgHUD:@"亲,再减就没了~" duration:HUD_DURATION_1 touchClose:YES];
            NSLog(@"亲,再减就没了~");
            return ;
        }
        NSString *numStr = [NSString stringWithFormat:@"%ld",(long)count];
        weakCell.numLabel.text = numStr;
        cellmodel.goods_num = [NSString stringWithFormat:@"%ld", (long)count];
        /*
         数量减少
        [[DataCenter sharedDataCenter] sendUpDateCartRequestCart_id:cellmodel.cart_id goods_num:weakCell.numLabel.text Target:self successSEL:@selector(requestUpdateSuccess:) failSEL:@selector(requestUpdateFail:)];
         */
        [weakSelf CalculationPrice];
    };
    
    cell.selectedBlock = ^(BOOL value){
        [shoppingmodel resetHeadClickState];
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:NO];
        [weakSelf resetAllBtnState];
        [weakSelf CalculationPrice];
    };
    
    return cell;
}
#pragma mark - 跳转到商品详情
- (void)jumpDetailsActionBlockWithIndexPath:(NSIndexPath *)indexPath {
    // 获取每组、每行的模型
    ShoppingModel *shoppingmodel = self.dataArray[indexPath.section];
    ShoppingCellModel *cellmodel = shoppingmodel.list[indexPath.row];
    // 跳转到商品详情
//    ProductDetailsViewController *detaVC = [[ProductDetailsViewController alloc] init];
//    detaVC.good_ID = cellmodel.goods_id;
//    [self.navigationController pushViewController:detaVC animated:YES];
    
}
#pragma mark - 每组 组头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    ShoppingModel *headModel = self.dataArray[section];
    
    // 背景视图
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 46)];
    view.backgroundColor = [UIColor whiteColor];
    
    // 分组全选按钮
    UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 46)];
    
    UIImage *btimg = [UIImage imageNamed:@"tool_button_buy_bianji_bor"];
    UIImage *selectImg = [UIImage imageNamed:@"tool_button_buy_bianji_sel"];
    
    UIButton *collocationBtn = [[UIButton alloc] initWithFrame:CGRectMake(12, 10, btimg.size.width, btimg.size.height)];
    [collocationBtn setImage:btimg forState:UIControlStateNormal];
    [collocationBtn setImage:selectImg forState:UIControlStateSelected];
    collocationBtn.tag = section;
    
    
    AppWeakSelf;
    [collocationBtn handleControlEventWithBlock:^{
        headModel.headClickState = headModel.headClickState == 0 ? 1 : 0;
        [headModel resetCellClickState];
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:NO];
        [weakSelf resetAllBtnState];
        [weakSelf CalculationPrice];
    }];
    
    [btnView addSubview:collocationBtn];
    [view addSubview:btnView];
    
    
    // 图片
    UIView *nickView = [[UIView alloc] initWithFrame:CGRectMake(50, 0, SCREEN_WIDTH - 50, 46)];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 13, 20, 20)];
    imgView.image = [UIImage imageNamed:@"tool_button_buy_shangjia_bor"];
    [nickView addSubview:imgView];
    
    // 某某公司名称
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgView.frame) + 10, 13, SCREEN_WIDTH - 55 - CGRectGetMaxX(imgView.frame) - 20, 20)];
    label.textColor = [UIColor blackColor];
    label.font = FONT_NORMAL;
    [nickView addSubview:label];
    [view addSubview:nickView];
    // 赋值
    label.text = headModel.nickname;
    
    [nickView handleClick:^(UIView *view) {
        // 跳转到商家的店铺详情
        /*
        CompanyRootViewController *companyDetail = [[CompanyRootViewController alloc] init];
        companyDetail.company_id = headModel.company_id;
        [AppCommon pushViewController:companyDetail animated:YES];
         */
    }];
    
    collocationBtn.selected = headModel.headClickState == 1;
    
    return view;
}
#pragma mark - 组头、组尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 46;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}
#pragma mark - 行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 91;
}

#pragma mark - 分割线去掉左边15个像素
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
/*
 换成网络数据
#pragma mark - 删除购物车成功、失败回调
- (void)requestDeleteShopCartSuccess:(ResponseItem *)Responsedata {
    [ComLoadingView showMsgHUD:@"删除商品成功" duration:HUD_DURATION_1 touchClose:YES];
    [self loadData];
    [self.bottomView removeFromSuperview];
    [self.tableView reloadData];
}
- (void)requestDeleteShopCartError:(ResponseItem *)Responsedata {
}

#pragma mark - 修改数量、成功失败的回调
- (void)requestUpdateSuccess:(RequestItem *)Responsedata {
    [ComLoadingView showMsgHUD:@"修改数量成功" duration:HUD_DURATION_1 touchClose:YES];
}
- (void)requestUpdateFail:(RequestItem *)Responsedata {
}
*/

/*
 MJRefresh
#pragma mark - 结束刷新
- (void)loadDataFinished {
    // 刷新表格
    [self.tableView reloadData];
    // 拿到当前的下拉刷新控件，结束刷新状态
    [self.tableView.mj_header endRefreshing];
}
 */
#pragma mark - 购物车中无商品时 显示
- (void)createNoCountView {
    
    self.noCountBackView = [[UIView alloc] init];
    self.noCountBackView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    self.noCountBackView.backgroundColor = [UIColor lightGrayColor];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"buy_kong"]];
    imgView.frame = CGRectMake((SCREEN_WIDTH - 101) / 2, (SCREEN_HEIGHT - 101 - 64 - 49)/2, 101, 101);
    [self.noCountBackView addSubview:imgView];
    
    UILabel *lable = [[UILabel alloc] init];
    lable.text = @"您的购物车空空如也~";
    lable.font = FONT_NORMAL;
    lable.textColor = [UIColor lightGrayColor];
    lable.frame = CGRectMake((SCREEN_WIDTH - 145) / 2, CGRectGetMaxY(imgView.frame) + 16, 145, 15);
    [self.noCountBackView addSubview:lable];
    [self.tableView addSubview:self.noCountBackView];
}


#pragma mark - 创建编辑、完成按钮
- (void)createRightEditButton {
    // 创建编辑、完成按钮
    self.editButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50, 10, 31, 15)];
    [self.editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [self.editButton addTarget:self action:@selector(EditBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.editButton.titleLabel.font = FONT_NORMAL;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.editButton];
    // 显示编辑按钮
    UIViewController *ctro = [self.parentViewController isKindOfClass:[UITabBarController class]] ? self.parentViewController : self;
    ctro.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark - 创建表格视图
- (void)setInitView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
}

#pragma mark - 创建底部工具栏视图
- (void)createFooterView {
    // 选择状态按钮
    UIImage *btimg = [UIImage imageNamed:@"tool_button_buy_bianji_bor"];
    UIImage *selectImg = [UIImage imageNamed:@"tool_button_buy_bianji_sel"];
    
    self.allSelectBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, btimg.size.width + 50, 50)];
    [self.allSelectBtn setImage:btimg forState:UIControlStateNormal];
    [self.allSelectBtn setImage:selectImg forState:UIControlStateSelected];
    [self.allSelectBtn setTitle:@"全选" forState:UIControlStateNormal];
    [self.allSelectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.allSelectBtn.titleLabel.font = FONT(13);
    
    AppWeakSelf;
    [self.allSelectBtn handleControlEventWithBlock:^{
        weakSelf.allSelectBtn.selected = !weakSelf.allSelectBtn.selected;
        [weakSelf.dataArray enumerateObjectsUsingBlock:^(ShoppingModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
            [model resetAllState:weakSelf.allSelectBtn.selected];
        }];
        [weakSelf.tableView reloadData];
        [weakSelf CalculationPrice];
    }];
    [self.bottomView addSubview:self.allSelectBtn];
    
    CGFloat width = SCREEN_WIDTH - CGRectGetMaxX(self.allSelectBtn.frame) - 10;
    
    // 合计:
    _allPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.allSelectBtn.frame) , 18, width/2, 14)];
    _allPriceLabel.textColor = [UIColor redColor];
    _allPriceLabel.text = [NSString stringWithFormat:@"合计: ￥0.00"];
    _allPriceLabel.font = FONT_NORMAL;
    [self.bottomView addSubview:_allPriceLabel];
    
    // 去支付 删除 按钮
    self.goPayButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_allPriceLabel.frame), 8, width/2, 36)];
    [self.goPayButton setTitle:@"去支付" forState:UIControlStateNormal];
    self.goPayButton.backgroundColor = [UIColor blueColor];
    [self.goPayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.goPayButton.layer.cornerRadius = 3.0f;
    [self.goPayButton addTarget:self action:@selector(goPayBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.goPayButton];
}


#pragma mark - 懒加载
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
