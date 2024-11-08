//
//  AgoraChatRoomBaseRtcUserView.swift
//  VoiceChat4Swift
//
//  Created by CP on 2022/8/30.
//

import SnapKit
import UIKit

public enum AgoraChatRoomBaseUserCellType {
    case AgoraChatRoomBaseUserCellTypeAdd
    case AgoraChatRoomBaseUserCellTypeMute
    case AgoraChatRoomBaseUserCellTypeForbidden
    case AgoraChatRoomBaseUserCellTypeLock
    case AgoraChatRoomBaseUserCellTypeNormalUser
    case AgoraChatRoomBaseUserCellTypeMuteAndLock
    case AgoraChatRoomBaseUserCellTypeAlienNonActive
    case AgoraChatRoomBaseUserCellTypeAlienActive
}

protocol RtcUserViewDelegate: NSObjectProtocol {
    func didRtcUserViewClicked(tag: Int)
}

class AgoraChatRoomBaseRtcUserView: UIView {
    public var cellType: AgoraChatRoomBaseUserCellType = .AgoraChatRoomBaseUserCellTypeAdd {
        didSet {
            if cellType == .AgoraChatRoomBaseUserCellTypeAlienActive || cellType == .AgoraChatRoomBaseUserCellTypeAlienNonActive {
                bgColor = .white
            } else {
                bgColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.1)
            }

            switch cellType {
            case .AgoraChatRoomBaseUserCellTypeAdd:
                iconView.isHidden = true
                bgIconView.image = UIImage.sceneImage(name: "voice_wuren", bundleName: "VoiceChatRoomResource")
            case .AgoraChatRoomBaseUserCellTypeMute:
                iconView.isHidden = false
                setMicState(.forbidden)
            case .AgoraChatRoomBaseUserCellTypeForbidden:
                iconView.isHidden = false
                setMicState(.forbidden)
            case .AgoraChatRoomBaseUserCellTypeLock:
                iconView.isHidden = true
                bgIconView.image = UIImage.sceneImage(name: "voice_ic_seat_lock", bundleName: "VoiceChatRoomResource")
            case .AgoraChatRoomBaseUserCellTypeNormalUser:
                iconView.isHidden = false
                setMicState(.on)
                nameBtn.setImage(nil, for: .normal)
            case .AgoraChatRoomBaseUserCellTypeMuteAndLock:
                iconView.isHidden = true
                setMicState(.forbidden)
                bgIconView.image = UIImage.sceneImage(name: "voice_ic_seat_lock", bundleName: "VoiceChatRoomResource")
            case .AgoraChatRoomBaseUserCellTypeAlienNonActive:
                iconView.isHidden = false
                setMicState(.on)
                nameBtn.setImage(UIImage.sceneImage(name: "guanfang", bundleName: "VoiceChatRoomResource"), for: .normal)
                coverView.isHidden = false
                activeButton.isHidden = false
            case .AgoraChatRoomBaseUserCellTypeAlienActive:
                iconView.isHidden = false
                nameBtn.setImage(UIImage.sceneImage(name: "guanfang", bundleName: "VoiceChatRoomResource"), for: .normal)
                coverView.isHidden = true
                activeButton.isHidden = true
            }
        }
    }

    public var iconImgUrl: String = "" {
        didSet {
            iconView.image = UIImage.voice_image(iconImgUrl)
        }
    }

    public var ownerIcon: String = "" {
        didSet {
            nameBtn.setImage(UIImage.voice_image(ownerIcon), for: .normal)
        }
    }

    public var showMicView: Bool = false {
        didSet {
            if showMicView {
                setMicState(.on)
            } else {
            }
        }
    }

    public var iconWidth: CGFloat = 60 {
        didSet {
            self.iconView.layer.cornerRadius = (iconWidth / 2.0)
            self.iconView.layer.masksToBounds = true
            self.iconView.snp.updateConstraints { make in
                make.width.height.equalTo(iconWidth)
            }
        }
    }

    public var nameStr: String = "" {
        didSet {
            nameBtn.setTitle(nameStr, for: .normal)
        }
    }

    public var bgColor: UIColor = .black {
        didSet {
            bgView.backgroundColor = bgColor
        }
    }

    public var volume: Int = 0 {
        didSet {
            if(volume > 0) {
                startAnimation()
            }else{
                stopAnimation()
            }
        }
    }

    private var bgView: UIView = .init()
    private var iconView: UIImageView = .init()
    private lazy var bgIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        return imageView
    }()
    
    private var muteMicView: UIImageView = UIImageView()
    private var nameBtn: UIButton = .init()
    private var coverView: UIView = .init()
    private var activeButton: UIButton = .init()
    private var targetBtn: UIButton = .init()
    
    private lazy var waveLayer1: CALayer = {
        createWaveLayer()
    }()
    
    private lazy var waveLayer2: CALayer = {
        createWaveLayer()
    }()
    
    private var isAnimating = false

    var clickBlock: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func layoutUI() {
        bgView.layer.cornerRadius = 30
        bgView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3)
        addSubview(bgView)
        
        bgView.layer.addSublayer(waveLayer2)
        bgView.layer.addSublayer(waveLayer1)

        bgIconView.image = UIImage.sceneImage(name: "voice_wuren", bundleName: "VoiceChatRoomResource")
        bgIconView.layer.cornerRadius = 30
        bgIconView.layer.masksToBounds = true
        bgView.addSubview(bgIconView)

        iconView.image = UIImage.sceneImage(name: "", bundleName: "VoiceChatRoomResource")
        iconView.layer.cornerRadius = 30
        iconView.layer.masksToBounds = true
        iconView.contentMode = .scaleAspectFill
        bgView.addSubview(iconView)

        muteMicView.image = UIImage.sceneImage(name: "micoff", bundleName: "VoiceChatRoomResource")
        muteMicView.isHidden = true
        addSubview(muteMicView)

        coverView.backgroundColor = .black
        coverView.alpha = 0.5
        coverView.layer.cornerRadius = 30
        coverView.layer.masksToBounds = true
        bgView.addSubview(coverView)
        coverView.isHidden = true

        let alienTap = UITapGestureRecognizer(target: self, action: #selector(alienTap))
        coverView.addGestureRecognizer(alienTap)
        coverView.isUserInteractionEnabled = true

        activeButton.layer.cornerRadius = 8
        activeButton.layer.masksToBounds = true
        activeButton.setTitle("voice_active".voice_localized, for: .normal)
        activeButton.setTitleColor(.white, for: .normal)
        activeButton.setBackgroundImage(UIImage.sceneImage(name: "active", bundleName: "VoiceChatRoomResource"), for: .normal)
        activeButton.titleLabel?.font = UIFont.systemFont(ofSize: 9)
        activeButton.addTargetFor(self, action: #selector(active), for: .touchUpInside)
        addSubview(activeButton)
        activeButton.isHidden = true

        nameBtn.setTitleColor(.white, for: .normal)
        nameBtn.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        nameBtn.titleLabel?.lineBreakMode = .byTruncatingTail
        nameBtn.setTitle("", for: .normal)
        nameBtn.isUserInteractionEnabled = false
        addSubview(nameBtn)

        targetBtn.addTargetFor(self, action: #selector(tapClick), for: .touchUpInside)
        addSubview(targetBtn)

        bgView.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(20)
            make.width.height.equalTo(60)
        }

        bgIconView.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self.bgView)
            make.width.height.equalTo(60)
        }

        iconView.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(20)
            make.width.height.equalTo(60)
        }

        muteMicView.snp.makeConstraints { make in
            make.right.equalTo(self.iconView).offset(-3)
            make.width.height.equalTo(18)
            make.bottom.equalTo(self.iconView.snp.bottom).offset(-2)
        }

        coverView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalTo(iconView)
            make.height.width.equalTo(60)
        }

        activeButton.snp.makeConstraints { make in
            make.centerX.equalTo(iconView)
            make.bottom.equalTo(iconView)
            make.width.equalTo(40)
            make.height.equalTo(16)
        }

        nameBtn.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(self.iconView.snp.bottom).offset(10)
            make.height.equalTo(20)
            make.left.equalTo(10)
            make.right.equalTo(-10)
        }

        targetBtn.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(self.nameBtn)
            make.top.equalTo(self.bgView)
        }
    }

    @objc private func tapClick(sender: UIButton) {
        guard let clickBlock = clickBlock else {
            return
        }
        clickBlock()
    }

    @objc private func active() {
        guard let clickBlock = clickBlock else {
            return
        }
        clickBlock()
    }

    @objc private func alienTap() {
        guard let clickBlock = clickBlock else {
            return
        }
        clickBlock()
    }
    
    public func setMicState(_ state: AgoraMicVolView.AgoraMicVolViewState) {
        if state == .off || state == .forbidden {
            muteMicView.isHidden = false
        }else {
            muteMicView.isHidden = true
        }
        if state != .on {
            volume = 0
        }
    }
}

extension AgoraChatRoomBaseRtcUserView {
    
    private func createWaveLayer() -> CALayer {
        let layer = CALayer()
        layer.backgroundColor = UIColor(hex: 0x75ADFF, alpha: 1).cgColor
        layer.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        layer.cornerRadius = 30
        layer.isHidden = true
        return layer
    }
    
    private func startAnimation() {
        if isAnimating {
            return
        }
        isAnimating = true
        waveLayer1.isHidden = false
        waveLayer2.isHidden = false
          
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.values = [1, 1.1, 1]
        animation.keyTimes = [0, 0.5, 1]
          
        let alphaAnimation = CAKeyframeAnimation(keyPath: "opacity")
        alphaAnimation.values = [1, 0.5, 0.3]
        alphaAnimation.keyTimes = [0, 0.5, 1]
          
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [animation, alphaAnimation]
        // groupAnimation.autoreverses = true
        groupAnimation.repeatCount = Float.infinity
        groupAnimation.duration = 1.4
          
        waveLayer1.add(groupAnimation, forKey: nil)
          
        let animation2 = CAKeyframeAnimation(keyPath: "transform.scale")
        animation2.values = [1, 1.4]
        animation2.keyTimes = [0, 1]
          
        let alphaAnimation2 = CAKeyframeAnimation(keyPath: "opacity")
        alphaAnimation2.values = [0.6, 0.3, 0]
        alphaAnimation2.keyTimes = [0, 0.5, 1]
          
        let groupAnimation2 = CAAnimationGroup()
        groupAnimation2.animations = [animation2, alphaAnimation2]
        // groupAnimation2.autoreverses = true
        groupAnimation2.repeatCount = Float.infinity
        groupAnimation2.duration = 1.4
          
        waveLayer2.add(groupAnimation2, forKey: nil)
    }
      
    private func stopAnimation() {
        isAnimating = false
        waveLayer1.removeAllAnimations()
        waveLayer2.removeAllAnimations()
        waveLayer1.isHidden = true
        waveLayer2.isHidden = true
    }
    
}

extension AgoraChatRoomBaseRtcUserView {
    public func refreshUser(with mic: VRRoomMic) {
        let status = VRRoomMicStatus(rawValue: mic.status) ?? .idle
        var enableIdleIcon = mic.member == nil ? true : false
        switch status {
        case .idle:
            iconView.isHidden = true
            setMicState(.on)
            self.volume = 0
        case .normal:
            iconView.isHidden = false
            if mic.member?.micStatus ?? 0 == 1 {
                setMicState(.on)
                bgIconView.isHidden = true
                nameBtn.setImage(UIImage.sceneImage(name: "", bundleName: "VoiceChatRoomResource"), for: .normal)
            } else {
                setMicState(.off)
                self.volume = 0
            }
        case .close:
            setMicState(.off)
        case .forbidden:
            setMicState(.off)
            bgIconView.isHidden = false
        case .lock:
            iconView.isHidden = true
            bgIconView.image = UIImage.sceneImage(name: "voice_ic_seat_lock", bundleName: "VoiceChatRoomResource")
            bgIconView.isHidden = false
            enableIdleIcon = false
            setMicState(.on)
            self.volume = 0
        case .forbiddenAndLock:
            iconView.isHidden = true
            setMicState(.forbidden)
            bgIconView.image = UIImage.sceneImage(name: "voice_ic_seat_lock", bundleName: "VoiceChatRoomResource")
            bgIconView.isHidden = false
            enableIdleIcon = false
        }
        if enableIdleIcon {
            bgIconView.isHidden = false
            bgIconView.image = UIImage.sceneImage(name: "voice_wuren", bundleName: "VoiceChatRoomResource")
        }
        iconView.isHidden = mic.member == nil
        if let portrait = mic.member?.portrait, portrait.hasPrefix("http") {
            iconView.sd_setImage(with: URL(string: portrait), placeholderImage: UIImage.sceneImage(name: "", bundleName: "VoiceChatRoomResource"))
        } else {
            iconView.image = UIImage(named: mic.member?.portrait ?? "")
        }
        nameBtn.setImage(UIImage.voice_image(mic.mic_index == 0 ? "Landlord" : ""), for: .normal)
        nameBtn.setTitle(mic.member?.name ?? "\(mic.mic_index + 1)", for: .normal)
    }
}
