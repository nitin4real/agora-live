/**
 * Tencent is pleased to support the open source community by making QMUI_iOS available.
 * Copyright (C) 2016-2021 THL A29 Limited, a Tencent company. All rights reserved.
 * Licensed under the MIT License (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
 * http://opensource.org/licenses/MIT
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
 */

//
//  DFQMUICommonDefines.h
//  qmui
//
//  Created by QMUI Team on 14-6-23.
//

#ifndef DFQMUICommonDefines_h
#define DFQMUICommonDefines_h

#import <UIKit/UIKit.h>

#pragma mark - Variable - device dependent

/// Device type
#define DF_IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//#define IS_IPOD [DFQMUIHelper isIPod]
#define DF_IS_IPHONE ([[[UIDevice currentDevice] model] rangeOfString:@"iPhone"].location != NSNotFound)
#define DF_IS_SIMULATOR NO //[DFQMUIHelper isSimulator]
//#define IS_MAC [DFQMUIHelper isMac]

/// The operating system version number is only the second-level version number. For example, 10.3.1 is only 10.3
#define DF_IOS_VERSION ([[[UIDevice currentDevice] systemVersion] doubleValue])

/// The operating system version number in digital form, which can be used directly for size comparison; For example, 110205 represents version 11.2.5; According to the iOS specification, the version number may have a maximum of 3 digits
#define DF_IOS_VERSION_NUMBER [DFQMUIHelper numbericOSVersion]

/// Horizontal or vertical screen
/// The user interface will return YES only when the screen is horizontal
#define DF_IS_LANDSCAPE UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication.statusBarOrientation)
/// Whether the device supports landscape or not, as long as the device is landscape, it will return YES
#define DF_IS_DEVICE_LANDSCAPE UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])

/// The screen width will change according to the horizontal and vertical screen changes
#define DF_SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)

/// The height of the screen will change according to the change of horizontal and vertical screen
#define DF_SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

/// Device width has nothing to do with horizontal or vertical screen
#define DF_DEVICE_WIDTH MIN([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)

/// The height of the device has nothing to do with horizontal or vertical screens
#define DF_DEVICE_HEIGHT MAX([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)

/// Full screen device or not
#define DF_IS_NOTCHED_SCREEN [DFQMUIHelper isNotchedScreen]
/// iPhone 12 Pro Max
#define DF_IS_67INCH_SCREEN [DFQMUIHelper is67InchScreen]
/// iPhone XS Max
#define DF_IS_65INCH_SCREEN [DFQMUIHelper is65InchScreen]
/// iPhone 12 / 12 Pro
#define DF_IS_61INCH_SCREEN_AND_IPHONE12 [DFQMUIHelper is61InchScreenAndiPhone12Later]
/// iPhone XR
#define DF_IS_61INCH_SCREEN [DFQMUIHelper is61InchScreen]
/// iPhone X/XS
#define DF_IS_58INCH_SCREEN [DFQMUIHelper is58InchScreen]
/// iPhone 6/7/8 Plus
#define DF_IS_55INCH_SCREEN [DFQMUIHelper is55InchScreen]
/// iPhone 12 mini
#define DF_IS_54INCH_SCREEN [DFQMUIHelper is54InchScreen]
/// iPhone 6/7/8
#define DF_IS_47INCH_SCREEN [DFQMUIHelper is47InchScreen]
/// iPhone 5/5S/SE
#define DF_IS_40INCH_SCREEN [DFQMUIHelper is40InchScreen]
/// iPhone 4/4S
#define DF_IS_35INCH_SCREEN [DFQMUIHelper is35InchScreen]
/// iPhone 4/4S/5/5S/SE
#define DF_IS_320WIDTH_SCREEN (DF_IS_35INCH_SCREEN || DF_IS_40INCH_SCREEN)

#pragma mark - Variable - layout related

/// bounds && nativeBounds / scale && nativeScale
#define DFScreenBoundsSize ([[UIScreen mainScreen] bounds].size)
#define DFScreenNativeBoundsSize ([[UIScreen mainScreen] nativeBounds].size)

/// toolBar related frame
#define DFToolBarHeight (DF_IS_IPAD ? (DF_IS_NOTCHED_SCREEN ? 70 : (IOS_VERSION >= 12.0 ? 50 : 44)) : (DF_IS_LANDSCAPE ? 32 : 44) + SafeAreaInsetsConstantForDeviceWithNotch.bottom)

/// tabBar associated frame
#define DFTabBarHeight (DF_IS_IPAD ? (DF_IS_NOTCHED_SCREEN ? 65 : (IOS_VERSION >= 12.0 ? 50 : 49)) : (DF_IS_LANDSCAPE ? 32 : 49) + SafeAreaInsetsConstantForDeviceWithNotch.bottom)

/// Status bar height (in the case of incoming calls, the height of the status bar will change, so it should be calculated in real time, iOS 13, the status bar height will not change in the case of incoming calls, etc.)
#define DFStatusBarHeight (UIApplication.sharedApplication.statusBarHidden ? 0 : UIApplication.sharedApplication.statusBarFrame.size.height)

/// Status bar height (If the status bar is not visible, it will also return a height that is visible in normal state)

/// Static height of the navigationBar

/// Static value of security zone for iPhoneX series full screen phones


#pragma mark - Method - Creator

#define DFUIImageMake(img) [UIImage imageNamed:img]

/// Font related macros for quickly creating a font object, more create macros can be found at UIFont+QMUI.h
//#define DFUIFontMake(size) [UIFont systemFontOfSize:size]
//#define DFUIFontBoldMake(size) [UIFont boldSystemFontOfSize:size]

/// Uicolor-related macros for quickly creating a UIColor object. For more macros created, see UIColor+QMUI.h
#define DFUIColorMake(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

#endif /* DFQMUICommonDefines_h */
