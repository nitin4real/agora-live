//
//  VMSoundView.swift
//  AgoraScene_iOS
//
//  Created by CP on 2022/10/9.
//

import Foundation
import UIKit

class VMSoundView: UIView {
    lazy var cover: UIView = {
        UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 56)).backgroundColor(.clear).setGradient([UIColor(red: 0.929, green: 0.906, blue: 1, alpha: 1), UIColor(red: 1, green: 1, blue: 1, alpha: 0.3)], [CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 1)])
    }()

    private var bgView: UIView = .init()
    private var screenWidth: CGFloat = UIScreen.main.bounds.size.width - 40
    private var typeLabel: UILabel = .init()
    private var detailLabel: UILabel = .init()

    private var soundEffect: Int = 1
    private var typeStr: String = ""
    private var detailStr: String = ""
    private var images = [["wangyi", "momo", "pipi", "yinyu"], ["wangyi", "jiamian", "yinyu", "paipaivoice", "wanba", "qingtian", "skr", "soul"], ["yalla-ludo", "jiamian"], ["qingmang", "cowLive", "yuwan", "weibo"]]
    private var iconImgs: [String]?

    public init(frame: CGRect, soundEffect: Int) {
        super.init(frame: frame)
        setSoundEffect(soundEffect)
        layoutUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public var cellHeight: CGFloat = 0

    private func layoutUI() {
        bgView.backgroundColor = .white
        addSubview(bgView)

        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 20.0, height: 20.0))
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        self.layer.mask = layer

        bgView.addSubview(cover)

        typeLabel.text = typeStr
        typeLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        typeLabel.textColor = UIColor(red: 0.016, green: 0.035, blue: 0.145, alpha: 1)
        typeLabel.textAlignment = .center
        bgView.addSubview(typeLabel)

        detailLabel.text = detailStr
        detailLabel.textAlignment = .left
        detailLabel.numberOfLines = 0
        detailLabel.textColor = UIColor(red: 0.235, green: 0.257, blue: 0.403, alpha: 1)
        detailLabel.font = UIFont.systemFont(ofSize: 13)
        detailLabel.lineBreakMode = .byCharWrapping
        bgView.addSubview(detailLabel)

        guard let iconImgs = iconImgs else {
            return
        }
        var basetag = 0
        switch soundEffect {
        case 1:
            basetag = 110
        case 2:
            basetag = 120
        case 3:
            basetag = 130
        default:
            basetag = 140
        }
        for (index, value) in iconImgs.enumerated() {
            let imgView = UIImageView()
            imgView.image = UIImage.voice_image(value)
            imgView.tag = basetag + index
            addSubview(imgView)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        bgView.frame = CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height)
        typeLabel.frame = CGRect(x: 20, y: 32, width: bounds.size.width - 40, height: 18)
        detailLabel.frame = CGRect(x: 20, y: 60, width: bounds.size.width - 40, height: cellHeight)
    }

    func textHeight(text: String, fontSize: CGFloat, width: CGFloat) -> CGFloat {
        return text.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [.font: UIFont.systemFont(ofSize: fontSize)], context: nil).size.height + 5
    }

    private func setSoundEffect(_ effect: Int) {
        soundEffect = effect
        switch effect {
        case 1:
            detailStr = "voice_chatroom_social_chat_introduce".voice_localized
            iconImgs = images[0]
            typeStr = "voice_social_chat".voice_localized
        case 2:
            detailStr = "voice_chatroom_karaoke_introduce".voice_localized
            iconImgs = images[1]
            typeStr = "voice_karaoke".voice_localized
        case 3:
            detailStr = "voice_chatroom_gaming_buddy_introduce".voice_localized
            iconImgs = images[2]
            typeStr = "voice_gaming_buddy".voice_localized
        default:
            detailStr = "voice_chatroom_professional_broadcaster_introduce".voice_localized
            iconImgs = images[3]
            typeStr = "voice_professional_podcaster".voice_localized
        }
        cellHeight = textHeight(text: detailStr, fontSize: 13, width: bounds.size.width - 40)
    }
}
