//
//  BaseViewController.h
//  BaseViewController
//
//  Created by dengyanzhou on 15/8/27.
//  Copyright (c) 2015年 YiXingLvDong. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "UIView+Toast.h"
/**
 *  网络加载等待类型
 */
typedef NS_ENUM(NSUInteger,NetWorkLoadType) {
    NetWorkLoadTypeDefault = 1,
    NetWorkLoadTypeImageAnimation,
    NetWorkLoadTypeImageAnimationAndPromptText,
};
/**
 *  网络加载呈现的UI
 */
@interface NetWorkLoadIngView : UIView
/**动画数组*/
@property (nonatomic, strong) NSArray                 *imageAnimationArray;
/**activity*/
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
/**动画imageView*/
@property (nonatomic, strong) UIImageView             *imageView;
/**当前的网络加载UI*/
@property (nonatomic, assign) NetWorkLoadType         netWorkLoadType;
//加载时文字提示
@property (nonatomic, strong) UILabel                 *promptLabel;
@end

/**
 *  网络变化呈现的UI 可Custom by yourself
 */
@interface NetWorkChangeView: UIButton
@end


/**
 * 屏幕适配的两种方法
 */
typedef NS_ENUM(NSUInteger, FitViewType){
    FitViewTypeDefault = 0,
    FitViewTypeEdgesExtended
};

@interface BaseViewController : UIViewController

/**全屏布局视图开始的Y值*/
@property (nonatomic, assign,readonly) CGFloat viewToTop;
/**全局布局视图结束的Y值*/
@property (nonatomic, assign,readonly) CGFloat viewToBottom;
/**哪种适配方式,子类重写,默认是第一种*/
@property (nonatomic, assign) FitViewType  fitViewType;
/**标示当前有没有网络,每次请求接口时都要判断当期网络是否可用*/
/**只有开启了网络监听此变量才有效*/
@property (nonatomic, assign,readonly) BOOL netIsUse;
/**适配条件 留个接口子类继承重写*/
- (void)fitCondition;//填充适配的条件eg:导航条是否隐藏,导航条是否透明 tabBar是否隐藏

//*****************************网络加载UI******************************//
@property (nonatomic,strong) NetWorkLoadIngView *netWorkLoadIngView;
/**
 *  显示默认的网络加载
 */
- (void)showLoadingUI;
/**
 *  显示网络加载UI
 *
 *  @param netWorkLoadType     网络加载UI类型
 *  @param imageAnimationArray 动画数组
 *  @param promptText          提示文本
 */
- (void)showLoadingUIWithNetWorkLoadType:(NetWorkLoadType)netWorkLoadType
                        andImageAnimation:(NSArray*)imageAnimationArray
                            andPromptText:(NSString*)promptText;
- (void)hideLoadingUI;
/**留个接口让子类自己定义自己的网络加载UI*/
- (void)showCustomLoadingUI;
/**
 * 提示文本UI 一会自动隐藏
 *
 *  @param PromptText 提示的文本
 *  @param interval   多长时间以后自动隐藏
 */

//*****************************页面文本提示******************************//
/**
 *  显示Toast
 *
 *  @param promptText 显示的提示文本
 *  @param title      标题
 *  @param interval   显示时间
 *  @param position   显示的位置
 */
- (void)showPromptTextUIWithPromptText:(NSString *)promptText
                                 title:(NSString*)title
                           andDuration:(NSTimeInterval)interval
                           andposition:(NSString*)position;
/**
 *  显示警告框
 *
 *  @param message  警告框内容
 *  @param title    警告框内容
 *  @param delegate 警告框的代理
 */
- (void)showAlertViewWithMessage:(NSString*)message
                        andTitle:(NSString*)title
                     andDelegate:(id<UIAlertViewDelegate>)delegate;

//***网络监听UI-监听网络变化 在ViewWillAppear开启 在viewWillDisAppear在关闭**//
/**是否监听网络变化*/
@property (nonatomic, assign) BOOL isOpenNetListen;
/**
 *  网络变化的回调
 *
 *  @param note reach发来的消息
 */
- (void)reachabilityChanged:(NSNotification *)note;
/**
 *  网络不可以用时点击UI的回调-默认点击是打开系统系统设置页面
 *
 *  @param sender button
 */
- (void)goNetNotUse:(UIButton*)sender;

@end
