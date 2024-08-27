//
//  DFToast.m
//  VoiceOnLine
//

#import "DFToast.h"
@import SVProgressHUD;

@implementation DFToast

+ (void)toast:(NSString *)msg {
    [self toast:msg duration:2.0];
}

+ (void)toast:(NSString *)msg duration:(float)duration {
    [SVProgressHUD showImage:nil status:msg];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD dismissWithDelay:duration];
}

@end
