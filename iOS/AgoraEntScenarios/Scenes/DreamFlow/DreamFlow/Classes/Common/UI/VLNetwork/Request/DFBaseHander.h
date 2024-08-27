//
//  DFBaseHander.h
//  VoiceOnLine
//

#ifndef DFBaseHander_h
#define DFBaseHander_h
typedef void(^ Success)(id _Nullable json);
typedef void(^ Failure)(NSString * _Nonnull errorMSG);
typedef void (^FailureBlock)(id _Nullable obj);
typedef void (^LoginCompletionBlock)(void);
#endif /* DFBaseHander_h */
