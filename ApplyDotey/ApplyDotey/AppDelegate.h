//
//  AppDelegate.h
//  ApplyDotey
//
//  Created by dengyanzhou on 15/9/1.
//  Copyright (c) 2015年 YiXingLvDong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/**网络监听者*/
@property (nonatomic, strong) Reachability *reach;
- (void)startNetListen;
@end

