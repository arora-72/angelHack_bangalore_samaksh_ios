//
//  stingViewController.swift
//  Rinnegan
//
//  Created by Indresh Arora on 10/06/18.
//  Copyright © 2018 Indresh Arora. All rights reserved.
//

import UIKit
import AgoraRtcEngineKit

class stingViewController: UIViewController,AgoraRtcEngineDelegate {
    
    var agoraKit: AgoraRtcEngineKit!
    
    @IBOutlet weak var videoView: UIView!
    func initializeAgoraEngine() {
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: "14ec9436bed34a129c914cee243cbf84", delegate: self as! AgoraRtcEngineDelegate)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeAgoraEngine()
        setupVideo()
        agoraKit.setClientRole(.broadcaster)
        setupLocalVideo()
        joinChannel()
        cancelButton()
        switchCameraBtn()
    }

    func setupLocalVideo(){
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = 0
        videoCanvas.view = videoView
        agoraKit.setupLocalVideo(videoCanvas)
    }
    
    
    func setupVideo() {
        agoraKit.enableVideo()  // Default mode is disableVideo
        agoraKit.setVideoProfile(AgoraVideoProfile.DEFAULT, swapWidthAndHeight: false)
        
    }
    
    func joinChannel(){
        agoraKit.joinChannel(byToken: nil, channelId: "demoChannel", info: nil, uid: 0) { [weak self](sid, uid, elapsed) -> Void in
            
            if let weakSelf = self{
                weakSelf.agoraKit.setEnableSpeakerphone(true)
                UIApplication.shared.isIdleTimerDisabled = true
                
            }
        }
    }
    
    func switchCameraBtn(){
        let button = UIButton(frame: CGRect(x: 20.0, y: self.view.frame.height - 100.0, width: 50, height: 50))
        button.setBackgroundImage(UIImage(named: "Photo Camera Icon"), for: .normal)
        button.addTarget(self, action: #selector(switchCamera(_:)), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    @IBAction func switchCamera(_ sender: Any) {
       agoraKit.switchCamera()
    }
    
    func cancelButton(){
        let button = UIButton(frame:CGRect(x: self.view.frame.width/2 - 25, y: self.view.frame.height - 100.0, width: 50, height: 50))
        button.titleLabel?.text = "END"
       button.backgroundColor = UIColor.red
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    @objc func buttonAction(sender: UIButton){
        print("button tapped")
        leaveChannel()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func leaveChannel(){
        agoraKit.leaveChannel(nil)
        UIApplication.shared.isIdleTimerDisabled = false
        agoraKit = nil
        
    }
    
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let engine = AgoraRtcEngineKit.sharedEngine(withAppId: "14ec9436bed34a129c914cee243cbf84", delegate: self as? AgoraRtcEngineDelegate)
//        engine.setChannelProfile(.liveBroadcasting)
//        engine.setClientRole(.broadcaster)
//        engine.joinChannel(byToken: nil, channelId: "StingChannel", info: nil, uid: 0, joinSuccess: nil)
//
//        // Do any additional setup after loading the view.
//    }
    
   

   
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

