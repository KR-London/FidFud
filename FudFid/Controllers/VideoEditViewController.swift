//
//  VideoEditViewController.swift
//  FudFid
//
//  Created by Daniel Haight on 16/08/2020.
//  Copyright © 2020 SaLT for my Squid. All rights reserved.
//

import UIKit
import AVFoundation

class VideoEditViewController: UIViewController {
    
    private let editor = VideoEditor()
    
    var videoURL: URL? {
      didSet {
        loadVideo()
      }
    }
    
    private var videoView = UIView()
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private let addButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(videoView)
        self.view.addSubview(addButton)
        self.setupLayout()
        
        addButton.setTitle("do the overlay", for: .normal)
        addButton.addTarget(self, action: #selector(addOverlay), for: .touchUpInside)
    }
    
    private func setupLayout() {
//        addButton.translatesAutoresizingMaskIntoConstraints = false
//        addButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//        addButton.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        videoView.frame = self.view.bounds
        
//        videoView.translatesAutoresizingMaskIntoConstraints = false
//        videoView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        videoView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        videoView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        videoView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        addButton.center = self.view.center
        addButton.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        videoView.backgroundColor = .red
        
        loadVideo()
    }
    
    private func loadVideo() {
        guard let url = videoURL else {
            return
        }
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = videoView.bounds
        videoView.layer.addSublayer(playerLayer!)
        player?.play()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @objc func addOverlay() {
        if let url = videoURL {
            self.editor.makeBirthdayCard(fromVideoAt: url, forName: "Cassie") { exportedURL in
                if let unwrapped = exportedURL
                {
                    self.videoURL = unwrapped
                }
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
