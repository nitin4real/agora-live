//
//  DFUserCenter.m
//  VoiceOnLine
//

#import "DFUserCenter.h"

@interface DFUserCenter()

@property (nonatomic, strong) DFLoginModel *loginModel;

@end

static NSString *kLocalLoginKey = @"kLocalLoginKey";

@implementation DFUserCenter

+ (DFUserCenter *)center{
    static DFUserCenter *instancel = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        instancel = [[DFUserCenter alloc]init];
    });
    return instancel;
}

+ (DFUserCenter* )shared {
    return [self center];
}

- (BOOL)isLogin {
    if (!_loginModel) {
        NSString* ret = [[NSUserDefaults standardUserDefaults] objectForKey:kLocalLoginKey];
        _loginModel = [DFLoginModel yy_modelWithJSON:ret];
    }
    return _loginModel ? YES : NO;
}

- (void)storeUserInfo:(DFLoginModel *)user {
    _loginModel = user;
    NSString* ret = [_loginModel yy_modelToJSONString];
    [[NSUserDefaults standardUserDefaults] setObject:ret forKey:kLocalLoginKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)logout {
    [self cleanUserInfo];
}

- (void)cleanUserInfo {
    _loginModel = nil;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kLocalLoginKey];
}

+ (DFLoginModel *)user {
    return [DFUserCenter center].loginModel;
}

+ (void)clearUserRoomInfo {
//    DFUserCenter.user.ifMaster = NO;
    [DFUserCenter.center storeUserInfo:DFUserCenter.user];
}

@end
