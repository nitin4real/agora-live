//
//  VLEmptyView.h
//  VoiceOnLine
//

#import "DFVLUIView.h"

typedef void(^DFVLEmptyViewButtonBlock)(void);
NS_ASSUME_NONNULL_BEGIN

@protocol DFVLEmptyViewDelegate <NSObject>

@optional

@end

@interface DFVLEmptyView : DFVLUIView

- (instancetype)initWithFrame:(CGRect)frame withDelegate:(id<DFVLEmptyViewDelegate>)delegate;
@property (nonatomic, copy) DFVLEmptyViewButtonBlock emptyViewButtonBlock;
@property (nonatomic, strong) UILabel *detailTextLabel;
- (void)setupViewByImage:(UIImage *)image text:(NSString *)text detailText:(NSString *)detailText butttonTitle:(NSString *)buttonTitle;

@end

NS_ASSUME_NONNULL_END
