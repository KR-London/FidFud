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
import Photos

class superWhizzyVideoEditorViewController: UIViewController {
    var firstAsset: AVAsset?
     var secondAsset: AVAsset?
     var audioAsset: AVAsset?
     var loadingAssetOne = false
    
    @IBOutlet var activityMonitor: UIActivityIndicatorView!
    
    func savedPhotosAvailable() -> Bool {
      guard !UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) else { return true }
      
//      let alert = UIAlertController(title: "Not Available", message: "No Saved Album found", preferredStyle: .alert)
//      alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
//      present(alert, animated: true, completion: nil)
      return false
    }
    
    
    @IBOutlet weak var sharingOption: UISegmentedControl!
    
    @IBAction func triggerSegue(_ sender: UIButton) {
    }
    
    @IBOutlet weak var sharingUserFeedbackImage: UIImageView!
    @IBAction func sharingOptionControl(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            sharingUserFeedbackImage.image = UIImage(systemName: "globe")
        }
        if sender.selectedSegmentIndex == 1 {
            sharingUserFeedbackImage.image = UIImage(systemName: "eye.slash")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser == nil {
            sharingOption.isHidden == true
            sharingUserFeedbackImage.isHidden == true
        }

        // Do any additional setup after loading the view.
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
                 let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                           alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
                           self.present(alert, animated: true, completion: nil)
            }
           
          }
        }
        
        // Ensure permission to access Photo Library
        if PHPhotoLibrary.authorizationStatus() != .authorized {
          PHPhotoLibrary.requestAuthorization({ status in
            if status == .authorized {
              saveVideoToPhotos()
            }
          })
        } else {
          saveVideoToPhotos()
        }
      }
      
      @IBAction func loadAssetOne(_ sender: AnyObject) {
      //  if savedPhotosAvailable() {
       //   loadingAssetOne = true
       //   VideoHelper.startMediaBrowser(delegate: self, sourceType: .savedPhotosAlbum)
      //  }
        let path = Bundle.main.path(forResource: "bac2.mov", ofType: nil)
        let url = URL(fileURLWithPath: path!)
        firstAsset = AVAsset(url: url)
        
        let path2 = Bundle.main.path(forResource: "bac3.mp4", ofType: nil)
        let url2 = URL(fileURLWithPath: path2!)
        secondAsset = AVAsset(url: url2)
        
      }
      
      @IBAction func loadAssetTwo(_ sender: AnyObject) {
        if savedPhotosAvailable() {
          loadingAssetOne = false
          VideoHelper.startMediaBrowser(delegate: self, sourceType: .savedPhotosAlbum)
        }
      }
      
      @IBAction func loadAudio(_ sender: AnyObject) {
        //let mediaPickerController = MPMediaPickerController(mediaTypes: .any)
        //mediaPickerController.delegate = self
       // mediaPickerController.prompt = "Select Audio"
        //present(mediaPickerController, animated: true, completion: nil)
        let path = Bundle.main.path(forResource: "bensound-buddy.mp3", ofType: nil)
        let url = URL(fileURLWithPath: path!)
        do{
            audioAsset = try AVAsset(url: url)
                //try AVAudioFile(forReading: url)
        }catch{
            print("Couldn't load that file")
        }
        //audioAsset
      }
        
      @IBAction func merge(_ sender: AnyObject) {
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
        
        guard let secondTrack = mixComposition.addMutableTrack(withMediaType: .video,
                                                               preferredTrackID: Int32(kCMPersistentTrackID_Invalid)) else { return }
        do {
          try secondTrack.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: secondAsset.duration),
                                          of: secondAsset.tracks(withMediaType: .video)[0],
                                          at: firstAsset.duration)
        } catch {
          print("Failed to load second track")
          return
        }
        
        // 2.1
        let mainInstruction = AVMutableVideoCompositionInstruction()
        mainInstruction.timeRange = CMTimeRangeMake(start: CMTime.zero, duration: CMTimeAdd(firstAsset.duration, secondAsset.duration))
        
        // 2.2
        let firstInstruction = VideoHelper.videoCompositionInstruction(firstTrack, asset: firstAsset)
        firstInstruction.setOpacity(0.0, at: firstAsset.duration)
        let secondInstruction = VideoHelper.videoCompositionInstruction(secondTrack, asset: secondAsset)
        
        // 2.3
        mainInstruction.layerInstructions = [firstInstruction, secondInstruction]
        let mainComposition = AVMutableVideoComposition()
        mainComposition.instructions = [mainInstruction]
        mainComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
        mainComposition.renderSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        // 3 - Audio track
        if let loadedAudioAsset = audioAsset {
          let audioTrack = mixComposition.addMutableTrack(withMediaType: .audio, preferredTrackID: 0)
          do {
            try audioTrack?.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: CMTimeAdd(firstAsset.duration, secondAsset.duration)),
                                            of: loadedAudioAsset.tracks(withMediaType: .audio)[0] ,
                                            at: CMTime.zero)
          } catch {
            print("Failed to load Audio track")
          }
        }
        
        // 4 - Get path
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        let date = dateFormatter.string(from: Date())
        let url = documentDirectory.appendingPathComponent("mergeVideo-\(date).mov")
        
        // 5 - Create Exporter
        guard let exporter = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality) else { return }
        exporter.outputURL = url
        exporter.outputFileType = AVFileType.mov
        exporter.shouldOptimizeForNetworkUse = true
        exporter.videoComposition = mainComposition
        
        // 6 - Perform the Export
        exporter.exportAsynchronously() {
          DispatchQueue.main.async {
            self.exportDidFinish(exporter)
          }
        }
      }
      
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
        let alert = UIAlertController(title: "Asset Loaded", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        present(alert, animated: true, completion: nil)
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
    }
