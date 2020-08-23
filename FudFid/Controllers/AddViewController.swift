//
//  SecondViewController.swift
//  FudFid
//
//  Created by Kate Roberts on 24/05/2020.
//  Copyright © 2020 SaLT for my Squid. All rights reserved.
//

import UIKit
import AVKit
import MobileCoreServices
import FirebaseAuth
import FirebaseStorage
import YPImagePicker

class AddViewControllerNew: YPImagePicker, UIAdaptivePresentationControllerDelegate {
    required init?(coder: NSCoder) {
        var config = YPImagePickerConfiguration()
        config.isScrollToChangeModesEnabled = true
        config.onlySquareImagesFromCamera = true
        config.usesFrontCamera = false
        config.showsPhotoFilters = true
        config.showsVideoTrimmer = true
        config.shouldSaveNewPicturesToAlbum = true
        config.albumName = "DefaultYPImagePickerAlbumName"
        config.startOnScreen = YPPickerScreen.video
        config.screens = [.library, .video]
        config.showsCrop = .none
        config.targetImageSize = YPImageSize.original
        config.overlayView = UIView()
        config.hidesStatusBar = true
        config.hidesBottomBar = false
        config.hidesCancelButton = false
        config.preferredStatusBarStyle = UIStatusBarStyle.default
        config.maxCameraZoomFactor = 1.0

        config.library.options = nil
        config.library.onlySquare = false
        config.library.isSquareByDefault = true
        config.library.minWidthForItem = nil
        config.library.mediaType = YPlibraryMediaType.video
        config.library.defaultMultipleSelection = false
        config.library.maxNumberOfItems = 1
        config.library.minNumberOfItems = 1
        config.library.numberOfItemsInRow = 4
        config.library.spacingBetweenItems = 1.0
        config.library.skipSelectionsGallery = false
        config.library.preselectedItems = nil

        config.video.compression = AVAssetExportPresetHighestQuality
        config.video.fileType = .mov
        config.video.recordingTimeLimit = 10.0
        config.video.libraryTimeLimit = 60.0
        config.video.minimumTimeLimit = 0
        config.video.trimmerMaxDuration = 60.0
        config.video.trimmerMinDuration = 3.0

        config.gallery.hidesRemoveButton = false
        
        YPImagePickerConfiguration.shared = config
        

        super.init(coder: coder)
        
        self.didFinishPicking { (items, cancelled) in
            guard
                let item = items.first,
                case let .video(v: videoItem) = item else {
                fatalError()
            }
            let url = videoItem.url
            let vc = VideoEditViewController()
            vc.videoURL = url
            vc.view.backgroundColor = .white
            vc.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.pop))
            self.pushViewController(vc, animated: true)
        }
    }
    
    @objc func pop() {
        self.popToRootViewController(animated: true)
    }
    
    required init(configuration: YPImagePickerConfiguration) {
        super.init(configuration: configuration)
    }
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

