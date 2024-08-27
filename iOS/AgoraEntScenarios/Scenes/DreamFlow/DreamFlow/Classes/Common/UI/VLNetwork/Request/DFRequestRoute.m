//
//  DFRequestRoute.m
//  VoiceOnLine
//

#import "DFRequestRoute.h"
#import "DFNetworkConfig.h"
#import "DFUserCenter.h"
#import "DreamFlow/DreamFlow-Swift.h"

@implementation DFRequestRoute

+ (NSString *)doRoute:(NSString *)route andMethod:(NSString *)method{
    NSString *url = @"";
    if(route && route.length > 0){
        if (method && method.length > 0) {
            url = [NSString stringWithFormat:@"%@?act=%@&op=%@",[self getHostUrl],route,method];
        }else{
           url =  [NSString stringWithFormat:@"%@?act=%@",[self getHostUrl],route];
        }
    }else{
        return [self getRequestUrl:method];
    }
    return url;
}
+ (NSString*)getHostUrl {
    return [NSString stringWithFormat:@"%@", [DreamFlowContext.shared appHostUrl]];
}
+ (NSString*)getRequestUrl:(NSString *)url {
    return [NSString stringWithFormat:@"%@%@", [DreamFlowContext.shared appHostUrl], url];
}

+ (NSString *)getToken {
    if ([DFUserCenter center].isLogin){
        return DFUserCenter.user.token;
    }else{
        return @"";
    }
    return @"";
}

@end
