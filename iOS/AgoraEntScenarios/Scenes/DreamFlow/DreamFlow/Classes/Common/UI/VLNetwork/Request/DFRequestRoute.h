//
//  DFRequestRoute.h
//  VoiceOnLine
//

#import <Foundation/Foundation.h>
#import "DFNetworkConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface DFRequestRoute : NSObject

+ (NSString *)doRoute:(NSString *)route andMethod:(NSString *)method;

+ (NSString *)getToken;

@end

NS_ASSUME_NONNULL_END
