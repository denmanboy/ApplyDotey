//
//  AppDelegate.m
//  ApplyDotey
//
//  Created by dengyanzhou on 15/9/1.
//  Copyright (c) 2015年 YiXingLvDong. All rights reserved.
//

#import "AppDelegate.h"
#import "MyNavigationViewController.h"
#import "RootViewController.h"
#import "IQKeyboardManager.h"
#import "MobClick.h"
#import "KeychainUUID.h"
#include <sys/types.h>
#include <sys/sysctl.h>
@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    MyNavigationViewController *naViCtrl = [[MyNavigationViewController alloc]initWithRootViewController:[[RootViewController alloc]init]];
    _window.rootViewController = naViCtrl;
    [_window makeKeyAndVisible];

    //*****************************配置信息******************************//
    [self configKeyBoard];//配置键盘
    [self startNetListen];//网络监听
    [self configAnalytics];//UMeng统计
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)startNetListen
{
    //开起监听
    [self.reach startNotifier];
    
}
- (Reachability *)reach
{
    if (!_reach) {
        self.reach = ({
            Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
            reach;
        });
    }
    return _reach;
}
- (void)configKeyBoard
{
    //键盘控制
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    [[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarBySubviews];
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    [[IQKeyboardManager sharedManager] setCanAdjustTextView:YES];
    [[IQKeyboardManager sharedManager] setShouldShowTextFieldPlaceholder:YES];
}

#pragma mark -  配置友盟统计
-  (void)configAnalytics
{
    //配置友盟统计 发布渠道 默认appstore  reportPolicy 上报策略
    [MobClick startWithAppkey:@"55e578a767e58e95ec000df0 " reportPolicy:BATCH channelId:nil];
    //配置版本号
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    //设置后台模式，保存日志
    [MobClick setBackgroundTaskEnabled:YES];
    //开启友盟错误分析功能
    [MobClick setCrashReportEnabled:YES];
    //开发模式下 开启log日志
#ifdef DEBUG
    [MobClick setLogEnabled:YES];
#endif
    
}
#pragma mark - 后去手机机型 imei imsi
//- (void)commitIphoneInfo
//{
//    NSString *UUID          = [KeychainUUID value];//设备唯一ID
//    NSString *deviceModel   = [UIDevice currentDevice].model;//品牌
//    NSString *systemName    = [UIDevice currentDevice].systemName;//系统名称
//    NSString *systemVersion = [UIDevice currentDevice].systemVersion;//系统版本
//    NSString *platform      = [self currentDevicePlatform];//平台号
//    NSString *deviceName    = [self currentDeviceModelName];//品牌具体型号
//    
//    
//    NSDictionary *dic  = @{@"model":deviceModel,
//                           @"UUID":UUID,
//                           @"systemName":systemName,
//                           @"systemVersion":systemVersion,
//                           @"platform":platform,
//                           @"deviceName":deviceName,
//                           };
//    [[MGJRequestManager sharedInstance] GET:@"http://shufaba.net/sqb/m/"
//                                 parameters:dic
//                           startImmediately:YES // 5
//                       configurationHandler:^(MGJRequestManagerConfiguration *configuration){
//                       } completionHandler:^(NSError *error, id<NSObject> result, BOOL isFromCache, AFHTTPRequestOperation *operation) {
//                           
//                           if (error) {
//                               return ;
//                               
//                           }else
//                           {
//                               NSLog(@"result = %@",result);
//                               
//                           }
//                       }
//     ];
//}

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
- (NSString*)currentDeviceModelNum
{
    
    return @"";
    
}

//获取imei
- (NSString*)imei
{
    
    
    return nil;
}
//获取imsi
- (NSString*)imsi
{
    
    
    return nil;
}

@end
