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






struct listOfFiles: Decodable{
    var gifs: [String]
    var images: [String]
    var videos: [String]
}

class FeedPagePresenter: FeedPagePresenterProtocol {
    

    
    fileprivate unowned var view: FeedPageView
    fileprivate var fetcher: FeedFetchProtocol
    fileprivate var feeds: [Feed] = []
    fileprivate var currentFeedIndex = 0
    
    var docsPathSound = Bundle.main.path(forResource: "bac1", ofType: ".mp4")?.dropLast(8)
    let fileManager = FileManager.default
    
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
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback, options: [])
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
        self.feeds.append(contentsOf: freshMeat(folderReference: "centralImages", suffix: [".jpg"]))
        self.feeds.append(contentsOf: freshMeat(folderReference: "centralVideos", suffix: [".MOV", ".MP4"]))
        self.feeds.append(contentsOf: freshMeat(folderReference: "centralGifs", suffix: [".gif"]))
        self.feeds.append(contentsOf: freshMeat(folderReference: "centralImages", suffix: [".jpg"]))
        self.feeds.append(contentsOf: encouragingPhrases())
        
        self.feeds.shuffle()
        
        let onboarding = Feed(id: 0, url: nil, path: savedContent(filename: "onboardingBackground.mov") , text: "Swipe Left To Have Some Fun!", gif: nil, sound: nil, image: nil)
        self.feeds = [onboarding] + self.feeds
        
        for i in 0 ... self.feeds.count-1{
            self.feeds[i].id = i 
        }
        
        guard let initialFeed = self.feeds.first else {
            view.showMessage("No Availavle Video Feeds")
            return
        }
        view.presentInitialFeed(initialFeed)
    }
    
    func encouragingPhrases() -> [Feed]{
        var list =  [Feed]()
        let soundsArray = try? fileManager.contentsOfDirectory(atPath: String(docsPathSound!)).filter({$0.hasSuffix(".mp3")})
        
        let stringy = try? String(contentsOfFile: Bundle.main.path(forResource: "phrases", ofType: ".tsv")!)
        let savedPhrases = stringy?.components(separatedBy: "\t").filter{$0 != "" && $0 != "\r\n"}
        
        //savedContent(filename: ["bac1.mp4", "bac2.mov","background3.mp4", "bac4.mp4", "bac3.mp4"].randomElement()!)
 
        for i in 0 ... 10
        {
            let vid = Feed(id: i, url: nil, path: nil, text: savedPhrases?.randomElement() ?? "Keep going!", gif: nil, sound: soundsArray?.randomElement(), image: nil)
            list.append(vid)
        }
        return list
    }

    fileprivate func loadNewFeedItemFromLocal() {
        
        //let docsPath = Bundle.main.resourcePath!
        var docsPath = Bundle.main.path(forResource: "vid1", ofType: ".MOV")
        docsPath = String((docsPath?.dropLast(8))!)
     //   let fileManager = FileManager.default

        
        do {
            let docsArray = try fileManager.contentsOfDirectory(atPath: docsPath!).filter({$0.hasSuffix(".MP4")||$0.hasSuffix(".MOV")})
            let gifArray = try fileManager.contentsOfDirectory(atPath: docsPath!).filter({$0.hasSuffix(".gif")})
            let soundsArray = try fileManager.contentsOfDirectory(atPath: docsPath!).filter({$0.hasSuffix(".mp3")})
            let imageArray = try fileManager.contentsOfDirectory(atPath: docsPath!).filter({$0.hasSuffix(".jpg") || $0.hasSuffix(".png")})
            
            // self.feeds = Array(feeds.dropFirst())
            
            
            
            let type = ["localVideo", "localVideo", "gif", "gif", "image", "text"].randomElement()
            //let type = "gif"
            switch type{
                case "localVideo":
                    let vid = Feed(id: feeds.count, url: nil, path: savedContent(filename: docsArray.randomElement()!), text: nil, gif: nil, sound: nil, image: nil)
                    self.feeds.append(vid)
                case "text":
                    let vid = Feed(id: feeds.count, url: nil, path: savedContent(filename: ["bac1.mp4", "bac2.mov","background3.mp4", "bac4.mp4", "bac3.mp4"].randomElement()!), text: phrases.randomElement(), gif: nil, sound: nil, image: nil)
                    self.feeds.append(vid)
                case "gif":
                    let vid = Feed(id: feeds.count, url: nil, path: nil, text: nil, gif: gifArray.randomElement()!, sound: soundsArray.randomElement(), image: nil)
                    self.feeds.append(vid)
                case "image":
                    let vid = Feed(id: feeds.count, url: nil, path: nil, text: nil, gif: nil, sound: nil, image: imageArray.randomElement())
                    self.feeds.append(vid)
                default: break // add a placeholder here
            }
        }
        catch{
            print("Local video loading failed")
        }
    }

    /// update this func
    func updateFeed( index : Int, increasing : Bool) -> [Feed]{
        
        var itemToAddToEndOfLoop = feeds[index]
        itemToAddToEndOfLoop.id = feeds.count - 1
        feeds.append(itemToAddToEndOfLoop)
        
        return feeds
    }
    
    
    func freshGifs() -> [Feed]{
        
        var list = [Feed]()
        var listOfFiles = [URL]()

        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let storageReference = Storage.storage().reference()
        let imageDownloadURLReference = storageReference.child("centralGifs/")
        
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
        let storageReference = Storage.storage().reference()
        
        // Create a reference to the file you want to download
        let starsRef = storageReference.child("/masterFluffyList")
        print(starsRef)
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        starsRef.getData(maxSize: 1 * 1024 * 1024 * 1024) { data, error in
            if let error = error {
                // Uh-oh, an error occurred!
            } else {
                // Data for "images/island.jpg" is returned
                let image = UIImage(data: data!)
            }
        }

var listOfRemoteFiles = [String: [String]]()
        let stringy = try? String(contentsOfFile: Bundle.main.path(forResource: "masterFluffyList", ofType: ".txt")!)

        let elements = stringy?.components(separatedBy: "$") ?? ["200-5.gif","92182160-633E-49F5-991E-6F754070A6E7.jpg" ,"IMG_1316.MOV"]
              for i in 0 ... elements.count - 1 {
                
                var dictKey = ""
                switch i{
                    case 0: dictKey = "centralGifs"
                    case 1: dictKey = "centralImages"
                    case 2: dictKey = "centralVideos"
                    default: dictKey = "central"
                }
            
                listOfRemoteFiles[dictKey] = elements[i].components(separatedBy: ",")
}

        var listOfFilesWithThisFormat = listOfRemoteFiles[folderReference]
        var saveSuffix = String()

        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let imageDownloadURLReference = storageReference.child(folderReference)
        
        switch folderReference{
            case "centralGifs":  saveSuffix =  ".gif"
            case "centralImages": saveSuffix =  ".jpg"
            case "centralVideos": saveSuffix =  ".MP4"
            default: saveSuffix = "FAIL"
        }
        
        
        do {
            listOfFiles = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            // process files
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }

//        let cache = NSCache<NSString, ExpensiveObjectClass>()
//        let myObject: ExpensiveObjectClass
//        
//        if let cachedVersion = cache.object(forKey: "CachedObject") {
//            // use the cached version
//            myObject = cachedVersion
//        } else {
//            // create it from scratch then store in the cache
//            myObject = ExpensiveObjectClass()
//            cache.setObject(myObject, forKey: "CachedObject")
//        }
        
//        let dog = "dog.cap"
//        dog.se
        
        // not striclty necessary now really
        var listOfFilenames = listOfFiles.map{$0.absoluteString}.filter{suffix.contains(String($0.suffix(4)))}.map{$0.dropLast(4)}
        
                for i in 1 ... 5{
                    let iStoredFiles = listOfFilenames.filter{String($0.last!) == String(i)}.map{$0.dropLast()}.map{$0.last!}
                    print(i)
                    print("iStoredFiles")
                    print(iStoredFiles)
                    print(suffix)
                    
                    switch iStoredFiles{
                        case [] :
                        
                        let localSavePath = documentsURL.appendingPathComponent("0" + String(i) + saveSuffix)
                        let storageReference = imageDownloadURLReference.child((listOfFilesWithThisFormat?.randomElement())! as! String)
                        
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
                        }
                        list.append(AddToFeed(folderReference: folderReference, prefix:  "0" + String(i)))
                        
                        let localSavePath2 = documentsURL.appendingPathComponent("1" + String(i) + saveSuffix)
                        
                        let storageReference2 = imageDownloadURLReference.child((listOfFilesWithThisFormat?.randomElement())! as! String)
                        
                        DispatchQueue.main.async {
                            // Download to the local filesystem
                            let downloadTask = storageReference2.write(toFile: localSavePath2) { url, error in
                                if let error = error {
                                    // Uh-oh, an error occurred!
                                    print("Lisa has left the building \(String(error.localizedDescription))")
                                } else {
                                    print("click to see Lisa" + String(folderReference))
                                }
                            }
                        }
                        
                        case ["0"]:
                            print("1 file found - going to reference it to feed and download another cache")
                            let localSavePath = documentsURL.appendingPathComponent("1" + String(i) + saveSuffix)
                            
                            let storageReference = imageDownloadURLReference.child((listOfFilesWithThisFormat?.randomElement())! as! String)
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
                        }

                       list.append(AddToFeed(folderReference: folderReference, prefix:  "0" + String(i)))


                        case  ["0", "1"], ["1", "0"]:
                            print("1 file found - going to reference it to feed and download another cache")
                            let localSavePath = documentsURL.appendingPathComponent("2" + String(i) + saveSuffix)
                            
                            var location = (listOfFilesWithThisFormat?.randomElement())! as! String
                            
                            if location.split(separator: ".").last == "jpg"{
                                location = location.dropLast(3) + "jpeg"
                            }

                            let storageReference = imageDownloadURLReference.child(location)
                            
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
                            }
                            list.append(AddToFeed(folderReference: folderReference, prefix:  "1" + String(i)))
                        
                        case ["0", "1", "2"], ["1", "0", "2"] , ["1", "2", "0"] , ["0", "2", "1"] , ["2", "1", "0"] , ["2", "0", "1"]:
//                            print("1 file found - going to reference it to feed and download another cache")
//                            let localSavePath = documentsURL.appendingPathComponent("2" + String(i) + saveSuffix)
//
//                            let storageReference = imageDownloadURLReference.child((listOfFilesWithThisFormat?.randomElement())! as! String)
//                            DispatchQueue.main.async {
//                                // Download to the local filesystem
//                                let downloadTask = storageReference.write(toFile: localSavePath) { url, error in
//                                    if let error = error {
//                                        // Uh-oh, an error occurred!
//                                        print("Lisa has left the building \(String(error.localizedDescription))")
//                                    } else {
//                                        print("click to see Lisa" + String(folderReference))
//                                    }
//                                }
//                            }
                            list.append(AddToFeed(folderReference: folderReference, prefix:   ["0", "1", "2"].randomElement()! + String(i)))
                        
                        default: print("Confused.com")
                    }
                
                    
        }
        //            switch iStoredFiles.count{
        
        
//
//        for i in 1 ... 5{
//            let iStoredFiles = listOfFilenames.filter{String($0.last!) == String(i)}
//            switch iStoredFiles.count{
//                case 0:
//                    print("No files found - going to copy from bundle and download to cache")
//
//                    let localSavePath = documentsURL.appendingPathComponent("0" + String(i) + saveSuffix)
//                    let storageReference = imageDownloadURLReference.child((listOfFilesWithThisFormat?.randomElement())! as! String)
//
//                    DispatchQueue.main.async {
//                        // Download to the local filesystem
//                        let downloadTask = storageReference.write(toFile: localSavePath) { url, error in
//                            if let error = error {
//                                // Uh-oh, an error occurred!
//                                print("Bart has left the building \(String(error.localizedDescription))")
//                            } else {
//                                print("click to see Bart" + String(folderReference))
//                            }
//                        }
//                    }
//                list.append(AddToFeed(folderReference: folderReference, prefix:  "0" + String(i)))
//
//                case 1:
//                    print("1 file found - going to reference it to feed and download another cache")
//                    let localSavePath = documentsURL.appendingPathComponent("1" + String(i) + saveSuffix)
//
//                    //allGifs.randomElement()
//                    let storageReference = imageDownloadURLReference.child((listOfFilesWithThisFormat?.randomElement())! as! String)
//                    DispatchQueue.main.async {
//                        // Download to the local filesystem
//                        let downloadTask = storageReference.write(toFile: localSavePath) { url, error in
//                            if let error = error {
//                                // Uh-oh, an error occurred!
//                                print("Lisa has left the building \(String(error.localizedDescription))")
//                            } else {
//                                print("click to see Lisa" + String(folderReference))
//                            }
//                        }
//                    }
//
//
//
//                    // let myFeed = Feed(id: i, url: nil, path: nil, text: nil, gif: localSavePath.absoluteString, sound: nil, image: nil)
//                    //let myFeed = Feed(id: i, url: nil, path: nil, text: nil, gif: "1" + String(i) + ".gif", sound: nil, image: nil)
//
//                   // addToFeed( folderReference: String, prefix: String)
//
//                    // maybe want something smarter here to confirm its available
//                    list.append(AddToFeed(folderReference: folderReference, prefix:  "0" + String(i)))
//
//                default:
//                    print("More than 2 file found - going to reference the highest indexed, delete the others and download a fresh file cache at the next highest number")
//                    let localSavePath = documentsURL.appendingPathComponent("2" + String(i) + saveSuffix)
//
//                    //allGifs.randomElement()
//                    let storageReference = imageDownloadURLReference.child((listOfFilesWithThisFormat?.randomElement())!)
//                    DispatchQueue.main.async {
//                        // Download to the local filesystem
//                        let downloadTask = storageReference.write(toFile: localSavePath) { url, error in
//                            if let error = error {
//                                // Uh-oh, an error occurred!
//                                print("Lisa has left the building \(String(error.localizedDescription))")
//                            } else {
//                                print("click to see Lisa" + String(folderReference))
//                            }
//                        }
//
//                    }
//
//                    list.append(AddToFeed(folderReference: folderReference, prefix:  "1" + String(i)))
//            }
//        }
//
        return list
    }
    
    func AddToFeed( folderReference: String, prefix: String ) -> Feed{
        switch folderReference{
            case "centralGifs":
                let soundsArray = try? fileManager.contentsOfDirectory(atPath: String(docsPathSound!)).filter({$0.hasSuffix(".mp3")})
                 return Feed(id: 0, url: nil, path: nil, text: nil, gif: prefix + ".gif", sound: soundsArray?.randomElement(), image: nil)
            case "centralImages": return Feed(id: 0, url: nil, path: nil, text: nil, gif: nil, sound: nil, image: prefix + ".jpg")
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
            let imageArray = try fileManager.contentsOfDirectory(atPath: docsPath!).filter({$0.hasSuffix(".jpg") || $0.hasSuffix(".png")})
            
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


