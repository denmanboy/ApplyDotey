//
//  RootViewController.m
//  ApplyDotey
//
//  Created by dengyanzhou on 15/9/1.
//  Copyright (c) 2015年 YiXingLvDong. All rights reserved.
//

#import "RootViewController.h"
#import "InforModel.h"
#import "InfoCell.h"
#import "UIImageView+AFNetworking.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#import "KeychainUUID.h"
@interface RootViewController ()<UIAlertViewDelegate,InfoCellDelegate>

@property (nonatomic,strong) UIImageView   *headerImageView;
@property (nonatomic,copy  ) NSString      *logourl;
@property (nonatomic,strong) MBProgressHUD *hud;
@property (nonatomic,copy  ) NSString      *validCode;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"申请宝";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(goToSetting)];
    self.tableView.tableHeaderView = self.headerImageView;
    [self configSeparatorLine];
    //用户输入表单的code 保存
    NSString *code  =  (NSString*)[[NSUserDefaults standardUserDefaults]objectForKey:@"code"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    //保存用户的自己的表单
    if (code.length) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[self getDeviceInfo]];
        [dic setObject:code forKey:@"code"];
        [self requestDataWithDic:dic];
    }else{
        
        [self requestDataWithDic:[self getDeviceInfo]];
    }
}
- (UIImageView *)headerImageView
{
    if (!_headerImageView) {
        self.headerImageView = ({
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,130)];
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
            [imageView addGestureRecognizer:tap];
            imageView;
        });
    }
    return _headerImageView;
}
#pragma mark - 开启网络监听
- (void)viewWillAppear:(BOOL)animated
{
    //self.isOpenNetListen = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    //self.isOpenNetListen = NO;
}
- (void)headerRefresh
{
    [self.tableView.header endRefreshing];
}
- (void)footerRefresh
{
    [self.tableView.footer endRefreshing];
}

#pragma mark - 设置
- (void)goToSetting
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"输入参数" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *texfField = [alertView textFieldAtIndex:0];
    NSString *code = [[NSUserDefaults standardUserDefaults] objectForKey:@"code"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    if (code.length) {
        texfField.text = code;
    }
    [alertView show];
    
}

- (void)fitCondition
{
    self.navigationController.navigationBar.translucent = NO;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        UITextField *field = [alertView textFieldAtIndex:0];
        if (!(field.text.length)) {
            //数据为空直接返回
            [self showPromptTextUIWithPromptText:@"参数为空,输入参数!" title:nil andDuration:2 andposition:CSToastPositionCenter];
            return;
        }
        //保存数据
        [[NSUserDefaults standardUserDefaults]setObject: field.text forKey:@"code"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        //请求服务器数据
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[self getDeviceInfo]];
        [dic setObject:field.text forKey:@"code"];
        
        [self requestDataWithDic:dic];
    }
}
#pragma mark - 请求服务器数据
- (void)requestDataWithDic:(NSDictionary*)dic
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    if ([appDelegate.reach currentReachabilityStatus] == NotReachable) {
        [self showPromptTextUIWithPromptText:@"网络不可用" title:nil andDuration:2 andposition:CSToastPositionCenter];
        return;
    }
    [self showLoadingUI];
    [[MGJRequestManager sharedInstance] GET:@"http://shufaba.net/sqb/m/"
                                 parameters:dic
                           startImmediately:YES // 5
                       configurationHandler:^(MGJRequestManagerConfiguration *configuration){
                           
                       } completionHandler:^(NSError *error, id<NSObject> result, BOOL isFromCache, AFHTTPRequestOperation *operation) {
                           
                           [self hideLoadingUI];
                           if (error) {
                               [self showPromptTextUIWithPromptText:@"数据加载失败" title:nil andDuration:2 andposition:CSToastPositionCenter];;
                               return ;
                           }
                           //返回数据
                           if (result) {
                               if ([result isKindOfClass:[NSDictionary class]] && ((NSDictionary*)result).count ) {
                                   InforModel *inforModel = [[InforModel alloc]init];
                                   [inforModel setValuesForKeysWithDictionary:(NSDictionary*)result];
                                   self.logourl = inforModel.logourl;
                                   self.title = inforModel.title;
                                   //tableView 头部图片
                                   [(UIImageView*)self.tableView.tableHeaderView setImageWithURL:[NSURL URLWithString:inforModel.logo] placeholderImage:nil];
                                   if (!inforModel.input.count) {
                                       [self showPromptTextUIWithPromptText:@"没有数据" title:nil andDuration:2 andposition:CSToastPositionCenter];;
                                       return;
                                   }
                                   //有效的Code 保存服务返回的当期表单的标识
                                   self.validCode = inforModel.code;
                                   [self.dataArray removeAllObjects];
                                   [self.dataArray addObjectsFromArray:inforModel.input];
                                   [self.tableView reloadData];
                               }
                           }else{
                               [self showPromptTextUIWithPromptText:@"服务器返回数据为空" title:nil andDuration:1.5 andposition:CSToastPositionCenter];
                           }
                       }];
    
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.dataArray.count) {
        
        static NSString *cellID =  @"cellID2";
        UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(30, 15,tableView.frame.size.width - 60, 34);
            button.layer.cornerRadius = 6;
            [button setBackgroundColor:[UIColor colorWithRed:0.143 green:0.522 blue:1.000 alpha:1.000]];
            button.showsTouchWhenHighlighted = YES;
            button.enabled = YES;
            button.tag = 100;
            [button addTarget:self action:@selector(goToCommit) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:button];
            cell.selectionStyle  = UITableViewCellSelectionStyleNone;
        }
        //有数据
        if (self.dataArray.count != 0) {
            UIButton *button  = (UIButton*)[cell viewWithTag:100];
            [button setTitle:@"点击提交" forState:UIControlStateNormal];
            button.enabled = YES;
        //没有数据
        }else{
            UIButton *button  = (UIButton*)[cell viewWithTag:100];
            [button setTitle:@"没有数据" forState:UIControlStateNormal];
            button.enabled = NO;
        }
        return cell;
    }
    static NSString *cellID = @"cellID";
    InfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[InfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.selected = NO;
    }
    //清空历史
    cell.keyLabel.text = nil;
    cell.textField.text = nil;
    cell.keyLabel.text = ((Input*)self.dataArray[indexPath.row]).value;
    if (((Input*)self.dataArray[indexPath.row]).text.length == 0) {
        NSString *string = [NSString stringWithFormat:@"请输入%@",((Input*)self.dataArray[indexPath.row]).value];
        cell.textField.placeholder= string;
    }else{
        cell.textField.text = ((Input*)self.dataArray[indexPath.row]).text;
    }
    cell.indexPath = indexPath;
    return cell;
}
//分割线左边
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]){
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)configSeparatorLine
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]){
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]){
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}
#pragma mark - cellDelegate
- (void)textFieldDidEndEditingWithCell:(InfoCell *)cell andTextFeild:(UITextField *)textField
{
    Input *input = self.dataArray[cell.indexPath.row];
    input.text = textField.text;
}
- (void)goToCommit
{
    //拼接参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //标示整个表单是否都为空
    __block BOOL isEmpty = YES;
    [self.dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Input *input =(Input*)obj;
        if (input.text.length != 0) {
            [dic setObject:input.text forKey:input.key];
            isEmpty = NO;
        }
    }];
    //整个表单都为空直接返回
    if (isEmpty) {
        [self showPromptTextUIWithPromptText:@"请填写相关信息" title:nil andDuration:2 andposition:CSToastPositionCenter];;
        return;
    }
    //用户输入了至少一个数据
    if (dic.count) {
        //添加code标示
        if (self.validCode.length) {
        [dic setObject:self.validCode forKey:@"code"];
        }
        [self commitInfoWithDic:dic];
    }
}
#pragma mark - 提交表单
- (void)commitInfoWithDic:(NSDictionary*)dic
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    if ([appDelegate.reach currentReachabilityStatus] == NotReachable) {
        [self showPromptTextUIWithPromptText:@"网络不可用" title:nil andDuration:2 andposition:CSToastPositionCenter];
        return;
    }
    [self showCustomLoadingUI];
    [[MGJRequestManager sharedInstance] GET:@"http://shufaba.net/sqb/s/"
                                 parameters:dic
                           startImmediately:YES // 5
                       configurationHandler:^(MGJRequestManagerConfiguration *configuration){
                           
                       } completionHandler:^(NSError *error, id<NSObject> result, BOOL isFromCache, AFHTTPRequestOperation *operation) {
                           [self hideCustomLodingUI];
                           if (error) {
                               [self showPromptTextUIWithPromptText:@"提交失败" title:nil andDuration:2 andposition: CSToastPositionCenter];
                               return ;
                           }
                           NSDictionary *resDic =  (NSDictionary*)result;
                           if (((NSString*)[resDic objectForKey:@"msg"]).length) {
                               [self showCommitSucessMsg:(NSString*)[resDic objectForKey:@"msg"]];
                           }
                       }];
    
}
#pragma mark - 图片手势
- (void)tap
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.logourl]];
}

- (void)showCustomLoadingUI
{
    self.hud = ({
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.color = [UIColor colorWithWhite:0.750 alpha:1.000];
        hud.labelText = @"提交中";
        hud.dimBackground  =YES;
        hud;
    });
}
- (void)hideCustomLodingUI
{    self.hud.labelText = @"提交成功";
    [self.hud hide:YES afterDelay:0];
}

- (void)showCommitSucessMsg:(NSString*)message
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}




- (NSDictionary*)getDeviceInfo
{
    NSString *UUID          = [KeychainUUID value];//设备唯一ID
    NSString *deviceModel   = [UIDevice currentDevice].model;//品牌
    NSString *systemName    = [UIDevice currentDevice].systemName;//系统名称
    NSString *systemVersion = [UIDevice currentDevice].systemVersion;//系统版本
    NSString *platform      = [self currentDevicePlatform];//平台号
    NSString *deviceName    = [self currentDeviceModelName];//品牌具体型号
    
    NSDictionary *dic  = @{@"model":deviceModel,
                           @"UUID":UUID,
                           @"systemName":systemName,
                           @"systemVersion":systemVersion,
                           @"platform":platform,
                           @"deviceName":deviceName,
                           };
    
    return dic;
}
- (NSString*)currentDeviceModelName
{
    NSString *platform = [self currentDevicePlatform];
    //*****************************iPhone******************************//
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
    
    //*****************************iPod******************************//
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
    
    //*****************************iPad******************************//
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G (A1219/A1337)";
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490)";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";
    //*****************************模拟器******************************//
    if ([platform hasSuffix:@"i386"] || [platform isEqual:@"x86_64"])
    {
        BOOL smallerScreen = [[UIScreen mainScreen] bounds].size.width < 768;
        return smallerScreen ? @"iPhone Simulator" : @"iPad Simulator";
    }
    return platform;
    
}
//获得设备平台号
- (NSString *)currentDevicePlatform
{
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    return platform;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
