//
//  DFBaseView.m
//  VoiceOnLine
//

#import "DFBaseView.h"

@implementation DFBaseView

- (UIView *)containerView {
    if (_containerView == nil) {
        _containerView = [[UIView alloc] init];
    }
    return _containerView;
}

- (void)initSubViews {}
- (void)addSubViewConstraints {}

@end
