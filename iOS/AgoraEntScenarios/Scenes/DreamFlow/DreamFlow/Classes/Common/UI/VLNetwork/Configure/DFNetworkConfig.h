//
//  DFNetworkConfig.h
//  VoiceOnLine
//

#import <Foundation/Foundation.h>

#define Request_Timeout 30.0f

#pragma mark--Network request type
typedef NS_ENUM(NSInteger , DFRequestType){
    DFRequestTypeGet            = 0,
    DFRequestTypePost           = 1,
    DFRequestTypePut            = 2,
    DFRequestTypeDelete         = 3,
};
