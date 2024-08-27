//
//  DreamFlowContext.swift
//  Pods
//
//  Created by qinhui on 2024/8/27.
//

import Foundation
import RTMSyncManager

@objcMembers
public class DreamFlowUserInfo: NSObject {
    public var uid: String = ""
    public var userName: String = ""
    public var avatar: String = ""
    
    convenience init(userInfo: AUIUserInfo) {
        self.init()
        self.uid = userInfo.userId
        self.userName = userInfo.userName
        self.avatar = userInfo.userAvatar
    }
    
    static func modelCustomPropertyMapper() -> [String : Any]? {
        return ["uid": "userId"]
    }
    
    func getUIntUserId() -> UInt {
        return UInt(uid) ?? 0
    }
    
    func bgImage() -> String {
        let uid = getUIntUserId()
        return "https://fullapp.oss-cn-beijing.aliyuncs.com/ent-scenarios/images/1v1/user_bg\(uid % 9 + 1).png"
    }
}

class DreamFlowLogger: NSObject {
    
    public static let kLogKey = "DreamFlow"
    
    public static func info(_ text: String, context: String? = nil) {
        AgoraEntLog.getSceneLogger(with: kLogKey).info(text, context: context)
    }

    public static func warn(_ text: String, context: String? = nil) {
        AgoraEntLog.getSceneLogger(with: kLogKey).warning(text, context: context)
    }

    public static func error(_ text: String, context: String? = nil) {
        
        AgoraEntLog.getSceneLogger(with: kLogKey).error(text, context: context)
    }
}

let kDreamFlowLogBaseContext = "AgoraKit"
private let kDreamFlowRoomListKey = "kDreamFlowRoomListKey"
private let kRtcTokenMapKey = "kRtcTokenMapKey"
private let kRtcToken = "kRtcToken"
private let kRtcTokenDate = "kRtcTokenDate"
private let kDebugModeKey = "kDebugModeKey"

@objcMembers
public class DreamFlowContext: NSObject {
    static let kSceneName = "DreamFlow"
    static var appId: String = ""
    static var appCertificate: String = ""
    static var host: String = ""
    static var imAppKey: String = ""
    static var imClientId: String = ""
    static var imClientSecret: String = ""
    static var rtmHostUrl: String = ""
    static var sceneLocalizeBundleName: String = "DreamFlow"
    static var cloudPlayerKey: String = ""
    static var cloudPlayerSecret: String = ""
    static var releaseBaseServerUrl: String = ""
    static var debugBaseServerUrl: String = ""
    static private var _showServiceImp: ShowSyncManagerServiceImp?
    static private var dfUserInfo: DreamFlowUserInfo!

    private var dislikeRoomCache: [String :String] = [:]
    private var dislikeUserCache: [String :String] = [:]

    @objc var sceneImageBundleName: String?
    @objc var sceneConfig: VLSceneConfigsModel?
    @objc var localizedCache = [String: String]()
    @objc var extDic: NSMutableDictionary = NSMutableDictionary()

    @objc var agoraRTCToken: String = ""
    @objc var agoraRTMToken: String = ""
    @objc var isDebugMode = false
    
    @objc public static let shared: DreamFlowContext = .init()
    @objc var imageCahe = [String: AnyObject]()

    @objc public func getLang() -> String {
        guard let lang = NSLocale.preferredLanguages.first else {
            return "en"
        }

        if lang.contains("zh") {
            return "zh-Hans"
        }

        return "en"
    }
    
    static func showServiceImp() -> ShowServiceProtocol? {
        if let service = _showServiceImp {
            return service
        }
        
        _showServiceImp = ShowSyncManagerServiceImp(appId: DreamFlowContext.appId,
                                                    host: DreamFlowContext.rtmHostUrl,
                                                    userInfo: DreamFlowContext.dfUserInfo)
        
        return _showServiceImp
    }
    
    static func unloadShowServiceImp() {
        _showServiceImp = nil
    }
    
    public var rtcToken: String? {
        set {
            self.extDic[kRtcToken] = newValue
            self.tokenDate = Date()
        }
        get {
            return self.extDic[kRtcToken] as? String
        }
    }
    
    public var tokenDate: Date? {
        set {
            self.extDic[kRtcTokenDate] = newValue
        }
        get {
            return self.extDic[kRtcTokenDate] as? Date
        }
    }
    
    @objc public func appId() -> String {
        return DreamFlowContext.appId
    }

    @objc public func appHostUrl() -> String {
        return DreamFlowContext.host
    }

    
    @objc public static func showScene(viewController: UIViewController,
                                       appId: String,
                                       host: String,
                                       appCertificate: String,
                                       releaseBaseUrl: String,
                                       debugBaseUrl: String,
                                       imAppKey: String,
                                       imClientId: String,
                                       imClientSecret: String,
                                       cloudPlayerKey: String,
                                       cloudPlayerSecret: String,
                                       rtmHostUrl: String,
                                       userInfo: DreamFlowUserInfo) {
        DreamFlowContext.appId = appId
        DreamFlowContext.host = host
        DreamFlowContext.appCertificate = appCertificate
        DreamFlowContext.releaseBaseServerUrl = releaseBaseUrl
        DreamFlowContext.debugBaseServerUrl = debugBaseUrl
        DreamFlowContext.imAppKey = imAppKey
        DreamFlowContext.imClientId = imClientId;
        DreamFlowContext.imClientSecret = imClientSecret
        DreamFlowContext.cloudPlayerKey = cloudPlayerKey
        DreamFlowContext.cloudPlayerSecret = cloudPlayerSecret
        DreamFlowContext.rtmHostUrl = rtmHostUrl
        DreamFlowContext.dfUserInfo = userInfo
        
        let vc = ShowRoomListVC(userInfo: userInfo)
        vc.hidesBottomBarWhenPushed = true
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
}

extension DreamFlowContext {
    func addDislikeRoom(at roomId: String?) {
        guard let roomId = roomId else { return }
        dislikeRoomCache[(sceneImageBundleName ?? "") + roomId] = roomId
    }
    
    func dislikeRooms() -> [String] {
        let value = dislikeRoomCache.filter({ $0.key.contains(sceneImageBundleName ?? "") })
        return value.map({ $0.value })
    }
    
    func addDislikeUser(at uid: String?) {
        guard let uid = uid else { return }
        dislikeUserCache[(sceneImageBundleName ?? "") + uid] = uid
    }
    
    func dislikeUsers() -> [String] {
        let value = dislikeUserCache.filter({ $0.key.contains(sceneImageBundleName ?? "") })
        return value.map({ $0.value })
    }
}
