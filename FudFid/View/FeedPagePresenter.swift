//
//  FeedPagePresenter.swift
//  StreamLabsAssignment
//
//  Created by on Jude on 16/02/2019.
//  Copyright © 2019 streamlabs. All rights reserved.
//

import Foundation
import AVFoundation
import ProgressHUD
import FirebaseStorage

var maxID = 15
var allGifs = [StorageReference]()

protocol FeedPagePresenterProtocol: class {
    func viewDidLoad()
    func fetchNextFeed() -> IndexedFeed?
    func fetchPreviousFeed() -> IndexedFeed?
    func updateFeedIndex(fromIndex index: Int)
    func updateFeed( index: Int, increasing: Bool) -> [Feed]
}

class FeedPagePresenter: FeedPagePresenterProtocol {
    

    
    fileprivate unowned var view: FeedPageView
    fileprivate var fetcher: FeedFetchProtocol
    fileprivate var feeds: [Feed] = []
    fileprivate var currentFeedIndex = 0
    
    init(view: FeedPageView, fetcher: FeedFetchProtocol = FeedFetcher()) {
        self.view = view
        self.fetcher = fetcher
    }
    
    func viewDidLoad() {
        fetcher.delegate = self
        configureAudioSession()
        fetchFeeds()
        
        
    }
    
    func fetchNextFeed() -> IndexedFeed? {
        return getFeed(atIndex: currentFeedIndex + 1)
    }
    
    func fetchPreviousFeed() -> IndexedFeed? {
        return getFeed(atIndex: currentFeedIndex - 1)
    }
    
    func updateFeedIndex(fromIndex index: Int) {
        currentFeedIndex = index
    }
    
    
    fileprivate func configureAudioSession() {
        try! AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback, options: [])
    }
    
    fileprivate func fetchFeeds() {
        view.startLoading()
        fetcher.fetchFeeds()
    }
    
    fileprivate func getFeed(atIndex index: Int) -> IndexedFeed? {
        
        let min = feeds.map{$0.id}.min() ?? 0
        let max = feeds.map{$0.id}.max() ?? 15
        
        guard index >= min && index <= max else {
            return nil
        }

        // return (feed: feeds[index], index: index)
        return (feeds.filter({$0.id == index}).first! , index)
    }
    
    
}




extension FeedPagePresenter: FeedFetchDelegate {
    func feedFetchService(_ service: FeedFetchProtocol, didFetchFeeds feeds: [Feed], withError error: Error?) {
        view.stopLoading()
        
        if let error = error {
            view.showMessage(error.localizedDescription)
            return
        }
        
       self.feeds = self.initialiseHardCodedFeed()
       // self.feeds = self.initialiseFirebaseFeed()
        
        /// our feed is stored in presenter
        //self.feeds = feeds
        
        
        guard let initialFeed = self.feeds.first else {
            view.showMessage("No Availavle Video Feeds")
            return
        }
        view.presentInitialFeed(initialFeed)
    }
    
  
    func updateFeed( index : Int, increasing : Bool) -> [Feed]{
        
        //let docsPath = Bundle.main.resourcePath!
        var docsPath = Bundle.main.path(forResource: "vid1", ofType: ".MOV")
        docsPath = String((docsPath?.dropLast(8))!)
        let fileManager = FileManager.default

        do {
            let docsArray = try fileManager.contentsOfDirectory(atPath: docsPath!).filter({$0.hasSuffix(".MP4")||$0.hasSuffix(".MOV")})
            let gifArray = try fileManager.contentsOfDirectory(atPath: docsPath!).filter({$0.hasSuffix(".gif")})
            let soundsArray = try fileManager.contentsOfDirectory(atPath: docsPath!).filter({$0.hasSuffix(".mp3")})
            let imageArray = try fileManager.contentsOfDirectory(atPath: docsPath!).filter({$0.hasSuffix(".jpeg") || $0.hasSuffix(".png")})
        
       // self.feeds = Array(feeds.dropFirst())
        
        maxID = maxID + 1
        
        let type = ["localVideo", "localVideo", "gif", "gif", "image", "text"].randomElement()
                 //let type = "gif"
                 switch type{
                     case "localVideo":
                         let vid = Feed(id: maxID, url: nil, path: savedContent(filename: docsArray.randomElement()!), text: nil, gif: nil, sound: nil, image: nil)
                         self.feeds.append(vid)
                     case "text":
                         let vid = Feed(id: maxID, url: nil, path: savedContent(filename: ["bac1.mp4", "bac2.mov","background3.mp4", "bac4.mp4", "bac3.mp4"].randomElement()!), text: phrases.randomElement(), gif: nil, sound: nil, image: nil)
                         self.feeds.append(vid)
                     case "gif":
                         let vid = Feed(id: maxID, url: nil, path: nil, text: nil, gif: gifArray.randomElement()!, sound: soundsArray.randomElement(), image: nil)
                         self.feeds.append(vid)
                     case "image":
                         let vid = Feed(id: maxID, url: nil, path: nil, text: nil, gif: nil, sound: nil, image: imageArray.randomElement())
                         self.feeds.append(vid)
                     default: break // add a placeholder here
                 }
        }
        catch{
                    print("Local video loading failed")
        }
        
        print(self.feeds.map{$0.id})
        
        DispatchQueue.global(qos: .background).async {
            print("This is run on the background queue")
        }
        
        return feeds
    }
    
    func initialiseFirebaseFeed() ->[Feed]{
        //FeedPagePresenter.initialiseFirebaseFeed()

        
        var list = [Feed]()
        
        
        let storageReference = Storage.storage().reference()
        
        // let imageDownloadURLReference = storageReference.child("centralImages/fbtestpic.jpeg")
        let imageDownloadURLReference = storageReference.child("centralGifs/")
//        var allGifs = [StorageReference]()
        
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
                print(item)
            }
        }
  //      myImageView.sd_setImage(with: imageDownloadURLReference, placeholderImage: UIImage(named: "peas.jpg"))
        
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
//        let localURL = URL(string: path + "test.gif")!
//
//        // Download to the local filesystem
//        let downloadTask = imageDownloadURLReference.write(toFile: localURL) { url, error in
//          if let error = error {
//            print(error.localizedDescription)
//          } else {
//            print("Hurrah!")
//          }
//        }
//        do{
//        let gifArray = try FileManager.default.contentsOfDirectory(atPath: path).filter({$0.hasSuffix("test.gif")})
//        for i in 1...15{
//        /// later include remote video and sti;; images
//
//            let vid = Feed(id: i, url: nil, path: nil, text: nil, gif: gifArray.randomElement(), sound: nil, image: nil)
//        list.append(vid)
//        }
//        }
//        catch{
//            print(error.localizedDescription)
//        }
//
        return list
    }
    
    /// this is an ugly hack . I am placing this in view when it clearly should be model
    func initialiseHardCodedFeed() -> [Feed]{
        /// master list of material
        
        /// load a random selection of these (including your own)
        
//        let f1 = Feed(id: 0, url: nil, path: savedContent(filename: "vid1.MOV"))
//        let f2 = Feed(id: 0, url: nil, path: savedContent(filename: "vid2.MP4"))
//        let f3 = Feed(id: 0, url: nil, path: savedContent(filename: "vid3.MP4"))
//        let f4 = Feed(id: 0, url: nil, path: savedContent(filename: "vid4.MP4"))
//        let f5 = Feed(id: 0, url: nil, path: savedContent(filename: "vid5.MOV"))
//        
        //let docsPath = Bundle.main.resourcePath!
        var docsPath = Bundle.main.path(forResource: "vid1", ofType: ".MOV")
        docsPath = String((docsPath?.dropLast(8))!)
        let fileManager = FileManager.default

        var list = [Feed]()
        do {
            let docsArray = try fileManager.contentsOfDirectory(atPath: docsPath!).filter({$0.hasSuffix(".MP4")||$0.hasSuffix(".MOV")})
            let gifArray = try fileManager.contentsOfDirectory(atPath: docsPath!).filter({$0.hasSuffix(".gif")})
            let soundsArray = try fileManager.contentsOfDirectory(atPath: docsPath!).filter({$0.hasSuffix(".mp3")})
            let imageArray = try fileManager.contentsOfDirectory(atPath: docsPath!).filter({$0.hasSuffix(".jpeg") || $0.hasSuffix(".png")})
            
            let onboarding = Feed(id: 0, url: nil, path: savedContent(filename: "onboardingBackground.mov") , text: "Swipe Left To Have Some Fun!", gif: nil, sound: nil, image: nil)
            list.append(onboarding)
               
            for i in 1...15{
                /// later include remote video and sti;; images
                
                
               let type = ["localVideo", "localVideo", "gif", "gif", "image", "text"].randomElement()
                //let type = "gif"
                switch type{
                    case "localVideo":
                        let vid = Feed(id: i, url: nil, path: savedContent(filename: docsArray.randomElement()!), text: nil, gif: nil, sound: nil, image: nil)
                        list.append(vid)
                    case "text":
                        let vid = Feed(id: i, url: nil, path: savedContent(filename: ["bac1.mp4", "bac2.mov","background3.mp4", "bac4.mp4", "bac3.mp4"].randomElement()!), text: phrases.randomElement(), gif: nil, sound: nil, image: nil)
                        list.append(vid)
                    case "gif":
                        let vid = Feed(id: i, url: nil, path: nil, text: nil, gif: gifArray.randomElement()!, sound: soundsArray.randomElement(), image: nil)
                        list.append(vid)
                    case "image":
                        let vid = Feed(id: i, url: nil, path: nil, text: nil, gif: nil, sound: nil, image: imageArray.randomElement())
                        list.append(vid)
                    default: break // add a placeholder here
                }

            }
            print(list)
        }
        catch{
                print("Local video loading failed")
            }
   
        return list
    }
}
