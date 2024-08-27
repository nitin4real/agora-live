//
//  DFBaseViewController.h
//  VoiceOnLine
//

#import <UIKit/UIKit.h>
#import "DFVLEmptyView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, VLNavigationBarStatus) {
    
    VLNavigationBarStatusLeft,
    VLNavigationBarStatusRight
};

@interface DFBaseViewController : UIViewController
@property (nonatomic, strong) DFVLEmptyView *vlEmptyView;
@property (nonatomic, assign, readwrite) BOOL statusBarHidden;

- (void)hideVLEmptyView;

- (void)leftButtonDidClickAction;

- (void)configNavigationBar:(UINavigationBar *)navigationBar;

- (void)setBackgroundImage:(NSString *)imageName;

- (void)setBackgroundImage:(NSString *)imageName bundleName:(NSString *)name;

- (void)setNaviTitleName:(NSString *)titleStr;

- (void)setBackBtn;

- (void)backBtnClickEvent;

@end

NS_ASSUME_NONNULL_END
