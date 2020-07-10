//
//  cloudKitPlay.swift
//  FudFid
//
//  Created by Kate Roberts on 04/07/2020.
//  Copyright © 2020 SaLT for my Squid. All rights reserved.
//
//
//import UIKit
//import CloudKit
//import AVKit
//import AVFoundation
//
//class cloudKitPlay: UIViewController {
//    
// //   let publicDB = CKContainer.default().publicCloudDatabase
//    
//   // publicDB.fetchRecordWithID(recordID, completionHandler: { (results, error) -> Void in
//    dispatch_async(dispatch_get_main_queue()) { () -> Void in
//    if error != nil {
//    /
//    println(" Error Fetching Record  " + error.localizedDescription)
//    } else {
//    if results != nil {
//    print("pulled record")
//    //
//    let record = results as CKRecord
//    let videoFile = record.objectForKey("videoFile") as! CKAsset
//    
//    //
//    //
//    self.videoURL = videoFile.fileURL as NSURL!
//    //
//    let videoData = NSData(contentsOfURL: self.videoURL!)
//    //
//    let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
//    let destinationPath = documentsPath.stringByAppendingPathComponent("filename.MOV")
//    //
//    NSFileManager.defaultManager().createFileAtPath(destinationPath,contents:videoData, attributes:nil)
//    
//    print(destinationPath)
//    //
//    let fileURL = NSURL(fileURLWithPath: destinationPath)
//    print(fileURL)
//    
//    let playerController = AVPlayerViewController()
//    print(" Step 1  ")
//    
//    //
//    //
//    self.asset = (AVAsset.assetWithURL(fileURL) as! AVURLAsset)
//    
//    print(" Step 2  ")
//    
//    //
//    let playerItem = AVPlayerItem(asset: self.asset)
//    print(" Step 3  ")
//    
//    //
//    let player = AVPlayer.playerWithPlayerItem(playerItem                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  ) as! AVPlayer
//    print(" Step 4  ")
//    
//    //
//    playerController.player = player
//    print(" Step 5  ")
//    
//    self.addChildViewController(playerController)
//    print(" Step 6  ")
//    
//    self.view.addSubview(playerController.view)
//    print(" Step 7  ")
//    
//    playerController.view.frame = self.view.frame
//    print(" Step 8  ")
//    
//    playerController.player.play()
//    print(" Step 9  ")
//    } else {
//    print("results Empty")
//    }
//    }
//    }
//    
//    })
//
////    let publicDatabase = CKContainer.default().publicCloudDatabase
////
////    var videoURL: NSURL!
////
////    @IBAction func load(sender: AnyObject) {
////
////        let predicate = NSPredicate(format: "videoName = %@", "nameOfVideoGoesHere")
////
////     //   activityIndicator.startAnimating()
////
////        let query = CKQuery(recordType: "Videos", predicate: predicate)
////
////        publicDatabase.perform(query, inZoneWith: nil) { (results, error) in
////            if error != nil {
////                DispatchQueue.main.async{
////                    self.notifyUser("Cloud Access Error",
////                                    message: error!.localizedDescription)
////                }
////            } else {
////                if results!.count > 0 {
////                    let record = results![0]
////
////                    DispatchQueue.main.async {
////
////                        let video = record.objectForKey("videoVideo") as! CKAsset
////
////                        self.videoURL = video.fileURL
////
////                        let videoData = NSData(contentsOfURL: self.videoURL!)
////
////                        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
////                        let destinationPath = NSURL(fileURLWithPath: documentsPath).URLByAppendingPathComponent("filename.mov", isDirectory: false)
////
////                        NSFileManager.defaultManager().createFileAtPath(destinationPath.path!, contents:videoData, attributes:nil)
////
////                        self.videoURL = destinationPath
////
////                        print(self.videoURL)
////
////                    }
////                } else {
////                    dispatch_async(dispatch_get_main_queue()) {
////                        self.notifyUser("No Match Found",
////                                        message: "No record matching the address was found")
////                    }
////                }
////            }
////
////            dispatch_async(dispatch_get_main_queue(), {
////                self.activityIndicator.stopAnimating()
////            })
////        }
////
////
////    }
////
////    override func prepareForSegue(segue: UIStoryboardSegue,
////                                  sender: AnyObject?) {
////        let destination = segue.destinationViewController as!
////        AVPlayerViewController
////        let url = videoURL
////        print(videoURL)
////        destination.player = AVPlayer(URL: url!)
////    }
//    
//}
