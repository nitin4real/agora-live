//
//  DFUserCenter.h
//  VoiceOnLine
//

#import <Foundation/Foundation.h>
#import "DFLoginModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DFUserCenter : NSObject

+ (instancetype)center;
+ (instancetype)shared;

@property (nonatomic, strong, class, readonly) DFLoginModel *user;

- (BOOL)isLogin;
- (void)storeUserInfo:(DFLoginModel *)user;
- (void)logout;

+ (void)clearUserRoomInfo;


@end

NS_ASSUME_NONNULL_END
