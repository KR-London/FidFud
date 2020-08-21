//
//  videoEffectsViewController.swift
//  FudFid
//
//  Created by Kate Roberts on 19/06/2020.
//  Copyright © 2020 SaLT for my Squid. All rights reserved.
//

import UIKit
import AVKit
import Photos

class VideoEffectsViewController: UIViewController {

    //var videoURL: URL!
    var videoURL =    URL(string: "https://images.all-free-download.com/footage_preview/mp4/apple_179.mp4")!
    
    private var player: AVPlayer!
    private var playerLayer: AVPlayerLayer!
    
    @IBOutlet weak var videoView: UIView!
    
//    @IBAction func saveVideoButtonTapped(_ sender: Any) {
//        PHPhotoLibrary.requestAuthorization { [weak self] status in
//            switch status {
//                case .authorized:
//                    self?.saveVideoToPhotos()
//                default:
//                    print("Photos permissions not granted.")
//                    return
//            }
//        }
//    }
    
    private func saveVideoToPhotos() {
        PHPhotoLibrary.shared().performChanges( {
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: self.videoURL)
        }) { [weak self] (isSaved, error) in
            if isSaved {
                print("Video saved.")
            } else {
                print("Cannot save video.")
                print(error ?? "unknown error")
            }
            DispatchQueue.main.async {
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        player = AVPlayer(url: videoURL)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = videoView.bounds
        videoView.layer.addSublayer(playerLayer)
        player.play()
        
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: nil,
            queue: nil) { [weak self] _ in self?.restart() }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        playerLayer.frame = videoView.bounds
    }
    
    private func restart() {
        player.seek(to: .zero)
        player.play()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(
            self,
            name: .AVPlayerItemDidPlayToEndTime,
            object: nil)
    }
}
