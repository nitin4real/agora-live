//
//  NetworkManagerModel.swift
//  AgoraEntScenarios
//
//  Created by FanPengpeng on 2023/9/1.
//

import Foundation
//import Alamofire

class NMCommonNetworkModel: AUINetworkModel {
    public var userId: String?
    public override init() {
        super.init()
        host = DreamFlowContext.releaseBaseServerUrl
        method = .post
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getToken() -> String {
        if DFUserCenter.shared().isLogin() {
            return DFUserCenter.user.token
        }
        return ""
    }
    
    public override func getHeaders() -> [String : String] {
        var headers = super.getHeaders()
        headers["Content-Type"] = "application/json"
        headers["X-LC-Id"] = "fkUjxadPMmvYF3F3BI4uvmjo-gzGzoHsz"
        headers["X-LC-Key"] = "QAvFS62IOR28GfSFQO5ze45s"
        headers["X-LC-Session"] = "qmdj8pdidnmyzp0c7yqil91oc"
        headers[kAppProjectName] = kAppProjectValue
        headers[kAppOS] = kAppOSValue
        headers[kAppVersion] = UIApplication.shared.appVersion ?? ""
        headers["Authorization"] = getToken()
        return headers
    }
    
    public override func parse(data: Data?) throws -> Any? {
        var dic: Any? = nil
        do {
            try dic = super.parse(data: data)
        } catch let err {
            throw err
        }
        guard let dic = dic as? [String: Any] else {
            throw AUICommonError.networkParseFail.toNSError()
        }
        return dic["data"]
    }
    
}

class NMGenerateTokennNetworkModel: NMCommonNetworkModel {
    
    var appCertificate: String? = DreamFlowContext.appCertificate
    var appId: String? = DreamFlowContext.appId
    var src: String = "iOS"
    var ts: String? = "".timeStamp
    
    public var channelName: String?
    public var expire: NSNumber?
    public var type: NSNumber?
    public var uid: String?
    
    public override init() {
        super.init()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func parse(data: Data?) throws -> Any? {
        let data = try? super.parse(data: data) as? [String: Any]
        guard let token = data?["token"] as? String else {
            throw AUICommonError.networkParseFail.toNSError()
        }
        return token
    }
}

class NMGenerate006TokennNetworkModel: NMGenerateTokennNetworkModel {
    public override init() {
        super.init()
        interfaceName = "v2/token006/generate"
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class NMGenerate007TokennNetworkModel: NMGenerateTokennNetworkModel {
    public override init() {
        super.init()
        interfaceName = "v2/token/generate"
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class NMGenerateIMConfigNetworkModelChatParams: NSObject {
    var name: String?
    var desc: String?
    var owner: String?
    var chatId: String?
    
    static func modelCustomPropertyMapper()-> [String: Any]? {
        return [
            "desc": "description",
            "chatId": "id"
        ]
    }
}

class NMGenerateIMConfigNetworkModelUserParmas: NSObject {
    var username: String?
    var password: String?
    var nickname: String?
}

class NMGenerateIMConfigNetworkModelIMParmas: NSObject {
    var appKey: String? = DreamFlowContext.imAppKey
    var clientId: String? = DreamFlowContext.imClientId
    var clientSecret: String? = DreamFlowContext.imClientSecret
}

class NMGenerateIMConfigNetworkModel: NMCommonNetworkModel {
    
    var appId: String? =  DreamFlowContext.appId
    var src: String? = "iOS"
    var traceId: String? = NSString.withUUID().md5()
    
    var chat: NMGenerateIMConfigNetworkModelChatParams?
    var im: NMGenerateIMConfigNetworkModelIMParmas?
    var payload: String?
    var user: NMGenerateIMConfigNetworkModelUserParmas?
    var type: NSNumber?
    
    static func modelContainerPropertyGenericClass()-> [String: Any]? {
        return [
            "chat": NMGenerateIMConfigNetworkModelChatParams.self,
            "im": NMGenerateIMConfigNetworkModelIMParmas.self,
            "user": NMGenerateIMConfigNetworkModelUserParmas.self
        ]
    }

    public override init() {
        super.init()
        interfaceName = "v1/webdemo/im/chat/create"
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class NMVoiceIdentifyNetworkModel: NMCommonNetworkModel {
   
    var appId: String? = DreamFlowContext.appId
    var src: String? = "iOS"
    var traceId: String? = UUID().uuidString.md5Encrypt
    
    var channelName: String?
    var channelType: NSNumber?
    var payload: String?
    
    public override init() {
        super.init()
        interfaceName = "v1/moderation/audio"
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class NMStartCloudPlayerNetworkModel: NMCommonNetworkModel {
    
    var appId: String? = DreamFlowContext.appId
    var appCert: String? = DreamFlowContext.appCertificate
    var traceId: String? = NSString.withUUID().md5() ?? ""
    var region: String? = "cn"
    var src: String? = "iOS"
    
    lazy var basicAuth: String? = {
        createBasicAuth(key: DreamFlowContext.cloudPlayerKey, password: DreamFlowContext.cloudPlayerSecret)
    }()
    
    var channelName: String?
    var uid: String?
    var robotUid: NSNumber?
    var streamUrl: String?

    public override init() {
        super.init()
        interfaceName = "v1/rte-cloud-player/start"
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class NMCloudPlayerHeartbeatNetworkModel: NMCommonNetworkModel {
    
    var appId: String? = DreamFlowContext.appId
    var src: String? = "iOS"
    var traceId: String? = NSString.withUUID().md5() ?? ""
    
    var channelName: String?
    var uid: String?
    
    public override init() {
        super.init()
        interfaceName = "v1/heartbeat"
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class NMReportSceneClickNetworkModel: NMCommonNetworkModel {
    
    var src: String? = "agora_ent_demo"
    var ts: Int64 = Int64(Date().timeIntervalSince1970 * 1000)
    var sign: String?
    var pts: [[String: Any]]?
         
    public override init() {
        super.init()
        host = "https://report-ad.shengwang.cn/"
        interfaceName = "v1/report"
        sign = "src=\(src ?? "agora_ent_demo")&ts=\(ts)".md5Encrypt
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setProject(_ project: String){
        pts = [["m": "event",
               "ls": [
                "name": "entryScene",
                "project": project,
                "version": UIApplication.shared.appVersion ?? "",
                "platform": "iOS",
                "model": UIDevice.current.machineModel ?? ""
               ],
               "vs": ["count": 1]]
        ]
    }
}

class NMReportDeviceInfoNetworkModel: NMCommonNetworkModel {
    
    var appVersion: String? = UIApplication.shared.appVersion ?? ""
    var model: String? = UIDevice.current.machineModel ?? ""
    var platform: String? = "iOS"
    
    public init(sceneId: String, userNo: String, appId: String) {
        super.init()
        host = DreamFlowContext.host
        interfaceName = "/api-login/report/device?userNo=\(userNo)&sceneId=\(sceneId)&appId=\(appId)&projectId=agora_ent_demo"
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class NMReportUserBehaviorNetworkModel: NMCommonNetworkModel {
    
    var action: String?
    
    public init(sceneId: String, userNo: String, appId: String) {
        super.init()
        host = DreamFlowContext.host
        interfaceName = "/api-login/report/action?userNo=\(userNo)&sceneId=\(sceneId)&appId=\(appId)&projectId=agora_ent_demo"
        action = sceneId
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

