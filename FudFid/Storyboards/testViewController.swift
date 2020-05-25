//
//  testViewController.swift
//  FudFid
//
//  Created by Kate Roberts on 25/05/2020.
//  Copyright © 2020 SaLT for my Squid. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import ProgressHUD
import FirebaseUI

class testViewController: UIViewController {

    @IBOutlet weak var myImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
//
//       // myImageView.image = UIImage(contentsOfFile: "https://firebasestorage.googleapis.com/v0/b/fudfid.appspot.com/o/centralGifs%2F200-5.gif?alt=media&token=f590a7c0-995b-4aea-994e-b4f4efa62ea5")
//
//        let downloadTask = URL
//
//
        
                let storageReference = Storage.storage().reference()
        
               // let imageDownloadURLReference = storageReference.child("centralImages/fbtestpic.jpeg")
        let imageDownloadURLReference = storageReference.child("centralGifs/")
        var allGifs = [StorageReference]()
            
        let fileContents = imageDownloadURLReference.listAll{ (result, error) in
            if let error = error {
                // ...
            }
            for prefix in result.prefixes {
                // The prefixes under storageReference.
                // You may call listAll(completion:) recursively on them.
            }
            for item in result.items {
                allGifs.append(item)
            }
        }
        
                // Create a reference to the file you want to download
                //let starsRef = storageRef.child("images/stars.jpg")
//        for i in 1 ... 15
//        {
//                // Fetch the download URL
//                imageDownloadURLReference.downloadURL { url, error in
//                    if let error = error {
//                        print(error.localizedDescription)
//                    } else {
//                        print("image url me got is \(String(describing: url!))")
//                    }
//                }
//
//                // Create local filesystem URL
//                let path = String((Bundle.main.path(forResource: "bac2.mov", ofType: nil)?.dropLast(8))!)
//                let localURL = URL(string: "file://" + path + "fbtestpic.jpeg")!
//
//                // Download to the local filesystem
//                let downloadTask = imageDownloadURLReference.write(toFile: localURL) { url, error in
//                    if let error = error {
//                        print(error.localizedDescription)
//                    } else {
//                        print("Hurrah!")
//                    }
//                }
//
 //       myImageView.sd_setImage(with: imageDownloadURLReference, placeholderImage: UIImage(named: "peas.jpg"))
       // myImageView.image = UIImage(named: "fbtestpic.jpeg")
        
//        let downloadTask = imageDownloadURLReference.write(toFile: localURL) { url, error in
//                        if let error = error {
//                            print(error.localizedDescription)
//                        } else {
//                            print("Hurrah!")
//                        }
//                    }
//        
        //.enqueue(<#T##self: StorageDownloadTask##StorageDownloadTask#>)
//
//        let storageReference = Storage.storage().reference()
//
//        let imageDownloadURLReference = storageReference.child("centralGifs/200-5.gif")
//
//        // Create a reference to the file you want to download
//        //let starsRef = storageRef.child("images/stars.jpg")
//
//        // Fetch the download URL
//        imageDownloadURLReference.downloadURL { url, error in
//            if let error = error {
//                print(error.localizedDescription)
//            } else {
//                print("image url me got is \(String(describing: url!))")
//            }
//        }
//
//        // Create local filesystem URL
//        let path = String((Bundle.main.path(forResource: "bac2.mov", ofType: nil)?.dropLast(8))!)
//        let localURL = URL(string: "file://" + path + "test.gif")!
//
//        // Download to the local filesystem
//        let downloadTask = imageDownloadURLReference.write(toFile: localURL) { url, error in
//            if let error = error {
//                print(error.localizedDescription)
//            } else {
//                print("Hurrah!")
//            }
//        }
//
//        myImageView.image = UIImage.gifImageWithName(name: "test.gif")
        
    }
}
