//
//  UITextField+DFFont.m
//  VoiceOnLine
//

#import "UITextField+DFFont.h"
#import "DFFontUtils.h"
#import <objc/runtime.h>
#import "DFQMUICommonDefines.h"

@implementation UITextField (Font)

+ (void)load {
    
    Method imp = class_getInstanceMethod([self class], @selector(initWithCoder:));
    Method myImp = class_getInstanceMethod([self class], @selector(fontInitWithCoder:));
    method_exchangeImplementations(imp, myImp);
}

- (id)fontInitWithCoder:(NSCoder *)aDecode {
    
    [self fontInitWithCoder:aDecode];
    if (self) {
        
        if (self.tag != DFFontTag) {
            
            NSArray *nameArray = @[@"PingFangSC-Semibold",
                                   @".SFUIDisplay-Bold",
                                   @".SFUIDisplay-Semibold",
                                   @".SFUIText-Semibold",
                                   @".SFUIText-Bold"];
            
            CGFloat fontSize = self.font.pointSize;
            if ([nameArray containsObject:self.font.fontName]) {

                self.font = DFUIFontBoldMake(fontSize);
            } else if ([self.font.fontName isEqualToString:@".SFUIDisplay-Medium"] ||
                       [self.font.fontName isEqualToString:@".SFUIText-Medium"]) {
                
                self.font = DFUIFontMediumMake(fontSize);
            } else {
                self.font = DFUIFontMake(fontSize);
            }
        }
    }
    return self;
}

@end
