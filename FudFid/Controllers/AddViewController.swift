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

class AddViewController: UIViewController {
    
    lazy var recordButton: UIButton = {
        let button = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 140, weight: .bold, scale: .large)
        let largeBoldVid = UIImage(systemName: "video.circle", withConfiguration: largeConfig)

        button.setImage(largeBoldVid, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .scaleToFill
        //button.backgroundImage(for: .normal) = UIImage(systemName: "video.circle")
        button.addTarget(self, action: #selector(record), for: .touchUpInside)
        return button
    }()
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        addRecordButton()
    
        // Do any additional setup after loading the view.
    }
    
    func addRecordButton(){
        
        view.addSubview(recordButton)
        
        NSLayoutConstraint.activate([
            recordButton.heightAnchor.constraint(equalToConstant: 400),
            recordButton.widthAnchor.constraint(equalToConstant: 400),
            recordButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            recordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
  @objc func record(){
        print("recording")
        VideoHelper.startMediaBrowser(delegate: self, sourceType: .camera)
        
    }
    
    @objc func video(_ videoPath: String, didFinishSavingWithError error: Error?, contextInfo info: AnyObject) {
      let title = (error == nil) ? "Success" : "Error"
      let message = (error == nil) ? "Video was saved" : "Video failed to save"
      
      let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
      present(alert, animated: true, completion: nil)
    }

}

extension AddViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [ UIImagePickerController.InfoKey: Any]) {
      dismiss(animated: true, completion: nil)
      
      guard
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String,
        mediaType == (kUTTypeMovie as String),
        let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL,
        UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(url.path)
        else {
          return
      }
      
      // Handle a movie capture
      UISaveVideoAtPathToSavedPhotosAlbum(
        url.path,
        self,
        #selector(video(_:didFinishSavingWithError:contextInfo:)),
        nil)
    }
}

extension AddViewController: UINavigationControllerDelegate {
}

