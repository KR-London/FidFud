//
//  myAVPlayerViewController.swift
//  FudFid
//
//  Created by Kate Roberts on 04/07/2020.
//  Copyright © 2020 SaLT for my Squid. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import CloudKit


class MyAVPlayerViewController: AVPlayerViewController {
    
    // MARK: - iCloud Info
    let container = CKContainer.default()
    let publicDB = CKContainer.default().publicCloudDatabase
    let privateDB = CKContainer.default().privateCloudDatabase

    override func viewDidLoad() {

        super.viewDidLoad()
        let predicate = NSPredicate(value: true)
        
        let query = CKQuery(recordType: "Video", predicate: predicate)
        
        establishments(forQuery: query)
       
        // Do any additional setup after loading the view.
    }
    
    private func establishments(forQuery query: CKQuery) {
        publicDB.perform(query, inZoneWith: CKRecordZone.default().zoneID){
            [weak self] results, error in
           // guard let self = self else {return}
            if let error = error {
                DispatchQueue.main.async{
                   // completion(error)
                }
                return
            }
            guard let results = results else { return }
            //        self.establishments = results.compactMap{
            //             Establishment(record: $0, database: self.publicDB)
            //        }
            DispatchQueue.main.async {
               // player = AVPlayer(url: Bundle.main.url(forResource: "vid5", withExtension: "MOV")!)
              //  player?.play()
            }
        }
    }
}

class Model {
    // MARK: - iCloud Info
    let container: CKContainer
    let publicDB: CKDatabase
    let privateDB: CKDatabase
    
    // MARK: - Properties
   // private(set) var establishments: [Establishment] = []
    static var currentModel = Model()
    
    init() {
        container = CKContainer.default()
        publicDB = container.publicCloudDatabase
        privateDB = container.privateCloudDatabase
    }
    
    @objc func refresh(_ completion: @escaping (Error?) -> Void) {
        let predicate = NSPredicate(value: true)
        
        let query = CKQuery(recordType: "Establishment", predicate: predicate)
        
        establishments(forQuery: query, completion)
    }
    
    private func establishments(forQuery query: CKQuery, _ completion: @escaping (Error?) -> Void) {
        publicDB.perform(query, inZoneWith: CKRecordZone.default().zoneID){
            [weak self] results, error in
            guard let self = self else {return}
            if let error = error {
                DispatchQueue.main.async{
                    completion(error)
                }
                return
            }
            guard let results = results else { return }
    //        self.establishments = results.compactMap{
   //             Establishment(record: $0, database: self.publicDB)
    //        }
            DispatchQueue.main.async {
                completion(nil)
            }
        }
    }
}
