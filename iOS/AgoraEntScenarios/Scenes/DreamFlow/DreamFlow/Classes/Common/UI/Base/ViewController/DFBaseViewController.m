//
//  DFBaseViewController.m
//  VoiceOnLine
//

#import "DFBaseViewController.h"
#import "DFMacroDefine.h"
#import "DFHotSpotBtn.h"
#import "AESMacro.h"
#import "DFQMUICommonDefines.h"
#import "DreamFlow/DreamFlow-Swift.h"

@interface DFBaseViewController ()

@property (nonatomic, strong) UIImageView *backGroundImgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) DFHotSpotBtn *backBtn;

@end

@implementation DFBaseViewController

- (void)dealloc {
    [self hideVLEmptyView];
    DFLog(@"dealloc == %@",self.class);
}

- (void)updateNavigationBarAppearance {
    
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    if (!navigationBar) return;
    
    [navigationBar setBackgroundColor:[UIColor whiteColor]];
    navigationBar.barTintColor = [UIColor whiteColor];
    navigationBar.barStyle = UIBarStyleDefault;
    navigationBar.tintColor = [UIColor blackColor];
//    self.titleView.tintColor = [UIColor blackColor];
}

#pragma mark - Life Cycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self updateNavigationBarAppearance];
}

#pragma mark - Intial Methods
- (void)initSubviews {
//    [super initSubviews];
    [self.view setBackgroundColor:UIColorMakeWithHex(@"#FFFFFF")];
}
#pragma mark - Events
- (void)leftButtonDidClickAction {
    if ([self.navigationController.viewControllers count] > 1) {
        [self.navigationController popViewControllerAnimated:true];
    } else {
        [self dismissViewControllerAnimated:true completion:^{
        }];
    }
}

#pragma mark - Public Methods
- (void)hideVLEmptyView {
    if (_vlEmptyView && _vlEmptyView.superview) {
        [self.vlEmptyView removeFromSuperview];
    }
}

- (void)backBtnClickEvent {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setBackgroundImage:(NSString *)imageName {
    [self.view addSubview:self.backGroundImgView];
    self.backGroundImgView.image = DFUIImageMake(imageName);

//    self.backGroundImgView.image = DFUIImageMake(imageName) ? : [UIImage sceneImageWithName:imageName];
}

//背景图
- (void)setBackgroundImage:(NSString *)imageName bundleName:(NSString *)name{
    [self.view addSubview:self.backGroundImgView];
    self.backGroundImgView.image = DFUIImageMake(imageName);

//    self.backGroundImgView.image = DFUIImageMake(imageName) ? : [UIImage sceneImageWithName:imageName bundleName:name];
}

- (void)setNaviTitleName:(NSString *)titleStr {
    [self.view addSubview:self.titleLabel];
    self.titleLabel.text = titleStr;
}

- (void)setBackBtn {
    [self.view addSubview:self.backBtn];
}

- (void)configNavigationBar:(UINavigationBar *)navigationBar {
    
}
#pragma mark - Private Method
- (void)setupNavigationItems {
//    [super setupNavigationItems];
    [self configNavigationBar:self.navigationController.navigationBar];
}
- (void)accordingWithNaviBarBtn:(VLNavigationBarStatus)btnStatus
              withBarButtonItem:(UIBarButtonItem *)btnItem {
    
    if (btnStatus == VLNavigationBarStatusLeft) {
        [self.navigationItem setLeftBarButtonItem:btnItem];
    } else {
        [self.navigationItem setRightBarButtonItem:btnItem];
    }
}
#pragma mark - QMUINavigationControllerDelegate
//- (UIColor *)navigationBarTintColor {
//    return UIColorMakeWithHex(@"#0E0E0E");
//}
- (UIImage *)qmui_navigationBarBackgroundImage {
    return DFUIImageMake(@"navigationbar_background");
}
- (BOOL)shouldCustomizeNavigationBarTransitionIfHideable {
    return true;
}
- (BOOL)preferredNavigationBarHidden {
    return false;
}

- (UIImage *)navigationBarShadowImage {

    return [self navigationBarCuttingLine] ? DFUIImageMake(@"nav_line") : [UIImage imageWithColor:[UIColor clearColor]];
}
- (BOOL)navigationBarCuttingLine {
    return false;
}
// Whether to allow manual sliding back to @return true Yes, false no
- (BOOL)forceEnableInteractivePopGestureRecognizer {
    return true;
}
#pragma mark - HomeIndicator
- (BOOL)prefersHomeIndicatorAutoHidden {
    return false;
}
/**
 In info.plist, the View controller-based status bar appearance item is set to YES.
 The setting of the status bar by the View controller takes precedence over the setting of the application.
 The prefersStatusBarHidden method of the view controller is invalid and will not be called at all.
 
 @return true false
 */
- (BOOL)prefersStatusBarHidden {
    return false;
}
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

- (void)didInitialize {
//    [super didInitialize];
//    self.supportedOrientationMask = UIInterfaceOrientationMaskPortrait;
}

#pragma mark – Getters and Setters
- (UIImageView *)backGroundImgView {
    if (!_backGroundImgView) {
        _backGroundImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
        _backGroundImgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _backGroundImgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.view.width-200)*0.5, DFkStatusBarHeight, 200, 40)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC" size:18];
        _titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
        _titleLabel.textColor = UIColorMakeWithHex(@"#040925");
    }
    return _titleLabel;
}

- (DFHotSpotBtn *)backBtn {
    if (!_backBtn) {
        _backBtn = [[DFHotSpotBtn alloc]initWithFrame:CGRectMake(0, DFkStatusBarHeight, 44, 44)];
        [_backBtn setImage:DFUIImageMake(@"back") forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnClickEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

@end
