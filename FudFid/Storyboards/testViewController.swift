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
import Foundation
import FirebaseFirestore
import Combine


enum FirebaseCombineError: Error {
    case encodeImageFailed
    case nilResultError
    case uploadFailed
}

          let path = String((Bundle.main.path(forResource: "bac2.mov", ofType: nil)?.dropLast(8))!)
let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as NSURL
var destinationUrl = documentsUrl.appendingPathComponent("bart2.gif")

class testViewController: UIViewController {

    @IBOutlet weak var myImageView: UIImageView!
    
    @IBAction func ShowmeBart(_ sender: UIButton) {
        print(destinationUrl)
         myImageView.image = UIImage.gifImageWithURL(gifUrl: destinationUrl!.absoluteString)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
//        myImageView.image = UIImage.gifImageWithName(name: "200.gif")
//
//        let storageReference = Storage.storage().reference().child("centralGifs/200w-10.gif")
//        DispatchQueue.main.async {
//            // Download to the local filesystem
//            let downloadTask = storageReference.write(toFile: destinationUrl!) { url, error in
//                if let error = error {
//                    // Uh-oh, an error occurred!
//                    print("Bart has left the building \(String(error.localizedDescription))")
//                } else {
//                    print("click to see Bart")
//                }
//            }
//        }
        
        do{
            try FileManager.default.removeItem(at: destinationUrl!)
        }
        catch{
            print(error.localizedDescription)
        }
    }
}
//}
