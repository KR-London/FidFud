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

class AddViewController: UIViewController {
    private let editor = VideoEditor()
    var pickedURL: URL?
    
    lazy var recordButton: UIButton = {
        let button = UIButton()
        if #available(iOS 13.0, *) {
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 140, weight: .bold, scale: .large)
               let largeBoldVid = UIImage(systemName: "video.circle", withConfiguration: largeConfig)
             button.setImage(largeBoldVid, for: .normal)
        } else {
            //FIXME: iOS12 alternative
            button.setImage("🎥".emojiImage(), for: .normal)
            button.imageView?.sizeThatFits(CGSize(width: 200,height: 200))
            button.setTitle("Record 10sec video", for: .normal)
        }
     
        
       
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .scaleToFill
        //button.backgroundImage(for: .normal) = UIImage(systemName: "video.circle")
        button.addTarget(self, action: #selector(record), for: .touchUpInside)
        return button
    }()
    
    lazy var instruction: myLabel = {
        let label = myLabel()
        
        //FIXME: text clips the outside
        label.text = "Press to record 10 seconds of Fud Fun for your Fud Fid!"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    lazy var thumbsUp: UIImageView = {
        let imageView = UIImageView()
        imageView.image = "👍".emojiImage()
        //imageView.image = UIImage(named: "carrot.png")
        return imageView
    }()
    
    @IBAction func unwindToAdd(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source
        showThumbsUp()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        /// I pop up an encouragement to register 
        if Auth.auth().currentUser == nil{
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "signIn") as! signInViewController
            self.present(newViewController, animated: true, completion: nil)
        }
        
        addRecordButton()
    }
    
    /// This is called when you return back from uploading a video
    func showThumbsUp(){
        view.addSubview(thumbsUp)
        thumbsUp.alpha = 1
        thumbsUp.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            thumbsUp.heightAnchor.constraint(equalToConstant: 100),
            thumbsUp.widthAnchor.constraint(equalToConstant: 100),
            thumbsUp.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            thumbsUp.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        view.reloadInputViews()
        view.bringSubviewToFront(thumbsUp)
        
        UIView.animate(withDuration: 1, animations: {
            self.thumbsUp.transform = CGAffineTransform(scaleX: 4, y: 4)
        }) { (finished) in
            UIView.animate(withDuration: 1, animations: {
                self.thumbsUp.transform = CGAffineTransform.identity
            }){
                (finished) in
                UIView.animate(withDuration: 1.5, animations: {
                    self.thumbsUp.alpha = 0
                })
            }
        }
    }
    
    func addRecordButton(){
        view.addSubview(instruction)
        view.addSubview(recordButton)
        
        NSLayoutConstraint.activate([
            recordButton.heightAnchor.constraint(equalToConstant: 400),
            recordButton.widthAnchor.constraint(equalToConstant: 400),
            recordButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            recordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            instruction.heightAnchor.constraint(equalToConstant: 100),
            instruction.widthAnchor.constraint(equalToConstant: 400),
            instruction.bottomAnchor.constraint(equalTo: recordButton.topAnchor, constant: 50),
            instruction.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc func record(){
        VideoHelper.startMediaBrowser(delegate: self, sourceType: .camera)
    }
    
    @objc func video(_ videoPath: String, didFinishSavingWithError error: Error?, contextInfo info: AnyObject) {
        let title = (error == nil) ? "Success" : "Error"
        let message = (error == nil) ? "Video was saved" : "Video failed to save"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    //Go to the next screen where I will add sound and visual effects
    @objc func mySegue(_ url: URL){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
       // let newViewController = storyBoard.instantiateViewController(withIdentifier: "superWhizzyVideoEditor") as! superWhizzyVideoEditorViewController
        //let newViewController = storyBoard.instantiateViewController(withIdentifier: "videoEffectsViewController") as! videoEffectsViewController
       // newViewController.videoURL = url
       // self.present(newViewController, animated: true, completion: nil)
        
        self.editor.makeBirthdayCard(fromVideoAt: url, forName: "Cassie") { exportedURL in
            self.showCompleted()
            guard let exportedURL = exportedURL else {
                return
            }
            self.pickedURL = exportedURL
            self.performSegue(withIdentifier: "showVideo", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let url = pickedURL,
            let destination = segue.destination as? videoEffectsViewController
            else {
                return
        }
        
        destination.videoURL = url
            //?? URL(string: "https://images.all-free-download.com/footage_preview/mp4/apple_179.mp4")
    }
    
    func showCompleted() {
        //  activityIndicator.stopAnimating()
        //  imageView.alpha = 1
        //  pickButton.isEnabled = true
        //    recordButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }

}


extension AddViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [ UIImagePickerController.InfoKey: Any]) {
        dismiss(animated: true, completion: nil)
        
        guard let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String,
            mediaType == (kUTTypeMovie as String),
            let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL,
            UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(url.path)
            else {
                return
        }

        UISaveVideoAtPathToSavedPhotosAlbum(url.path, self, nil, nil)
        
        mySegue(url)
    }
}

extension AddViewController: UINavigationControllerDelegate {
}

