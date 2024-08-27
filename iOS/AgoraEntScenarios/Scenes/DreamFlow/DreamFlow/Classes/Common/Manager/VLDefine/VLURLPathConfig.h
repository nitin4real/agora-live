//
//  DFURLPathConfig.h
//  VoiceOnLine
//

#ifndef DFURLPathConfig_h
#define DFURLPathConfig_h

//static NSString * const kExitRoomNotification = @"exitRoomNotification";
static NSString * const kChoosedSongListChangedNotification = @"choosedSongListChangedNotification";

#pragma mark - API
static NSString * const DFkURLPathUploadImage = @"/api-login/upload"; //upload image
static NSString * const DFkURLPathDestroyUser = @"/api-login/users/cancellation"; //Logout user
static NSString * const DFkURLPathGetUserInfo = @"/api-login/users/getUserInfo"; //Get user information
static NSString * const DFkURLPathUploadUserInfo = @"/api-login/users/update";  //Modifying User Information

#pragma mark - H5
static NSString * const DFkURLPathH5TermsOfService = @"https://www.agora.io/en/terms-of-service/";
static NSString * const DFkURLPathH5UserAgreement = @"https://agora.io/en/compliance/";
static NSString * const DFkURLPathH5AboutUS = @"https://www.agora.io/cn/about-us/";
static NSString * const DFkURLPathH5PersonInfo = @"http://fullapp.oss-cn-beijing.aliyuncs.com/ent-scenarios/pages/manifest/index.html";
static NSString * const DFkURLPathH5ThirdInfoShared = @"https://fullapp.oss-cn-beijing.aliyuncs.com/scenarios/libraries.html";

#endif /* DFURLPathConfig_h */
