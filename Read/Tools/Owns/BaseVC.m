//
//  BaseVC.m
//
//
//  Created by wuyj on 14-12-8.
//  Copyright (c) 2014年 伍友健. All rights reserved.
//

#import "BaseVC.h"
#import "DeviceInfo.h"
#import "UIColor+Utility.h"


#define IS_IOS7 ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue]>=7)

@interface BaseVC ()<UIGestureRecognizerDelegate>
@property (nonatomic,strong) UIView *contentView;
@end

@implementation BaseVC

- (void)setContentViewBackgroundColor:(UIColor*)color {
    [_contentView setBackgroundColor:color];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self unRegieditKeyboardNotification];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self regieditKeyboardNotification];
    
    NSNumber *orientationUnknown = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
    [[UIDevice currentDevice] setValue:orientationUnknown forKey:@"orientation"];
    
    NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    if (IS_IOS7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
    }
    
    //self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [_contentView setBackgroundColor:[UIColor colorWithHex:0xebeef0]];
    [self.view addSubview:_contentView];
    
    
    // 默认增加back 按钮
    if (self.navigationController && [[self.navigationController.viewControllers firstObject] isEqual:self]) {
        
    } else {
        [self configBackButton];
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didEnterBackgroundNotification:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
}


- (void)unRegieditKeyboardNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)regieditKeyboardNotification {
    [self unRegieditKeyboardNotification];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

// 默认不支持旋转
-(BOOL)shouldAutorotate {
    return NO;
}

//默认支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - keyboard Notification
-(void)keyboardWillShow:(NSNotification *)note{}
-(void)keyboardDidShow:(NSNotification *)note{}
-(void)keyboardWillHide:(NSNotification *)note{}

-(void)didEnterBackgroundNotification:(NSNotification *)note {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setNavTitle:(NSString*)title {
    UILabel* label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    label.backgroundColor=[UIColor clearColor];
    label.font = [UIFont systemFontOfSize:18];
    label.textColor = [UIColor blackColor];
    label.text=title;
    label.textAlignment=NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
    
    //self.title = title;
}

- (void)setNavTitle:(NSString*)title titleColor:(UIColor *)color {
    UILabel* label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    label.backgroundColor=[UIColor clearColor];
    label.font = [UIFont systemFontOfSize:24];
    label.textColor = color;
    label.text = title;
    label.textAlignment=NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
    
    //self.title = title;
}

// 从矢量图加载图片
- (UIImage *)roadVectorImageWithName:(NSString *)name {
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    UIImage *image = [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
    return image;
}

#pragma mark - Config Top Bar Button
- (UIBarButtonItem*)configBackButton {
    UIBarButtonItem *itemBtn = [[UIBarButtonItem alloc] initWithImage:[[self roadVectorImageWithName:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]style:UIBarButtonItemStylePlain target:self action:@selector(popBack)];
    
    self.navigationItem.leftBarButtonItem = itemBtn;
    return itemBtn;
}

- (void)popBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIButton*)configRightBarButtonWithImage:(UIImage*)image selectImage:(UIImage*)selectIamge target:(id)target selector:(SEL)selector frame:(CGRect)frame {
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:selectIamge forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor colorWithHex:kGlobalGreenColor] forState:UIControlStateNormal];
    button.frame = frame;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return button;
}

- (UIButton*)configLeftBarButtonWithImage:(UIImage*)image selectImage:(UIImage*)selectIamge target:(id)target selector:(SEL)selector {
    
    UIButton* button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:selectIamge forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor colorWithHex:kGlobalGreenColor] forState:UIControlStateNormal];
    button.frame=CGRectMake(0, 0, 24, 24);
    self.navigationItem.leftBarButtonItem= [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return button;
}

- (UIBarButtonItem*)configBarButtonWithTitle:(NSString*)title titleTextAttributes:(NSDictionary*)attrDic target:(id)target selector:(SEL)selector {
    
    UIBarButtonItem *itemBtn = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:selector];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          [UIColor colorWithHex:kGlobalGreenColor],NSForegroundColorAttributeName,
                          [UIFont systemFontOfSize:15],NSFontAttributeName,nil];
    [itemBtn setTitleTextAttributes:dict forState:UIControlStateNormal];
    
    return itemBtn;
}

- (UIBarButtonItem*)configBarButtonWithTitle:(NSString*)title target:(id)target selector:(SEL)selector {
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          [UIColor colorWithHex:kGlobalGreenColor],NSForegroundColorAttributeName,
                          [UIFont systemFontOfSize:15],NSFontAttributeName,nil];
    return [self configBarButtonWithTitle:title titleTextAttributes:dict target:target selector:selector];
}

- (void)configRightBarButtonWithCustomView:(UIView*)aView {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:aView];
}

- (void)configLeftBarButtonWithCustomView:(UIView*)aView {
    self.navigationItem.leftBarButtonItem= [[UIBarButtonItem alloc] initWithCustomView:aView];
}

- (void)configTitleWithImage:(NSString*)imagename {
    UIImageView *titleimage= [[UIImageView alloc] initWithImage:[UIImage imageNamed:imagename]];
    [titleimage sizeToFit];
    self.navigationItem.titleView = titleimage;
}




@end
