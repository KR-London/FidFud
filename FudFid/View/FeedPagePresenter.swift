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


var listOfRemoteFiles = [
    "centralGifs" :     [
                        "200-5.gif",
                        "200-6.gif",
                        "200w-10.gif",
                        "200w-11.gif", "200w-12.gif", "200w-13.gif",
                        "200w-14.gif",
                        "200w-15.gif",
                        "200w-16.gif",
                        "200w-17.gif",
                        "200w-18.gif", "200w-19.gif", "200w-20.gif",
                        "200w-9.gif"
                        ],
    "centralImages":   [
                        "92182160-633E-49F5-991E-6F754070A6E7.jpeg",
                        "97040F93-7E91-441D-B24E-EC29AC23377A.jpeg",
                        "E239E9A2-39DC-4774-B9D9-A8F2E23515CF.jpeg",
                        "fbtestpic.jpeg"
                        ],
     "centralVideos":  [
                        "IMG_1316.MOV",
                        "IMG_1317.MOV",
                        "IMG_1318.MOV",
                        "IMG_1320.MP4",
                        "IMG_1321.MP4",
                        "IMG_1322.MP4",
                        "IMG_1323.MOV"
                        ]
]

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
        
      // self.feeds = self.initialiseHardCodedFeed()
       // self.feeds = self.initialiseFirebaseFeed()
        
        /// our feed is stored in presenter
        //self.feeds = feeds
        
        //self.feeds.append(contentsOf: freshGifs())
        
        self.feeds.append(contentsOf: freshMeat(folderReference: "centralGifs", suffix: [".gif"]))
        self.feeds.append(contentsOf: freshMeat(folderReference: "centralImages", suffix: [".jpeg"]))
        self.feeds.append(contentsOf: freshMeat(folderReference: "centralVideos", suffix: [".MOV", "MP4"]))
        self.feeds.shuffle()
        
        for i in 0 ... self.feeds.count-1{
            self.feeds[i].id = i 
        }
        
        guard let initialFeed = self.feeds.first else {
            view.showMessage("No Availavle Video Feeds")
            return
        }
        view.presentInitialFeed(initialFeed)
    }
    
  
    
    /// update this func
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
        
        maxID = maxID + 1
        print(self.feeds.map{$0.id})
        
        DispatchQueue.global(qos: .background).async {
            print("This is run on the background queue")
        }
        
        return feeds
    }
    
    
    func freshGifs() -> [Feed]{
        
        var list = [Feed]()
        var listOfFiles = [URL]()

        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let storageReference = Storage.storage().reference()
        let imageDownloadURLReference = storageReference.child("centralGifs/")
        
        /// this seems to be problematic because it doesn't return quick enough for me to use it
        /// thinking I should have a local or database list of files for this
        /// indeed that would let me prioritise content I haven's seen yet.
//        imageDownloadURLReference.listAll{ (result, error) in
//            if let error = error {
//                print("Can't see the files")
//            }
//            for prefix in result.prefixes {
//                // The prefixes under storageReference.
//                // You may call listAll(completion:) recursively on them.
//            }
//            for item in result.items {
//                allGifs.append(item)
//                print(item)
//            }
//        }
    
        
        do {
            listOfFiles = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            // process files
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }

        /// filter list of files to .gif suffix
        
        var listOfFilenames = listOfFiles.map{$0.absoluteString}.filter{$0.suffix(4) == ".gif"}.map{$0.dropLast(4)}
        print(listOfFilenames)

        for i in 1 ... 5{
            let iStoredFiles = listOfFilenames.filter{String($0.last!) == String(i)}
            switch iStoredFiles.count{
                case 0:
                    print("No files found - going to copy from bundle and download to cache")
                    
                    let localSavePath = documentsURL.appendingPathComponent("0" + String(i) + ".gif")
                     let storageReference = imageDownloadURLReference.child("giphy-3" + ".gif")
              
                        //allGifs.randomElement()
                    
                    DispatchQueue.main.async {
                        // Download to the local filesystem
                        let downloadTask = storageReference.write(toFile: localSavePath) { url, error in
                            if let error = error {
                                // Uh-oh, an error occurred!
                                print("Bart has left the building \(String(error.localizedDescription))")
                            } else {
                                print("click to see Bart")
                            }
                        }
                        
                        downloadTask.observe(.progress) { snapshot in
                            // Download reported progress
                            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                                / Double(snapshot.progress!.totalUnitCount)
                        }
                    }
                
                    let myFeed = Feed(id: i, url: nil, path: nil, text: nil, gif: "0" + String(i) + ".gif", sound: nil, image: nil)
                    list.append(myFeed)
                    
                case 1:
                    print("1 file found - going to reference it to feed and download another cache")
                    let localSavePath = documentsURL.appendingPathComponent("1" + String(i) + ".gif")
                   
                    //allGifs.randomElement()
                    let storageReference = imageDownloadURLReference.child("200w-1" + String(i) + ".gif")
                    DispatchQueue.main.async {
                        // Download to the local filesystem
                        let downloadTask = storageReference.write(toFile: localSavePath) { url, error in
                            if let error = error {
                                // Uh-oh, an error occurred!
                                print("Lisa has left the building \(String(error.localizedDescription))")
                            } else {
                                print("click to see Lisa")
                            }
                        }
                        
                    downloadTask.observe(.progress) { snapshot in
                        // Download reported progress
                        let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                            / Double(snapshot.progress!.totalUnitCount)
                    }
                }
                
                   // let myFeed = Feed(id: i, url: nil, path: nil, text: nil, gif: localSavePath.absoluteString, sound: nil, image: nil)
                    let myFeed = Feed(id: i, url: nil, path: nil, text: nil, gif: "1" + String(i) + ".gif", sound: nil, image: nil)
                    list.append(myFeed)
                
                default:
                    print("More than 2 file found - going to reference the highest indexed, delete the others and download a fresh file cache at the next highest number")
                    let myFeed = Feed(id: i, url: nil, path: nil, text: nil, gif: "1" + String(i) + ".gif", sound: nil, image: nil)
                    list.append(myFeed)
            }
        }

        return list
    }
    
    
    func freshMeat(folderReference: String, suffix: [String]) -> [Feed]{
        
        var list = [Feed]()
        var listOfFiles = [URL]()
        var listOfFilesWithThisFormat = listOfRemoteFiles[folderReference]
        
        var saveSuffix = String()

        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let storageReference = Storage.storage().reference()
        let imageDownloadURLReference = storageReference.child(folderReference)
        
        switch folderReference{
            case "centralGifs":  saveSuffix =  ".gif"
            case "centralImages": saveSuffix =  ".jpeg"
            case "centralVideos": saveSuffix =  ".MP4"
            default: saveSuffix = "FAIL"
        }
        
        
        do {
            listOfFiles = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            // process files
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }

        // not striclty necessary now really
        var listOfFilenames = listOfFiles.map{$0.absoluteString}.filter{suffix.contains(String($0.suffix(4)))}.map{$0.dropLast(4)}

        for i in 1 ... 5{
            let iStoredFiles = listOfFilenames.filter{String($0.last!) == String(i)}
            switch iStoredFiles.count{
                case 0:
                    print("No files found - going to copy from bundle and download to cache")
                    
                    let localSavePath = documentsURL.appendingPathComponent("0" + String(i) + saveSuffix)
                    let storageReference = imageDownloadURLReference.child((listOfFilesWithThisFormat?.randomElement())!)
                    
                    DispatchQueue.main.async {
                        // Download to the local filesystem
                        let downloadTask = storageReference.write(toFile: localSavePath) { url, error in
                            if let error = error {
                                // Uh-oh, an error occurred!
                                print("Bart has left the building \(String(error.localizedDescription))")
                            } else {
                                print("click to see Bart" + String(folderReference))
                            }
                        }
                        
//                        downloadTask.observe(.progress) { snapshot in
//                            // Download reported progress
//                            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
//                                / Double(snapshot.progress!.totalUnitCount)
//                        }
                    }
                    
                    
                    list.append(AddToFeed(folderReference: folderReference, prefix:  "0" + String(i)))
                
                case 1:
                    print("1 file found - going to reference it to feed and download another cache")
                    let localSavePath = documentsURL.appendingPathComponent("1" + String(i) + saveSuffix)
                    
                    //allGifs.randomElement()
                    let storageReference = imageDownloadURLReference.child((listOfFilesWithThisFormat?.randomElement())!)
                    DispatchQueue.main.async {
                        // Download to the local filesystem
                        let downloadTask = storageReference.write(toFile: localSavePath) { url, error in
                            if let error = error {
                                // Uh-oh, an error occurred!
                                print("Lisa has left the building \(String(error.localizedDescription))")
                            } else {
                                print("click to see Lisa" + String(folderReference))
                            }
                        }
                        
                        downloadTask.observe(.progress) { snapshot in
                            // Download reported progress
                            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                                / Double(snapshot.progress!.totalUnitCount)
                        }
                    }
                    
                    // let myFeed = Feed(id: i, url: nil, path: nil, text: nil, gif: localSavePath.absoluteString, sound: nil, image: nil)
                    //let myFeed = Feed(id: i, url: nil, path: nil, text: nil, gif: "1" + String(i) + ".gif", sound: nil, image: nil)
                    
                   // addToFeed( folderReference: String, prefix: String)
                    
                    // maybe want something smarter here to confirm its available 
                    list.append(AddToFeed(folderReference: folderReference, prefix:  "0" + String(i)))
                
                default:
                    print("More than 2 file found - going to reference the highest indexed, delete the others and download a fresh file cache at the next highest number")
                    let localSavePath = documentsURL.appendingPathComponent("2" + String(i) + saveSuffix)
                    
                    //allGifs.randomElement()
                    let storageReference = imageDownloadURLReference.child((listOfFilesWithThisFormat?.randomElement())!)
                    DispatchQueue.main.async {
                        // Download to the local filesystem
                        let downloadTask = storageReference.write(toFile: localSavePath) { url, error in
                            if let error = error {
                                // Uh-oh, an error occurred!
                                print("Lisa has left the building \(String(error.localizedDescription))")
                            } else {
                                print("click to see Lisa" + String(folderReference))
                            }
                        }
                        
                        downloadTask.observe(.progress) { snapshot in
                            // Download reported progress
                            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                                / Double(snapshot.progress!.totalUnitCount)
                        }
                    }
                    
                    list.append(AddToFeed(folderReference: folderReference, prefix:  "2" + String(i)))
            }
        }
        
        return list
    }
    
    func AddToFeed( folderReference: String, prefix: String ) -> Feed{
        switch folderReference{
            case "centralGifs":  return Feed(id: 0, url: nil, path: nil, text: nil, gif: prefix + ".gif", sound: nil, image: nil)
            case "centralImages": return Feed(id: 0, url: nil, path: nil, text: nil, gif: nil, sound: nil, image: prefix + ".jpeg")
            case "centralVideos": return Feed(id: 0, url: nil, path: savedContent(filename: prefix + ".MP4"), text: nil, gif: nil, sound: nil, image: nil)
            default: return Feed(id: 0, url: nil, path: nil, text: nil, gif: nil, sound: nil, image: nil)
        }
    }
    
    func initialiseFirebaseFeed() ->[Feed]{
        //FeedPagePresenter.initialiseFirebaseFeed()

        
        var list = [Feed]()
        
//        let storageReference = Storage.storage().reference()
//
//        // let imageDownloadURLReference = storageReference.child("centralImages/fbtestpic.jpeg")
//        let imageDownloadURLReference = storageReference.child("centralGifs/")
////        var allGifs = [StorageReference]()
//
//        let fileContents = imageDownloadURLReference.listAll{ (result, error) in
//            if let error = error {
//                // ...
//            }
//            for prefix in result.prefixes {
//                // The prefixes under storageReference.
//                // You may call listAll(completion:) recursively on them.
//            }
//            for item in result.items {
//                allGifs.append(item)
//                print(item)
//            }
//        }
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









//
//            //// $0.dropLast(4).lastCharacter = i
//
//            if count of this is zero, copy from bundle to
//            documentURL + "0" + String(i) + ".gif"
//            /// should I delete these and reload?
//
//            /// I should have an intermediate object to store all the gifs and then move it to the Feed
//            list.append(Feed(i, documentURL + "0" + String(i) + ".gif"))
//
//
//            download asynchronously from firebase to
//            documentURL + "1" + String(i) + ".gif"
//
//            if count of this is 1
//            let marker = $0.dropLast(5).lastCharacter
//
//            switch marker{
//                case "2":
//                    list.append(Feed(i, documentURL + "2" + String(i) + ".gif"))
//                    download asynchronously random gif from firebase to documentURL + "0" + String(i) + ".gif"
//                case "1":
//                    list.append(Feed(i, documentURL + "1" + String(i) + ".gif"))
//                    download asynchronously from firebase to documentURL + "2" + String(i) + ".gif"
//                case "0":
//                    list.append(Feed(i, documentURL + "0" + String(i) + ".gif"))
//                    download asynchronously random gif from firebase to documentURL + "1" + String(i) + ".gif"
//                default:
//                    print("Freakout")
//            }
//
//            if count of this is >1
//            let marker = [$0.dropLast(5).lastCharacter].max
//
//            switch marker{
//                case "2":
//                    list.append(Feed(i, documentURL + "2" + String(i) + ".gif"))
//                    delete [$0.dropLast(5).lastCharacter] != [$0.dropLast(5).lastCharacter].max
//                    download asynchronously random gif from firebase to documentURL + "0" + String(i) + ".gif"
//                case "1":
//                    list.append(Feed(i, documentURL + "1" + String(i) + ".gif"))
//                    delete [$0.dropLast(5).lastCharacter] != [$0.dropLast(5).lastCharacter].max
//                    download asynchronously from firebase to documentURL + "2" + String(i) + ".gif"
//                case "0":
//                    list.append(Feed(i, documentURL + "0" + String(i) + ".gif"))
//                    delete [$0.dropLast(5).lastCharacter] != [$0.dropLast(5).lastCharacter].max
//                    download asynchronously random gif from firebase to documentURL + "1" + String(i) + ".gif"
//                default:
//                    print("Freakout")
//            }
//        }
