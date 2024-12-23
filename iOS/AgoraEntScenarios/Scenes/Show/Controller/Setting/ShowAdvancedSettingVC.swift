//
//  ShowAdvancedSettingVC.swift
//  AgoraEntScenarios
//
//  Created by FanPengpeng on 2022/11/14.
//

import UIKit
import AgoraRtcKit

class ShowAdvancedSettingVC: UIViewController, UIGestureRecognizerDelegate {
    
    var isPureMode = false
    var mode: ShowMode?
    var isBroadcaster = true
    var currentChannelId: String?

    private let naviBar = ShowNavigationBar()
    
    var musicManager: ShowMusicPresenter!

    private let titles = ["show_advance_setting_video_title".show_localized,
                          "show_advance_setting_audio_title".show_localized]
    
    private lazy var videoSettingVC: ShowVideoSettingVC? = {
        return createSettingVCForIndex(0)
    }()
    
    private lazy var audioSettingVC: ShowVideoSettingVC? = {
        return createSettingVCForIndex(1)
    }()
    
    private lazy var indicator: UIView = {
        let indicator = UIView()
        indicator.size = CGSize(width: 66, height: 2)
        indicator.backgroundColor = .show_zi03
        return indicator
    }()
     
    private lazy var segmentedView: AEACategoryView = {
        let layout = AEACategoryViewLayout()
        layout.itemSize = CGSize(width: Screen.width * 0.5, height: 40)
        let segmentedView = AEACategoryView(defaultLayout: layout)
        segmentedView.titles = titles
        segmentedView.delegate = self
        segmentedView.titleFont = .show_R_14
        segmentedView.titleSelectedFont = .show_navi_title
        segmentedView.titleColor = .show_Ellipse5
        segmentedView.titleSelectedColor = .show_Ellipse7
        segmentedView.backgroundColor = .clear
        segmentedView.defaultSelectedIndex = 0
        segmentedView.indicator = indicator
        return segmentedView
    }()
    
    private lazy var listContainerView: AEAListContainerView = {
        let containerView = AEAListContainerView()
        containerView.dataSource = self
        containerView.setSelectedIndex(0)
        return containerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    private func setUpUI() {
        view.backgroundColor = .white
        
        naviBar.title = "show_advanced_setting_title".show_localized
        view.addSubview(naviBar)
        
        view.addSubview(segmentedView)
        segmentedView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(naviBar.snp.bottom)
        }
        segmentedView.isHidden = !isBroadcaster
        
        view.addSubview(listContainerView)
        listContainerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            if self.isBroadcaster {
                make.top.equalTo(segmentedView.snp.bottom).offset(10)
            }else{
                make.top.equalTo(naviBar.snp.bottom).offset(10)
            }
            make.bottom.equalToSuperview()
        }
    }
    
    private func createSettingVCForIndex(_ index: Int) -> ShowVideoSettingVC? {
        var setting = [ShowSettingKey]()
        if (index == 0) { // video settings
            if (isBroadcaster && isPureMode) {
                setting = [
                    .videoEncodeSize,
                    .FPS,
                    .videoBitRate
                ]
            } else if (isBroadcaster && !isPureMode) {
                setting = [
                    .CodecType,
                    .colorEnhance,
                    .lowlightEnhance,
                    .videoDenoiser,
                    .PVC,
                    .videoEncodeSize,
                    .FPS,
                    .videoBitRate
                ]
            } else { // audience setting
                setting = [
                    .SR
                ]
            }
        } else if (index == 1) { // audio settings
            if (isBroadcaster) {
                setting = [
                    .earmonitoring,
                    .recordingSignalVolume,
                    .musicVolume,
                ]
            }
        }
        if (setting.isEmpty) {
            return nil
        }
        let vc = ShowVideoSettingVC()
        vc.isPureMode = isPureMode
        vc.musicManager = musicManager
        vc.currentChannelId = currentChannelId
        vc.dataArray = setting
        return vc
    }
}

extension ShowAdvancedSettingVC:  AEAListContainerViewDataSource{
    func listContainerView(_ listContainerView: AEAListContainerView, viewControllerForIndex index: Int) -> UIViewController? {
        if index == 0 {
            return videoSettingVC ?? UIViewController()
        }
        return audioSettingVC ?? UIViewController()
    }
}

extension ShowAdvancedSettingVC: AEACategoryViewDelegate {
    func categoryView(_ categoryView: AEACategoryView, didSelectItemat index: Int) {
        listContainerView.setSelectedIndex(index)
    }
}
