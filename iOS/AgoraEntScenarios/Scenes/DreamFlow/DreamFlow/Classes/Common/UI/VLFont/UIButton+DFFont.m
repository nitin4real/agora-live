//
//  UIButton+DFFont.m
//  VoiceOnLine
//

#import "UIButton+DFFont.h"
#import "DFFontUtils.h"
#import <objc/runtime.h>

@implementation UIButton (Font)

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
            
            CGFloat fontSize = self.titleLabel.font.pointSize;
            if ([nameArray containsObject:self.titleLabel.font.fontName]) {

                self.titleLabel.font = DFUIFontBoldMake(fontSize);
            } else if ([self.titleLabel.font.fontName isEqualToString:@".SFUIDisplay-Medium"] ||
                       [self.titleLabel.font.fontName isEqualToString:@".SFUIText-Medium"]) {
    
                self.titleLabel.font = DFUIFontMediumMake(fontSize);
            } else {
 
                self.titleLabel.font = DFUIFontMake(fontSize);
            }
        }
    }
    return self;
}

@end
