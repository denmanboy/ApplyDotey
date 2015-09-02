//
//  BaseViewController.m
//  BaseViewController
//
//  Created by dengyanzhou on 15/8/27.
//  Copyright (c) 2015年 YiXingLvDong. All rights reserved.
//

#import "BaseViewController.h"
#import "Reachability.h"
#import "AppDelegate.h"

/**
 *  定制网络加载UI
 */
@implementation NetWorkLoadIngView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor whiteColor];
        self.alpha = 1;
    }
    return self;
};
- (void)netLoadIngType:(NetWorkLoadType)netWorkLoadType andImageAnimation:(NSArray *)imageAnimationArray
         andPromptText:(NSString *)promptText
{   self.hidden = NO;
    self.alpha = 1;
    //相同类型 直接返回
    if (self.netWorkLoadType  == netWorkLoadType) {
        return;
    }else{
        [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [(UIView*)obj removeFromSuperview];
        }];
    }
    switch (netWorkLoadType) {
        case NetWorkLoadTypeDefault: {
            self.indicatorView.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
            [self addSubview:self.indicatorView];
            
            if (!promptText.length) {
                promptText = @"加载中";
            }
            self.promptLabel.text = promptText;
            [self.promptLabel sizeToFit];
            self.promptLabel.center = CGPointMake(self.indicatorView.center.x,CGRectGetMaxY(self.indicatorView.frame) + 10 );
            [self addSubview:self.promptLabel];
        }break;
        case NetWorkLoadTypeImageAnimation: {
            if (!imageAnimationArray.count) {
                return;
            }
            self.imageView.frame = CGRectMake(0, 0, ((UIImage*)[imageAnimationArray firstObject]).size.width, ((UIImage*)[imageAnimationArray firstObject]).size.height);
            self.imageView.animationImages = imageAnimationArray;
            self.imageView.center =  CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
            [self addSubview:self.imageView];
        } break;
        case NetWorkLoadTypeImageAnimationAndPromptText: {
            if (!imageAnimationArray.count) {
                return;
            }
            self.imageView.frame = CGRectMake(0, 0, ((UIImage*)[imageAnimationArray firstObject]).size.width, ((UIImage*)[imageAnimationArray firstObject]).size.height);
            self.imageView.animationImages = imageAnimationArray;
            self.imageView.center =  CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
            [self addSubview:self.imageView];
            if (!promptText.length) {
                promptText = @"加载中";
            }
            self.promptLabel.text = promptText;
            self.promptLabel.textAlignment = NSTextAlignmentCenter;
            [self.promptLabel sizeToFit];
            self.promptLabel.center = CGPointMake(self.imageView.center.x, CGRectGetMaxY(self.imageView.frame) + 10);
            [self addSubview:self.promptLabel];
        } break;
        default: {
            
        }break;
    }
}
/**
 *  懒加载网络加载UI
 *
 *  @return
 */
- (UIActivityIndicatorView *)indicatorView
{
    if (!_indicatorView) {
        self.indicatorView = ({
            UIActivityIndicatorView  *indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            indicatorView;
        });
    }
    return _indicatorView;
}
/**
 *  懒加载
 *
 *  @return 文字提示label
 */
- (UILabel *)promptLabel
{
    if (!_promptLabel) {
        self.promptLabel = ({
            UILabel *lable = [[UILabel alloc]init];
            lable.textAlignment = NSTextAlignmentCenter;
            lable.textColor = [UIColor redColor];
            lable.font = [UIFont boldSystemFontOfSize:14];
            lable;
        });
    }
    return _promptLabel;
}
/**
 *  懒加载
 *
 *  @return 产生动画的imageView
 */
- (UIImageView *)imageView
{
    if (!_imageView) {
        self.imageView = ({
            UIImageView *imageView = [[UIImageView alloc]init];
            imageView.animationRepeatCount = 0;
            imageView.animationDuration = 1;
            imageView;
        });
    }
    return _imageView;
}

/**
 *  可用CG 画图
 *  @param rect <#rect description#>
 */
- (void)drawRect:(CGRect)rect
{
}
@end

/**
 *  定制网络变化UI
 */
@implementation NetWorkChangeView
@end

@interface BaseViewController ()
/**头部网络变化UI*/
@property (nonatomic,strong) NetWorkChangeView  *netWorkChageView;
@property (nonatomic,strong) NetWorkLoadIngView *netWorkLoadIngView;
@end

@implementation BaseViewController
@synthesize fitViewType     = _fitViewType ;
@synthesize viewToTop       = _viewToTop;
@synthesize viewToBottom    = _viewToBottom;
@synthesize isOpenNetListen = _isOpenNetListen;
@synthesize netIsUse = _netIsUse;

#pragma mark - lifecycle

//内存移除
- (void)dealloc
{
}
//加载视图
- (void)loadView
{
    [super loadView];
    //自定制视图
}
//加载视图完毕
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self fitViewWithFitViewType:self.fitViewType];
    // Do any additional setup after loading the view, typically from a nib.
}
//视图将要出现
- (void)viewWillAppear:(BOOL)animated
{
    
}
//视图已经出现
- (void)viewDidAppear:(BOOL)animated
{
}
//视图将要消失
- (void)viewWillDisappear:(BOOL)animated
{ self.isOpenNetListen = NO;
}
//视图已经消失
- (void)viewDidDisappear:(BOOL)animated
{
}
//收到系统内存警告
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**适配带导航和不带导航--带tabBar和不带tarbar的 self.view的布局*/
- (void)fitViewWithFitViewType:(FitViewType)fitViewType
{   //填充适配条件
    [self fitCondition];
    //自动调整Insets关闭
    self.automaticallyAdjustsScrollViewInsets = NO;
    //*****************************第一种方法******************************//
    if (fitViewType == FitViewTypeDefault) {
        //当前的容器为导航控制器
        if (self.navigationController && self.navigationController.tabBarController == nil) {
            _viewToBottom = 0;
            //导航条隐藏
            if (self.navigationController.isNavigationBarHidden) {
                _viewToTop = 20;
            //导航条显示
            }else{
                //导航条透明
                if (self.navigationController.navigationBar.isTranslucent) {
                    _viewToTop = 20;
                //判断有没有背景图片
                UIImage *image = [self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault];
                    if (image) {
                        _viewToTop = 64;
                    }
                //导航条不透明
                }else{
                    self.extendedLayoutIncludesOpaqueBars = YES;
                    _viewToTop = 64;
                }
            }
        //当前的容器是tabBar控制器
        }else if (self.navigationController == nil && self.tabBarController){
            _viewToTop = 20;
            //tabBar隐藏
            if (self.tabBarController.tabBar.isHidden) {
                _viewToBottom = 0;
            //tabBar显示
            }else{
                _viewToBottom = 49;
            }
        //当前容器的容器是tabBar的控制器
        }else if (self.navigationController && self.navigationController.tabBarController){
            
            //导航条显示 tabBar显示
            if (self.navigationController.isNavigationBarHidden == NO
                && self.navigationController.tabBarController.tabBar.isHidden == NO && self.hidesBottomBarWhenPushed == NO) {
                _viewToBottom =  49;
                //导航条透明
                if (self.navigationController.navigationBar.isTranslucent) {
                    _viewToTop = 20;
                    //判断有没有背景图片
                    UIImage *image = [self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault];
                    if (image) {
                        _viewToTop = 64;
                    }
                }else{
                    self.extendedLayoutIncludesOpaqueBars = YES;
                    _viewToTop = 64;
                }
            //导航条隐藏 tarBar隐藏
            }else if (self.navigationController.isNavigationBarHidden
                      && (self.navigationController.tabBarController.tabBar.isHidden | self.hidesBottomBarWhenPushed)){
                
                _viewToTop = 20;
                _viewToBottom = 0;
                
            //导航条显示 tarBar隐藏
            }else if (self.navigationController.isNavigationBarHidden == NO
                      && (self.tabBarController.tabBar.isHidden
                          || self.hidesBottomBarWhenPushed)){
                          //导航条透明
                          if (self.navigationController.navigationBar.isTranslucent) {
                              _viewToTop = 20;
                              //判断有没有背景图片
                              UIImage *image = [self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault];
                              if (image) {
                                  _viewToTop = 64;
                              }
                          }else{
                              self.extendedLayoutIncludesOpaqueBars = YES;
                              _viewToTop = 64;
                          }
                          _viewToBottom = 0;
                          //导航条隐藏 tabBar显示
                      }else{
                          
                          _viewToTop = 20;
                          _viewToBottom = 49;
                      }
        //当前没有容器
        }else{
            _viewToTop =  20;
            _viewToBottom = 0;
        }
        //*****************************第二种方法******************************//
    }else{
        
         _viewToBottom = 0;
        //1当前的容器是导航控制器
        if (self.navigationController && self.navigationController.tabBarController == nil) {
            
            //导航条隐藏
            if (self.navigationController.navigationBarHidden) {
                self.edgesForExtendedLayout = UIRectEdgeAll;
                self.extendedLayoutIncludesOpaqueBars = YES;
                _viewToTop =  20;

            //导航条没有隐藏
            }else{
                //导航条透明
                if (self.navigationController.navigationBar.isTranslucent) {
                    self.edgesForExtendedLayout = UIRectEdgeAll;
                    self.extendedLayoutIncludesOpaqueBars = YES;
                    _viewToTop = 20;
                //导航条不透明
                }else{
                    self.edgesForExtendedLayout = UIRectEdgeLeft | UIRectEdgeRight |  UIRectEdgeBottom;
                    self.extendedLayoutIncludesOpaqueBars = NO;
                    _viewToTop = 0;
                }
            }
        //2当前容器的容器是TabBarController
        }else if (self.navigationController && self.navigationController.tabBarController){
            
            //*****************************start******************************//
            //1）导航条显示 tabBar显示
            if (self.navigationController.isNavigationBarHidden == NO
                && self.navigationController.tabBarController.tabBar.isHidden == NO) {
                //导航条透明
                if (self.navigationController.navigationBar.isTranslucent) {
                    self.edgesForExtendedLayout = UIRectEdgeLeft | UIRectEdgeRight |UIRectEdgeTop;
                    self.extendedLayoutIncludesOpaqueBars = YES;
                    _viewToTop = 20;
                }else{
                    self.edgesForExtendedLayout = UIRectEdgeLeft | UIRectEdgeRight ;
                    self.extendedLayoutIncludesOpaqueBars = NO;
                    _viewToTop = 0;
                }
            //2）导航条显示 tabBar隐藏
            }else if (self.navigationController.isNavigationBarHidden == NO
                      && (self.navigationController.tabBarController.tabBar.hidden
                          || self.hidesBottomBarWhenPushed)){
                          
                          //导航条透明
                          if (self.navigationController.navigationBar.isTranslucent) {
                              self.edgesForExtendedLayout = UIRectEdgeAll;
                              self.extendedLayoutIncludesOpaqueBars = YES;
                              _viewToTop = 20;
                          //导航条不透明
                          }else{
                              self.edgesForExtendedLayout = UIRectEdgeLeft | UIRectEdgeRight | UIRectEdgeBottom;
                              self.extendedLayoutIncludesOpaqueBars = NO;
                              _viewToTop = 0;
                          }
            //3）导航条隐藏 tabBar显示
            }else if (self.navigationController.isNavigationBarHidden
                                && (self.navigationController.tabBarController.tabBar.isHidden == NO
                                    || self.hidesBottomBarWhenPushed == NO)){
                                    self.edgesForExtendedLayout = UIRectEdgeTop | UIRectEdgeLeft | UIRectEdgeRight;
                                    self.extendedLayoutIncludesOpaqueBars= YES;
                                    _viewToTop = 20;
            //4）导航条隐藏 taBar隐藏
            }else{
                self.edgesForExtendedLayout = UIRectEdgeAll;
                _viewToTop = 20;
            }
            //*****************************end******************************//
            
        //3当前的容器tarBarController
        }else if (self.navigationController == nil && self.tabBarController){
            //tabBar隐藏
            if (self.tabBarController.tabBar.isHidden ) {
                self.edgesForExtendedLayout = UIRectEdgeAll;
            //tabBar显示
            }else{
                self.edgesForExtendedLayout = UIRectEdgeRight | UIRectEdgeLeft | UIRectEdgeTop;
            }
            _viewToTop = 20;
        //4没有容器
        }else{
            self.edgesForExtendedLayout = UIRectEdgeAll;
            self.extendedLayoutIncludesOpaqueBars = YES;
            _viewToTop = 20;
        }
    }
}

#pragma mark - 适配条件 留个接口子类继承重写
- (void)fitCondition
{
  //TODO: 子类重写
}
- (FitViewType)fitViewType
{
    _fitViewType = FitViewTypeDefault;
    return _fitViewType;
    //TODO: 子类需要哪种就写哪种 默认是第一种
}

#pragma mark - 网络加载UI
- (void)showLoadingUI
{
    [self showLoadingUIWithNetWorkLoadType:NetWorkLoadTypeDefault andImageAnimation:nil andPromptText:nil];
}
- (void)showLoadingUIWithNetWorkLoadType:(NetWorkLoadType)netWorkLoadType
                       andImageAnimation:(NSArray *)imageAnimationArray
                           andPromptText:(NSString *)promptText
{
    [self.netWorkLoadIngView netLoadIngType:netWorkLoadType andImageAnimation:imageAnimationArray andPromptText:promptText];
    switch (netWorkLoadType) {
        case NetWorkLoadTypeDefault: {
            [self.netWorkLoadIngView.indicatorView startAnimating];
            break;
        }
        case NetWorkLoadTypeImageAnimation: {
        }
        case NetWorkLoadTypeImageAnimationAndPromptText: {
            [self.netWorkLoadIngView.imageView startAnimating];
        }
            break;
        default: {
            break;
        }
    }
}
/**留个接口子类自定义*/
- (void)showCustomLoadingUI
{
}
- (void)hideLoadingUI
{
    if (_netWorkLoadIngView && !_netWorkLoadIngView.hidden) {
        [UIView animateWithDuration:0.3 animations:^{
            self.netWorkLoadIngView.alpha = 0;
        } completion:^(BOOL finished) {
            if (self.netWorkLoadIngView.netWorkLoadType == NetWorkLoadTypeDefault) {
                [self.netWorkLoadIngView.indicatorView stopAnimating];
            }else{
                [self.netWorkLoadIngView.imageView stopAnimating];
            }
            self.netWorkLoadIngView.hidden = YES;
        }];
    }
}

#pragma mark - 消息提示
- (void)showPromptTextUIWithPromptText:(NSString *)promptText
                                 title:(NSString*)title
                           andDuration:(NSTimeInterval)interval
                           andposition:(NSString*)position
{
    if (interval == 0) {
        interval = 3;
    }
    if (!promptText.length) {
        promptText = @"加载中";
    }
    if (!position.length) {
        position = CSToastPositionBottom;
    }
    [self.view makeToast:promptText
                duration:interval
                position:position
                   title:title];

}
- (void)showAlertViewWithMessage:(NSString *)message
                        andTitle:(NSString *)title
                     andDelegate:(id<UIAlertViewDelegate>)delegate
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title
                                                       message:message
                                                      delegate:delegate
                                             cancelButtonTitle:@"取消"
                                             otherButtonTitles:@"确定", nil];
    [alertView show];
}
#pragma mark - 打开网络监听or关闭网络监听
- (void)setIsOpenNetListen:(BOOL)isOpenNetListen
{   _isOpenNetListen = isOpenNetListen;
    if (_isOpenNetListen) {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification object:nil];
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        //在appDelegate中监测网络变化 刚打开应用时网络变化 self还没被实例化 因此收不到网络变化 必须强制 监测一下
        //网络可用不显示 不可用显示
        if ([appDelegate.reach currentReachabilityStatus] ==  NotReachable) {
               [self netWorkChange:appDelegate.reach];
        }
    }else{
        //移除网络监听
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kReachabilityChangedNotification
                                                  object:nil];
        if (!_netWorkChageView) {
            [_netWorkChageView removeFromSuperview];
            _netWorkChageView = nil;
        }
    }
}
- (void)reachabilityChanged:(NSNotification *)note
{
    Reachability *curReach = [note object];
    [self netWorkChange:curReach];
}
- (void)netWorkChange:(Reachability*)curReach
{
    switch ([curReach currentReachabilityStatus]) {
        case NotReachable:{
            [self.netWorkChageView setTitle:@"网络不可用,亲 ->点击设置网络连接!" forState:UIControlStateNormal];
            _netIsUse = NO;
        }break;
        case ReachableViaWiFi:{ //wifi he WWAN一样
        }
        case ReachableViaWWAN:{
            [self.netWorkChageView setTitle:@"网络已链接^^!" forState:UIControlStateNormal];
            //网络可用不用点击
            self.netWorkChageView.enabled = NO;
            [UIView animateWithDuration:1.5f animations:^{
                self.netWorkChageView.alpha = 0;
            } completion:^(BOOL finished) {
                self.netWorkChageView.hidden= YES;
            }];
            _netIsUse = YES;
        }break;
        default:{
            
        }break;
    }
}
/**网络变化UI*/
- (NetWorkChangeView *)netWorkChageView
{
    if (!_netWorkChageView) {
        //判断当前的容器为导航控制器
        CGFloat start_Y = 64;
        if (self.navigationController) {
            //导航控制器隐藏
            if (self.navigationController.isNavigationBarHidden) {
                start_Y = 20;
            }
            //当前的容器不是导航控制器
        }else{
            start_Y = 20;
        }
        self.netWorkChageView = ({
            NetWorkChangeView *changeView = [NetWorkChangeView buttonWithType:UIButtonTypeCustom];
            changeView.frame = CGRectMake(0, start_Y, self.view.frame.size.width, 30);
            changeView.layer.borderColor =  [UIColor purpleColor].CGColor;
            changeView.layer.borderWidth = 1;
            changeView.backgroundColor = [UIColor colorWithRed:1.000 green:0.983 blue:0.530 alpha:1.000];
            changeView.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            [changeView addTarget:self
                           action:@selector(goNetNotUse:)
                 forControlEvents:UIControlEventTouchUpInside];
            [changeView setTitleColor:[UIColor redColor]
                             forState:UIControlStateNormal];
            [self.view addSubview:changeView];
            [self.view bringSubviewToFront:changeView];
            changeView;
        });
    }
    _netWorkChageView.alpha = 1;
    _netWorkChageView.hidden =  NO;
    _netWorkChageView.enabled = YES;
    return _netWorkChageView;
}
/**网络加载UI*/
- (NetWorkLoadIngView *)netWorkLoadIngView
{
    if (!_netWorkLoadIngView) {
        self.netWorkLoadIngView = ({
            NetWorkLoadIngView *loadIngView  =[[NetWorkLoadIngView alloc]initWithFrame:CGRectMake(0, _viewToTop, self.view.frame.size.width, self.view.frame.size.height - _viewToTop - _viewToBottom)];
            [self.view addSubview:loadIngView];
            loadIngView;
        });
    }
    return _netWorkLoadIngView;
}
#pragma mark - 网络不可用点击UI的回调
- (void)goNetNotUse:(UIButton *)sender
{
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

@end

