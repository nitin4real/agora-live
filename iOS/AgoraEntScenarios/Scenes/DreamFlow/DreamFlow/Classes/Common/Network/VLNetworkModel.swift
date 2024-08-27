//
//  TestModel.swift
//  AgoraEntScenarios
//
//  Created by FanPengpeng on 2023/8/30.
//

import Foundation
import KakaJSON
//import Alamofire

class VLResponseData: NSObject, Convertible {
    public var message: String?
    public var code: NSNumber?
    public var requestId: String?
    public var data: Any?
    
    override public required init() {
        super.init()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func kj_modelKey(from property: Property) -> ModelPropertyKey {
        property.name
    }
}

class VLSceneConfigsModel: NSObject,Convertible {
    
    public var chat: Int = 1200
    public var ktv: Int = 1200
    public var show: Int = 1200
    public var showpk: Int = 1200
    public var joy: Int = 1200
    public var logUpload: Int = 0
    public var oneToOne: Int = 1200
    
    override public required init() {
        super.init()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func kj_modelKey(from property: Property) -> ModelPropertyKey {
        switch property.name{
        case "oneToOne": return "1v1"
        default:return property.name
        }
    }
}

class VLCommonNetworkModel: AUINetworkModel {
    public var userId: String?
    public override init() {
        super.init()
        host = DreamFlowContext.host
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
  
    
    public override func getHeaders() -> [String: String] {
        var headers = super.getHeaders()
        headers["Authorization"] = getToken()
        headers["Content-Type"] = "application/json"
        headers["appProject"] = "agora_ent_demo"
        headers["appOs"] = "iOS"
        headers["versionName"] = UIApplication.shared.appVersion ?? ""
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
        let rooms = dic.kj.model(VLResponseData.self)
        return rooms
    }
}



class VLUploadUserInfoNetworkModel: VLCommonNetworkModel {
    
    public var userNo: String?
    public var headUrl: String?
    public var name: String?
    
    public override init() {
        super.init()
        interfaceName = "/api-login/users/update"
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class VLGetUserInfoNetworkModel: VLCommonNetworkModel {
    
    public var userNo: String?
    
    public override init() {
        super.init()
        interfaceName = "/api-login/users/getUserInfo"
        method = .get
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class VLDetoryUserInfoNetworkModel: VLCommonNetworkModel {
    
    public var userNo: String?
    
    public override init() {
        super.init()
        interfaceName = "/api-login/users/cancellation"
        method = .get
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class VLUploadImageNetworkModel: AUIUploadNetworkModel {
    
    public var url: String?
    
    public var image: UIImage! {
        didSet{
            fileData = image.resetSizeOfImageData(maxSize: 1024)
        }
    }
    
    public override init() {
        super.init()
        interfaceName = "/api-login/upload"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        let time = formatter.string(from: Date())
        name = "file"
        fileName = "\(time)\(arc4random() % 1000).jpg"
        mimeType = "image/jpg"
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func getHeaders() -> [String: String] {
        var headers = super.getHeaders()
        headers["Authorization"] =  getToken()
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
        let response = dic.kj.model(VLResponseData.self)
        return response
    }
    
    func getToken() -> String {
        if DFUserCenter.shared().isLogin() {
            return DFUserCenter.user.token
        }
        return ""
    }
}

class VLLoginNetworkModel: VLCommonNetworkModel {
    
    public var phone: String?
    public var code: String?
    
    public override init() {
        super.init()
        interfaceName = "/api-login/users/login"
        method = .get
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class VLVerifyCodeNetworkModel: VLCommonNetworkModel {
    
    public var phone: String?
   
    public override init() {
        super.init()
        interfaceName = "/api-login/users/verificationCode"
        method = .get
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class VLSceneConfigsNetworkModel: VLCommonNetworkModel {
    
    override init() {
        super.init()
//        host = "https://test-toolbox.bj2.shengwang.cn"
        interfaceName = "/v1/configs/scene"
        method = .get
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func parse(data: Data?) throws -> Any? {
        var dic: VLResponseData? = nil
        do {
            try dic = super.parse(data: data) as? VLResponseData
        } catch let err {
            throw err
        }
        guard let dic = dic?.data as? [String: Any] else {
            throw AUICommonError.networkParseFail.toNSError()
        }
        let model = dic.kj.model(VLSceneConfigsModel.self)
        return model
    }
}
