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
