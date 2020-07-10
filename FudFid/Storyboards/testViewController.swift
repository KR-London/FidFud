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
import CloudKit
import JellyGif


enum FirebaseCombineError: Error {
    case encodeImageFailed
    case nilResultError
    case uploadFailed
}

          let path = String((Bundle.main.path(forResource: "bac2.mov", ofType: nil)?.dropLast(8))!)
let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as NSURL
var destinationUrl = documentsUrl.appendingPathComponent("bart2.gif")

class testViewController: UIViewController {

    @IBOutlet weak var myImageView: JellyGifImageView!
    
    @IBAction func ShowmeBart(_ sender: UIButton) {
        print(destinationUrl)
         myImageView.image = UIImage.gifImageWithURL(gifUrl: destinationUrl!.absoluteString)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
     //   myImageView.image = UIImage.gifImageWithName(name: "200.gif")
        loadGifsFromCloud()

    }
    
    func loadGifsFromCloud()-> [Feed]{
        let pred = NSPredicate(value: true)
        let query = CKQuery(recordType: "Gifs", predicate:  pred)
        
        let operation = CKQueryOperation(query: query)
        
        var loadedFeed = [Feed]()
        var whatIGot = [Gif]()
        
        operation.recordFetchedBlock = {
            record in
            let gif = Gif()
            
            gif.recordID = record.recordID
            gif.category = record["category"]
            
            if let asset = record["gif"] as? CKAsset{
                gif.gif = asset.fileURL
                self.myImageView.startGif(with: .localPath(gif.gif))
            }
            
            whatIGot.append(gif)
            
            ///Feed(id: 0, url: record["gif"], path: savedContent(filename: prefix + ".MP4"), text: nil, gif: nil, sound: nil, image: nil, originalFilename: prefix + ".MP4")
        }
        
        operation.queryCompletionBlock = { [unowned self] (cursor, error) in
            DispatchQueue.main.async {
                if error == nil {
                    print(whatIGot.first?.category)
                } else {
                    //                    let ac = UIAlertController(title: "Fetch failed", message: "There was a problem fetching the list of gifs; please try again: \(error!.localizedDescription)", preferredStyle: .alert)
                    //                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    //                    self.present(ac, animated: true)
                    
                    print("There was a problem fetching the list of gifs; please try again: \(error!.localizedDescription)")
                }
            }
            
        }
        
        CKContainer.default().publicCloudDatabase.add(operation)
        
        
        return loadedFeed
    }
}
//}
