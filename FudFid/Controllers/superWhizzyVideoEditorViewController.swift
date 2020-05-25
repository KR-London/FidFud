//
//  superWhizzyVideoEditorViewController.swift
//  FudFid
//
//  Created by Kate Roberts on 24/05/2020.
//  Copyright © 2020 SaLT for my Squid. All rights reserved.
//

import UIKit
import FirebaseAuth
import MobileCoreServices
import MediaPlayer
import AVFoundation
import FirebaseStorage
import Photos
import AVKit
//import

//let path = Bundle.main.path(forResource: "bac2.mov", ofType: nil)
//let url = URL(fileURLWithPath: path!)

class superWhizzyVideoEditorViewController: UIViewController {
    var firstAsset: AVAsset?
    var secondAsset: AVAsset?
    var audioAsset: AVAsset?
    var loadingAssetOne = false
    var playerViewController: AVPlayerViewController?
    var sentURL: URL?
    
    
    lazy var addSoundButton: systemImageButton = {
        let button = systemImageButton()
        button.setImage(UIImage(systemName: "tv.music.note"), for: .normal)
        button.addTarget(self, action: #selector(loadAudio), for: .touchUpInside)
        return button
    }()
    
    lazy var addMagicButton: systemImageButton = {
           let button = systemImageButton()
           button.setImage(UIImage(systemName: "wand.and.stars"), for: .normal)
           return button
       }()
    
    lazy var finishedButton: systemImageButton = {
            let button = systemImageButton()
            button.setImage(UIImage(systemName: "checkmark.seal"), for: .normal)
            //button.alpha = 0.2
            button.addTarget(self, action: #selector(save), for: .touchUpInside)
            return button
       }()
    
    lazy var sharingPreferenceController: UISegmentedControl = {
        let toggle = UISegmentedControl()
        toggle.insertSegment(withTitle: "Share", at: 0, animated: true)
        toggle.insertSegment(withTitle: "Just Me", at: 1, animated: true)
        toggle.selectedSegmentIndex = 0
        toggle.addTarget(self, action: #selector(toggled), for: .valueChanged)
        return toggle
    }()
    
    lazy var sharingChoiceUserFeedbackImage: UIImageView = {
        let feedback = UIImageView()
        feedback.tintColor = .placeholderText
        feedback.alpha = 0.5
        feedback.image?.withAlignmentRectInsets(UIEdgeInsets(top: -20, left: -20, bottom: -20, right: -20))
      //  alignmentRectInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
            //= UIImage().withAlignmentRectInsets(UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10))
        return feedback
    }()
    
    @IBOutlet var activityMonitor: UIActivityIndicatorView!
    
    @IBOutlet weak var containerView: UIView!
    func savedPhotosAvailable() -> Bool {
      guard !UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) else { return true }
      
//      let alert = UIAlertController(title: "Not Available", message: "No Saved Album found", preferredStyle: .alert)
//      alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
//      present(alert, animated: true, completion: nil)
      return false
    }
    
    
//    @IBOutlet weak var sharingOption: UISegmentedControl!
//
//    @IBAction func triggerSegue(_ sender: UIButton) {
//    }
//
//    @IBOutlet weak var sharingUserFeedbackImage: UIImageView!
//    @IBAction func sharingOptionControl(_ sender: UISegmentedControl) {
//        if sender.selectedSegmentIndex == 0{
//            sharingUserFeedbackImage.image = UIImage(systemName: "globe")
//        }
//        if sender.selectedSegmentIndex == 1 {
//            sharingUserFeedbackImage.image = UIImage(systemName: "eye.slash")
//        }
//    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser == nil {
            sharingPreferenceController.isHidden = true
            sharingChoiceUserFeedbackImage.isHidden = true
        }
        else{
            sharingChoiceUserFeedbackImage.image = UIImage(systemName: "globe")
        }

        
        playerViewController = AVPlayerViewController()
    //    playerViewController!.view.frame = containerView.frame
        
        self.addChild(playerViewController!)
       
        
        layoutSubviews()
     
       // playerViewController!.didMove(toParent: self)
        
        //containerView.addSubview((playerViewController!.view)!)
       // playerViewController!.view.frame = containerView.frame
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        guard let url = sentURL else {
            print("not got a URL")
            return
        }
        let player = AVPlayer(url:url)
       
        playerViewController!.player = player
        player.play()
       // self.present(playerViewController!, animated: false, completion: nil)
       // let playerLayer = AVPlayerLayer(player: player)
       // playerLayer.frame = self.view.bounds
       // let VC = AVpla
       // self.view.layer.addSublayer(playerLayer)
        
        loadAssets()
    }
    
    func layoutSubviews(){
        
        view.addSubview(playerViewController!.view)
        playerViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            playerViewController!.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playerViewController!.view.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            playerViewController!.view.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            playerViewController!.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7)
        ])
        
        playerViewController!.view.contentMode = .scaleAspectFill
        playerViewController!.view.frame = CGRect (x:300, y:300, width:200, height:400)
        
        
        
        view.addSubview(addMagicButton)
        addMagicButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addMagicButton.trailingAnchor.constraint(equalTo: playerViewController!.view.trailingAnchor, constant: 20),
            addMagicButton.bottomAnchor.constraint(equalTo: playerViewController!.view.topAnchor, constant: -10),
            addMagicButton.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07),
            addMagicButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07)
        ])
        
        view.addSubview(addSoundButton)
        addSoundButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addSoundButton.leadingAnchor.constraint(equalTo: playerViewController!.view.leadingAnchor, constant: -20),
            addSoundButton.bottomAnchor.constraint(equalTo: playerViewController!.view.topAnchor, constant: -10),
            addSoundButton.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07),
            addSoundButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07)
        ])
        
        view.addSubview(finishedButton)
        finishedButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
              finishedButton.trailingAnchor.constraint(equalTo: playerViewController!.view.trailingAnchor, constant: 20),
              finishedButton.topAnchor.constraint(equalTo: playerViewController!.view.bottomAnchor, constant: 10),
              finishedButton.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07),
              finishedButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07)
        ])
        
        view.addSubview(sharingChoiceUserFeedbackImage)
        sharingChoiceUserFeedbackImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sharingChoiceUserFeedbackImage.leadingAnchor.constraint(equalTo: finishedButton.leadingAnchor),
            sharingChoiceUserFeedbackImage.trailingAnchor.constraint(equalTo: finishedButton.trailingAnchor),
            sharingChoiceUserFeedbackImage.topAnchor.constraint(equalTo: finishedButton.topAnchor),
            sharingChoiceUserFeedbackImage.bottomAnchor.constraint(equalTo: finishedButton.bottomAnchor)
        ])
        
        view.sendSubviewToBack(sharingChoiceUserFeedbackImage)
        
        view.addSubview(sharingPreferenceController)
        sharingPreferenceController.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sharingPreferenceController.leadingAnchor.constraint(equalTo: playerViewController!.view.leadingAnchor, constant: -20),
            sharingPreferenceController.centerYAnchor.constraint(equalTo: finishedButton.centerYAnchor),
          sharingPreferenceController.trailingAnchor.constraint(equalTo: finishedButton.leadingAnchor, constant: -20),
          sharingPreferenceController.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05)
        ])

    }
    

  func exportDidFinish(_ session: AVAssetExportSession) {
        
        // Cleanup assets
      //  activityMonitor.stopAnimating()
        firstAsset = nil
        secondAsset = nil
        audioAsset = nil
        
        guard session.status == AVAssetExportSession.Status.completed,
        let outputURL = session.outputURL else { return }
        
        let saveVideoToPhotos = {
          PHPhotoLibrary.shared().performChanges({ PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: outputURL) }) { saved, error in
            let success = saved && (error == nil)
            let title = success ? "Success" : "Error"
            let message = success ? "Video saved" : "Failed to save video"
            
            DispatchQueue.main.async {
               //  let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                   //        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
                       //    self.present(alert, animated: true, completion: nil)
            }
           
          }
        }
        
        // Ensure permission to access Photo Library
        if PHPhotoLibrary.authorizationStatus() != .authorized {
          PHPhotoLibrary.requestAuthorization({ status in
            if status == .authorized {
              saveVideoToPhotos()
                if self.sharingPreferenceController.selectedSegmentIndex == 0 {
                    if Auth.auth().currentUser != nil
                    {
                        self.sendVideoToFirebase(url: outputURL)
                    }
                    else{
                        print("Can't save when user is not logged in")
                    }
                }
            }
          })
        } else {
          saveVideoToPhotos()
            if self.sharingPreferenceController.selectedSegmentIndex == 0 {
                if Auth.auth().currentUser != nil
                {
                    self.sendVideoToFirebase(url: outputURL)
                }
                else{
                    print("Can't save when user is not logged in")
                }
            }
        }
      }
    
    func sendVideoToFirebase(url: URL){
        
        // Create a root reference
        let storageRef = Storage.storage().reference()

        // Create a reference to "mountains.jpg"
      //  let mountainsRef = storageRef.child("carrot.png")
        let currentUser = Auth.auth().currentUser

        // Create a reference to 'images/mountains.jpg'
        let myImagesRef = storageRef.child("user").child(currentUser!.uid).child( String(Date.timeIntervalSinceReferenceDate).filter{$0 != "."} + "pic")
        let myVideoRef = storageRef.child("user").child(currentUser!.uid).child( String(Date.timeIntervalSinceReferenceDate).filter{$0 != "."} + "vid")
                              
        let uploadMetadata = StorageMetadata()
       // uploadMetadata.contentType = "image/png"
        uploadMetadata.contentType = "image/MP4"
         
        //UIImageJP
       //let data = exporter.
//        if let data = UIImage(named: "carrot.png")?.pngData()
//        {
//            myImagesRef.putData(data, metadata: uploadMetadata){
//                (uploadedImageMeta, error) in
//                if error != nil{
//                    print("Error happened \(String(describing: error?.localizedDescription))")
//                }else{
//                    print("Metadata of uploaded image \(String(describing: uploadedImageMeta))")
//                }
//            }
//            //uploadImage(imageData: data)
//        }
        do{ myVideoRef.putFile(from: url as! URL, metadata: uploadMetadata){
                (uploadedImageMeta, error) in
                if error != nil{
                    print("Error happened \(String(describing: error?.localizedDescription))")
                }else{
                    print("Metadata of uploaded image \(String(describing: uploadedImageMeta))")
                }
            }
        }
        catch{
            print(error.localizedDescription)
        }
                //uploadImage(imageData: data)
 
//        if let data = UIImage(named: "carrot.png")?.pngData()
//        {
//            myImagesRef.putData(data, metadata: uploadMetadata){
//                (uploadedImageMeta, error) in
//                if error != nil{
//                    print("Error happened \(String(describing: error?.localizedDescription))")
//                }else{
//                    print("Metadata of uploaded image \(String(describing: uploadedImageMeta))")
//                }
//            }
//            //uploadImage(imageData: data)
////        }
//        else{
//            print("Sending image data to firebase didn't work")
//        }

       // While the file names are the same, the references point to different files
                            //  mountainsRef.name == mountainImagesRef.name
        
    }
    
      
      func loadAssets() {
      //  if savedPhotosAvailable() {
       //   loadingAssetOne = true
       //   VideoHelper.startMediaBrowser(delegate: self, sourceType: .savedPhotosAlbum)
      //  }
        //let path = Bundle.main.path(forResource: "bac2.mov", ofType: nil)
        //let url = URL(fileURLWithPath: path!)
        guard let url = sentURL else {
            print("not got a URL")
            return
        }
        firstAsset = AVAsset(url: url)
        
//        let path2 = Bundle.main.path(forResource: "bac3.mp4", ofType: nil)
//        let url2 = URL(fileURLWithPath: path2!)
//        secondAsset = AVAsset(url: url2)
        secondAsset = firstAsset
        
      }
      
      @IBAction func loadAssetTwo(_ sender: AnyObject) {
        if savedPhotosAvailable() {
          loadingAssetOne = false
          VideoHelper.startMediaBrowser(delegate: self, sourceType: .savedPhotosAlbum)
        }
      }
      
      
    
     @objc func loadAudio(_ sender: AnyObject) {
        //let mediaPickerController = MPMediaPickerController(mediaTypes: .any)
        //mediaPickerController.delegate = self
       // mediaPickerController.prompt = "Select Audio"
        //present(mediaPickerController, animated: true, completion: nil)
        let path = Bundle.main.path(forResource: "bensound-buddy.mp3", ofType: nil)
        let url = URL(fileURLWithPath: path!)
        do{
            audioAsset = try AVAsset(url: url)
                //try AVAudioFile(forReading: url)
            mergeAudio(audioAsset!)
            
            
            
        }catch{
            print("Couldn't load that file")
        }
        //audioAsset
      }
        
    func mergeAudio(_ sender: AVAsset) {
        guard let firstAsset = firstAsset, let secondAsset = secondAsset else { return }
        
        
        //activityMonitor.startAnimating()
        
        // 1 - Create AVMutableComposition object. This object will hold your AVMutableCompositionTrack instances.
        let mixComposition = AVMutableComposition()
        
        // 2 - Create two video tracks
        guard let firstTrack = mixComposition.addMutableTrack(withMediaType: .video,
                                                              preferredTrackID: Int32(kCMPersistentTrackID_Invalid)) else { return }
        do {
          try firstTrack.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: firstAsset.duration),
                                         of: firstAsset.tracks(withMediaType: .video)[0],
                                         at: CMTime.zero)
        } catch {
          print("Failed to load first track")
          return
        }
       // firstTrack.im = UIImage.Orientation.up
            //mixComposition.preferredTransform
        
        let secondTrack = firstTrack
        
        
        // 2.1
        let mainInstruction = AVMutableVideoCompositionInstruction()
        mainInstruction.timeRange = CMTimeRangeMake(start: CMTime.zero, duration: firstAsset.duration)

        // 2.2
        let firstInstruction = VideoHelper.videoCompositionInstruction(firstTrack, asset: firstAsset)
        firstInstruction.setOpacity(0.0, at: firstAsset.duration)
        let secondInstruction = VideoHelper.videoCompositionInstruction(secondTrack, asset: firstAsset)

        // 2.3
        mainInstruction.layerInstructions = [firstInstruction]
        let mainComposition = AVMutableVideoComposition()
        mainComposition.instructions = [mainInstruction]
       // mainInstruction.
        mainComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
        mainComposition.renderSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
       // mixComposition.preferredTransform = firstTrack.preferredTransform
         
      

        // 3 - Audio track
      //  if let loadedAudioAsset = sender {
          let audioTrack = mixComposition.addMutableTrack(withMediaType: .audio, preferredTrackID: 0)
          do {
            try audioTrack?.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: firstAsset.duration),
                                            of: sender.tracks(withMediaType: .audio)[0] ,
                                            at: CMTime.zero)
          } catch {
            print("Failed to load Audio track")
          }
      //  }
        
        
      //  mixComposition.
        
        playerViewController?.player?.replaceCurrentItem(with: AVPlayerItem(asset: mixComposition))
    
        playerViewController?.player?.play()
        //playerViewController?.player = AVPlayer(playerItem: AVPlayerItem())
        
//        // 4 - Get path
//        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .long
//        dateFormatter.timeStyle = .short
//        let date = dateFormatter.string(from: Date())
//        let url = documentDirectory.appendingPathComponent("mergeVideo-\(date).mov")
//
//        // 5 - Create Exporter
//        guard let exporter = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality) else { return }
//        exporter.outputURL = url
//        exporter.outputFileType = AVFileType.mov
//        exporter.shouldOptimizeForNetworkUse = true
//        exporter.videoComposition = mainComposition
//
//        // 6 - Perform the Export
//        exporter.exportAsynchronously() {
//          DispatchQueue.main.async {
//            self.exportDidFinish(exporter)
//          }
 //      }
//      }
      
    }

    @objc func save(){

        
           // 4 - Get path
            guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .short
            let date = dateFormatter.string(from: Date())
            let url = documentDirectory.appendingPathComponent("mergeVideo-\(date).mov")
    
            // 5 - Create Exporter
            guard let exporter = AVAssetExportSession(asset: (playerViewController?.player?.currentItem!.asset)!, presetName: AVAssetExportPresetHighestQuality) else { return }
            exporter.outputURL = url
            exporter.outputFileType = AVFileType.mov
            exporter.shouldOptimizeForNetworkUse = true
           // exporter.videoComposition = mainComposition
        
    
            // 6 - Perform the Export
            exporter.exportAsynchronously() {
              DispatchQueue.main.async {
                self.exportDidFinish(exporter)
              }
           }
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let newViewController = storyBoard.instantiateViewController(withIdentifier: "celebrationVCscreen")
                      
                    //  let newViewController = storyBoard.instantiateViewController(withIdentifier: "superWhizzyVideoEditor") as! superWhizzyVideoEditorViewController
                              self.present(newViewController, animated: true, completion: nil)
            
          }
//    }
    
      
//    func merge(_ sender: AnyObject) {
//        guard let firstAsset = firstAsset, let secondAsset = secondAsset else { return }
//        
//        
//        //activityMonitor.startAnimating()
//        
//        // 1 - Create AVMutableComposition object. This object will hold your AVMutableCompositionTrack instances.
//        let mixComposition = AVMutableComposition()
//        
//        // 2 - Create two video tracks
//        guard let firstTrack = mixComposition.addMutableTrack(withMediaType: .video,
//                                                              preferredTrackID: Int32(kCMPersistentTrackID_Invalid)) else { return }
//        do {
//          try firstTrack.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: firstAsset.duration),
//                                         of: firstAsset.tracks(withMediaType: .video)[0],
//                                         at: CMTime.zero)
//        } catch {
//          print("Failed to load first track")
//          return
//        }
//        
//        guard let secondTrack = mixComposition.addMutableTrack(withMediaType: .video,
//                                                               preferredTrackID: Int32(kCMPersistentTrackID_Invalid)) else { return }
//        do {
//          try secondTrack.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: secondAsset.duration),
//                                          of: secondAsset.tracks(withMediaType: .video)[0],
//                                          at: firstAsset.duration)
//        } catch {
//          print("Failed to load second track")
//          return
//        }
//        
//        // 2.1
//        let mainInstruction = AVMutableVideoCompositionInstruction()
//        mainInstruction.timeRange = CMTimeRangeMake(start: CMTime.zero, duration: CMTimeAdd(firstAsset.duration, secondAsset.duration))
//        
//        // 2.2
//        let firstInstruction = VideoHelper.videoCompositionInstruction(firstTrack, asset: firstAsset)
//        firstInstruction.setOpacity(0.0, at: firstAsset.duration)
//        let secondInstruction = VideoHelper.videoCompositionInstruction(secondTrack, asset: secondAsset)
//        
//        // 2.3
//        mainInstruction.layerInstructions = [firstInstruction, secondInstruction]
//        let mainComposition = AVMutableVideoComposition()
//        mainComposition.instructions = [mainInstruction]
//        mainComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
//        mainComposition.renderSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
//        
//        // 3 - Audio track
//        if let loadedAudioAsset = audioAsset {
//          let audioTrack = mixComposition.addMutableTrack(withMediaType: .audio, preferredTrackID: 0)
//          do {
//            try audioTrack?.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: CMTimeAdd(firstAsset.duration, secondAsset.duration)),
//                                            of: loadedAudioAsset.tracks(withMediaType: .audio)[0] ,
//                                            at: CMTime.zero)
//          } catch {
//            print("Failed to load Audio track")
//          }
//        }
//        
//        // 4 - Get path
//        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .long
//        dateFormatter.timeStyle = .short
//        let date = dateFormatter.string(from: Date())
//        let url = documentDirectory.appendingPathComponent("mergeVideo-\(date).mov")
//        
//        // 5 - Create Exporter
//        guard let exporter = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality) else { return }
//        exporter.outputURL = url
//        exporter.outputFileType = AVFileType.mov
//        exporter.shouldOptimizeForNetworkUse = true
//        exporter.videoComposition = mainComposition
//        
//        // 6 - Perform the Export
//        exporter.exportAsynchronously() {
//          DispatchQueue.main.async {
//            self.exportDidFinish(exporter)
//          }
//        }
//      }
      
    }

    extension superWhizzyVideoEditorViewController: UIImagePickerControllerDelegate {
      func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        
        guard let mediaType = info[UIImagePickerController.InfoKey.mediaType.rawValue] as? String,
          mediaType == (kUTTypeMovie as String),
          let url = info[UIImagePickerController.InfoKey.mediaURL.rawValue] as? URL
          else { return }
        
        let avAsset = AVAsset(url: url)
        var message = ""
        if loadingAssetOne {
          message = "Video one loaded"
          firstAsset = avAsset
        } else {
          message = "Video two loaded"
          secondAsset = avAsset
        }
        //let alert = UIAlertController(title: "Asset Loaded", message: message, preferredStyle: .alert)
       // alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
       // present(alert, animated: true, completion: nil)
      }
      
    }

    extension superWhizzyVideoEditorViewController: UINavigationControllerDelegate {

    }

    extension superWhizzyVideoEditorViewController: MPMediaPickerControllerDelegate {
      
        func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        
            dismiss(animated: true) {
                let selectedSongs = mediaItemCollection.items
                guard let song = selectedSongs.first else { return }
          
                let url = song.value(forProperty: MPMediaItemPropertyAssetURL) as? URL
                self.audioAsset = (url == nil) ? nil : AVAsset(url: url!)
                let title = (url == nil) ? "Asset Not Available" : "Asset Loaded"
                let message = (url == nil) ? "Audio Not Loaded" : "Audio Loaded"
          
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
      
        func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        dismiss(animated: true, completion: nil)
        }
        
        
        @objc func toggled(sender: UISegmentedControl){
             if sender.selectedSegmentIndex == 0{
                sharingChoiceUserFeedbackImage.image = UIImage(systemName: "globe")
            }
            if sender.selectedSegmentIndex == 1 {
                sharingChoiceUserFeedbackImage.image = UIImage(systemName: "eye.slash")
            }
        }
    }
