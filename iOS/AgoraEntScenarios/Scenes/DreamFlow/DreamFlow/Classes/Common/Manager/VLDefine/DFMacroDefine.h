//
//  DFMacroDefine.h
//  VoiceOnLine
//

#ifndef DFMacroDefine_h
#define DFMacroDefine_h

#define __DF_MAIN_SCREEN_WIDTH__       MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)

#define  DF_VLSCALE_W                 (__DF_MAIN_SCREEN_WIDTH__ / 375.0)

#define  DL_VLREALVALUE_WIDTH(w)      (DF_VLSCALE_W * w)

#define VF_IS_IPHONE_X ((DF_IOS_VERSION >= 11.f) && IS_IPHONE && (MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) >= 375 && MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) >= 812))

#define DFTABBAR_HEIGHT  (VF_IS_IPHONE_X ? 89.0 : 55.0)

#define DFSafeAreaTopHeight (VF_IS_IPHONE_X ? 88 : 64)
#define DFSafeAreaBottomHeight (VF_IS_IPHONE_X ? 34 : 0)
#define DFSafeAreaStatusHeight (VF_IS_IPHONE_X ? 24 : 0)

#define DFIPHONE_X  [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0
#define DFkStatusBarHeight    (DFIPHONE_X ? 44.f : 20.f)
#define DFkTopNavHeight    (DFkStatusBarHeight + 44.f)
#define DFkDFSafeAreaBottomHeight  (DFIPHONE_X ? 34.f : 0.f)
#define DFkBottomTabBarHeight    (DFkDFSafeAreaBottomHeight + 49.f)
        
#define DF(weakSelf)  __weak __typeof(&*self)weakSelf = self

#define DFkWeakSelf(object) __weak typeof(object) weak##object = object;
#define DFkStrongSelf(object) __strong typeof(weak##object) object = weak##object;

#ifdef DEBUG
#define DFLog NSLog
#else
#define DFLog
#endif

#endif /* DFMacroDefine_h */
