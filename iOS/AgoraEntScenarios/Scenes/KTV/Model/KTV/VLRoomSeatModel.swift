//
//  VLRoomSeatModel.swift
//  AgoraEntScenarios
//
//  Created by CP on 2023/7/13.
//

import Foundation

class VLRoomSeatModel: VLBaseModel {
    /// 是否是房主
    @objc var isMaster: Bool = false
    /// 上麦用户头像
    @objc var headUrl: String = ""
    /// 上麦用户uid
    @objc var userNo: String = ""
    // rtc uid(rtc join with uid)
    @objc var rtcUid: String = ""
    /// 昵称
    @objc var name: String = ""
    /// 在哪个座位
    @objc var seatIndex: Int = 0
    /// 合唱歌曲code
    @objc var chorusSongCode: String = ""
    /// 是否自己静音
    @objc var isAudioMuted: Int = 0
    /// 是否开启视频
    @objc var isVideoMuted: Int = 0
    /// 新增, 判断当前歌曲是否是自己点的
    @objc var isOwner: Bool = false
    
    override init() {
        super.init()
        self.chorusSongCode = ""
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func reset(seatInfo: VLRoomSeatModel?) {
        self.isMaster = seatInfo?.isMaster ?? false
        self.headUrl = seatInfo?.headUrl ?? ""
        self.name = seatInfo?.name ?? ""
        self.userNo = seatInfo?.userNo ?? ""
        self.rtcUid = seatInfo?.rtcUid ?? ""
        self.isAudioMuted = seatInfo?.isAudioMuted ?? 0
        self.isVideoMuted = seatInfo?.isVideoMuted ?? 0
        self.chorusSongCode = seatInfo?.chorusSongCode ?? ""
    }
    
    override var description: String {
        return "i: \(seatIndex) - userNo: \(userNo) - isAudioMuted: \(isAudioMuted)"
    }

}
