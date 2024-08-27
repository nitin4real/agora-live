//
//  DFCommonWebViewController.h
//  VoiceOnLine
//

#import "DFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface DFCommonWebViewController : DFBaseViewController

@property (nonatomic, copy) NSString *urlString;

- (void)injectMethod:(NSString *)method;

- (void)evaluateJS: (NSString *)js;

@end

NS_ASSUME_NONNULL_END
