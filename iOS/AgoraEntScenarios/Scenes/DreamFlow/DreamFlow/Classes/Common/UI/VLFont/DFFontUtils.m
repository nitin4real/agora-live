//
//  DFFontUtils.m
//  VoiceOnLine
//

#import "DFFontUtils.h"
#import <CoreText/CoreText.h>
#import <objc/runtime.h>
@import UIKit;

NSUInteger const DFFontTag = 7101746;

@implementation DFFontUtils

UIFont * DFSystemRegularFontSize(CGFloat size) {
    
    return [UIFont systemFontOfSize:size weight:UIFontWeightRegular];
}

UIFont * DFSystemBoldFontSize(CGFloat size) {
    
    return [UIFont systemFontOfSize:size weight:UIFontWeightSemibold];
}

UIFont * DFSystemMediumFontSize(CGFloat size) {
    
    return [UIFont systemFontOfSize:size weight:UIFontWeightMedium];
}

UIFont * DFAppSystemFont(BOOL isBold,
                    CGFloat inch_3_5,
                    CGFloat inch_4_0,
                    CGFloat inch_4_7,
                    CGFloat inch_5_5,
                    CGFloat inch_5_8,
                    CGFloat inch_6_1,
                    CGFloat inch_6_5) {
    if (VLDF_IS_35INCH_SCREEN) {
        
        return isBold ? DFSystemBoldFontSize(inch_3_5) : DFSystemRegularFontSize(inch_3_5);
    }
    if (VLDF_IS_40INCH_SCREEN) {
        
        return isBold ? DFSystemBoldFontSize(inch_4_0) : DFSystemRegularFontSize(inch_4_0);
    }
    if (VLDF_IS_47INCH_SCREEN) {
        
        return isBold ? DFSystemBoldFontSize(inch_4_7) : DFSystemRegularFontSize(inch_4_7);
    }
    if (VLDF_IS_55INCH_SCREEN) {
        
        return isBold ? DFSystemBoldFontSize(inch_5_5) : DFSystemRegularFontSize(inch_5_5);
    }
    if (DFIS_58INCH_SCREEN) {
        
        return isBold ? DFSystemBoldFontSize(inch_5_8) : DFSystemRegularFontSize(inch_5_8);
    }
    if (DFIS_61INCH_SCREEN) {
        
        return isBold ? DFSystemBoldFontSize(inch_6_1) : DFSystemRegularFontSize(inch_6_1);
    }
    if (VLDF_IS_65INCH_SCREEN) {
        
        return isBold ? DFSystemBoldFontSize(inch_6_5) : DFSystemRegularFontSize(inch_6_5);
    }
    return isBold ? DFSystemBoldFontSize(inch_4_7) : DFSystemRegularFontSize(inch_4_7);
}


/*************************************************Function******************************************************************/

// Use regular fonts
UIFont * DFSystemRegularFont(CGFloat inch_3_5,
                            CGFloat inch_4_0,
                            CGFloat inch_4_7,
                            CGFloat inch_5_5,
                            CGFloat inch_5_8,
                            CGFloat inch_6_1,
                            CGFloat inch_6_5) {
    
    return DFAppSystemFont(NO, inch_3_5, inch_4_0, inch_4_7, inch_5_5, inch_5_8, inch_6_1, inch_6_5);
}

// Use bold
UIFont * DFSystemBoldFont(CGFloat inch_3_5,
                          CGFloat inch_4_0,
                          CGFloat inch_4_7,
                          CGFloat inch_5_5,
                          CGFloat inch_5_8,
                          CGFloat inch_6_1,
                          CGFloat inch_6_5) {
    return DFAppSystemFont(YES, inch_3_5, inch_4_0, inch_4_7, inch_5_5, inch_5_8, inch_6_1, inch_6_5);
}

// Use medium bold
UIFont * DFSystemMediumFont(CGFloat inch_3_5,
                          CGFloat inch_4_0,
                          CGFloat inch_4_7,
                          CGFloat inch_5_5,
                          CGFloat inch_5_8,
                          CGFloat inch_6_1,
                          CGFloat inch_6_5) {
    if (VLDF_IS_35INCH_SCREEN) {
        
        return DFSystemMediumFontSize(inch_3_5);
    }
    if (VLDF_IS_40INCH_SCREEN) {
        
        return DFSystemMediumFontSize(inch_4_0);
    }
    if (VLDF_IS_47INCH_SCREEN) {
        
        return DFSystemMediumFontSize(inch_4_7);
    }
    if (VLDF_IS_55INCH_SCREEN) {
        
        return DFSystemMediumFontSize(inch_5_5);
    }
    if (DFIS_58INCH_SCREEN) {
        
        return DFSystemMediumFontSize(inch_5_8);
    }
    if (DFIS_61INCH_SCREEN) {
        
        return DFSystemMediumFontSize(inch_6_1);
    }
    if (VLDF_IS_65INCH_SCREEN) {
        
        return DFSystemMediumFontSize(inch_6_5);
    }
    return DFSystemMediumFontSize(inch_4_7);
}


@end
