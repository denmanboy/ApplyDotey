//
//  BaseTableViewController.m
//  BaseViewController
//
//  Created by dengyanzhou on 15/8/28.
//  Copyright (c) 2015年 YiXingLvDong. All rights reserved.
//

#import "BaseTableViewController.h"
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
@interface BaseTableViewController ()

@end

@implementation BaseTableViewController
@synthesize tableView = _tableView;
@synthesize dataArray = _dataArray;
#pragma mark - lifecycle
//加载视图
- (void)loadView
{
    [super loadView];
    //自定制视图
}
//加载视图完毕
- (void)viewDidLoad {
    [super viewDidLoad];
    //添加tableView
    [self.view addSubview:self.tableView];
    // Do any additional setup after loading the view, typically from a nib.
}
//视图将要出现
- (void)viewWillAppear:(BOOL)animated
{ [super viewWillAppear:animated];

}
//视图已经出现
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
//视图将要消失
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}
//视图已经消失
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}
//收到系统内存警告
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)fitCondition
{
//   [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"wwdc15.jpg"] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.translucent = NO;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,self.viewToTop,self.view.frame.size.width ,self.view.frame.size.height - self.viewToBottom - self.viewToTop ) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        //去掉下面没有数据呈现的cell
        self.tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}
#pragma mark - UITableViewDelegate - 子类重写
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"测试数据-%02ld",(long)indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray ) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}
#pragma mark - 注册是否开启头部刷新and脚部刷新
- (void)setIsOpenHeaderRefresh:(BOOL)isOpenHeaderRefresh
{ _isOpenHeaderRefresh =  isOpenHeaderRefresh;
    if (_isOpenHeaderRefresh) {
        WS(weakSelf);
        self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf headerRefresh];
        }];
    }else{
        NSLog(@"不开启头部刷新");
    }
}
- (void)setIsOpenFooterRefresh:(BOOL)isOpenFooterRefresh
{  _isOpenFooterRefresh =  isOpenFooterRefresh;
    if (_isOpenFooterRefresh) {
        WS(weakSelf);
        self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            // 进入刷新状态后会自动调用这个block
            [weakSelf footerRefresh];
        }];
    }else{
        NSLog(@"不开启头脚部刷新");
    }
}
#pragma mark - 头部刷新and脚部刷新
- (void)headerRefresh
{
  
}
- (void)footerRefresh
{
}

#pragma mark - 网络不可用点击打开设置页面
- (void)goNetNotUse:(UIButton *)sender
{
    [super goNetNotUse:sender];
}
@end
