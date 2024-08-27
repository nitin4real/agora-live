//
//  DFFontUtils.h
//  VoiceOnLine
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "DFVLDeviceUtils.h"

NS_ASSUME_NONNULL_BEGIN

#define VLDF_IS_35INCH_SCREEN [DFVLDeviceUtils is35InchScreen]
#define VLDF_IS_40INCH_SCREEN [DFVLDeviceUtils is40InchScreen]
#define VLDF_IS_47INCH_SCREEN [DFVLDeviceUtils is47InchScreen]
#define VLDF_IS_55INCH_SCREEN [DFVLDeviceUtils is55InchScreen]
#define DFIS_58INCH_SCREEN [DFVLDeviceUtils is58InchScreen]
#define DFIS_61INCH_SCREEN [DFVLDeviceUtils is61InchScreen]
#define VLDF_IS_65INCH_SCREEN [DFVLDeviceUtils is65InchScreen]

FOUNDATION_EXPORT NSUInteger const DFFontTag;

FOUNDATION_EXTERN UIFont * DFSystemRegularFont(CGFloat inch_3_5,
                             CGFloat inch_4_0,
                             CGFloat inch_4_7,
                             CGFloat inch_5_5,
                             CGFloat inch_5_8,
                             CGFloat inch_6_1,
                             CGFloat inch_6_5);

FOUNDATION_EXTERN UIFont * DFSystemBoldFont(CGFloat inch_3_5,
                          CGFloat inch_4_0,
                          CGFloat inch_4_7,
                          CGFloat inch_5_5,
                          CGFloat inch_5_8,
                          CGFloat inch_6_1,
                          CGFloat inch_6_5);

FOUNDATION_EXTERN UIFont * DFSystemMediumFont(CGFloat inch_3_5,
                            CGFloat inch_4_0,
                            CGFloat inch_4_7,
                            CGFloat inch_5_5,
                            CGFloat inch_5_8,
                            CGFloat inch_6_1,
                            CGFloat inch_6_5);

static inline UIFont * DFUIFontMake(CGFloat font) {
    return DFSystemRegularFont((font - 2), (font - 2), font, (font + 1), font, font, (font + 1));
}

static inline UIFont * DFUIFontBoldMake(CGFloat font) {
    return DFSystemBoldFont((font - 2), (font - 2), font, (font + 1), font, font, (font + 1));
}

static inline UIFont * DFUIFontMediumMake(CGFloat font) {
    return DFSystemMediumFont((font - 2), (font - 2), font, (font + 1), font, font, (font + 1));
}

@interface DFFontUtils : NSObject

@end

NS_ASSUME_NONNULL_END
