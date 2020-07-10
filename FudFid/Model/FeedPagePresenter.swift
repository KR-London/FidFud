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
import CloudKit

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
    fileprivate var gifs: [Gif] = []
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
        
        //        self.feeds.append(contentsOf: freshMeat(folderReference: "centralGifs", suffix: [".gif"]))
        //        self.feeds.append(contentsOf: freshMeat(folderReference: "centralImages", suffix: [".jpg"]))
        //        ////self.feeds.append(contentsOf: freshMeat(folderReference: "centralVideos", suffix: [".MOV", ".MP4"]))
        //        self.feeds.append(contentsOf: freshMeat(folderReference: "centralGifs", suffix: [".gif"]))
        //        self.feeds.append(contentsOf: freshMeat(folderReference: "centralImages", suffix: [".jpg"]))
        //        self.feeds.append(contentsOf: encouragingPhrases())
        
        //self.feeds.append(contentsOf: initialiseHardCodedFeed())
        
       // self.feeds.shuffle()
        
        
        self.gifs.append(contentsOf: loadGifsFromCloud())
        
       // let onboarding = Feed(id: 0, url: nil, path: nil , text: "Swipe Left To Have Some Fun!", gif: nil, sound: nil, image: nil, originalFilename: "onboarding")
       // self.feeds = [onboarding] + self.feeds
        
      //  let endSecreen = Feed(id: 0, url: nil, path: savedContent(filename: "onboardingBackground.mov") , text: "Come back tomorrow for fresh Fud Fid!", gif: nil, sound: nil, image: nil, originalFilename: "endScreen")
     //   self.feeds.append(endSecreen)
        
//        if let disliked = UserDefaults.standard.array(forKey: "disliked") as? [String]
//        {
//            self.feeds = self.feeds.filter{ disliked.contains($0.originalFilename) == false }
//            
//            
//            //            if liked.contains(((feed.gif ?? feed.text ?? feed.image ?? "")!) )
//            //            {
//            //                feed.liked = true
//            //            }
//        }
//        
        
//        for i in 0 ... self.feeds.count-1{
//            self.feeds[i].id = i
//        }
        
        if self.gifs.count > 0 {
            for i in 0 ... self.gifs.count-1{
                self.gifs[i].id = i
            }
        }
//
//        guard let initialFeed = self.feeds.first else {
//            view.showMessage("No Availavle Video Feeds")
//            return
//        }
        
        guard let initialFeed = self.gifs.first else {
            view.showMessage("No Available Gif Feeds")
            return
        }
        view.presentInitialFeed(initialFeed)
    }
    
    func encouragingPhrases() -> [Feed]{
        var list =  [Feed]()
        let soundsArray = try? fileManager.contentsOfDirectory(atPath: String(docsPathSound!)).filter({$0.hasSuffix(".mp3")})
        
        let stringy = try? String(contentsOfFile: Bundle.main.path(forResource: "phrases", ofType: ".tsv")!)
        let savedPhrases = stringy?.components(separatedBy: "\t").filter{$0 != "" && $0 != "\r\n"}
        
        for i in 0 ... 10
        {
            let words = savedPhrases?.randomElement()
            let sounds = soundsArray?.randomElement()
            let vid = Feed(id: i, url: nil, path: nil, text: words ?? "Keep going!", gif: nil, sound: sounds, image: nil, originalFilename: words! + sounds!)
            list.append(vid)
        }
        return list
    }
    
    fileprivate func loadNewFeedItemFromLocal() {
        
        //let docsPath = Bundle.main.resourcePath!
        var docsPath = Bundle.main.path(forResource: "vid1", ofType: ".MOV")
        docsPath = String((docsPath?.dropLast(8))!)
        //   let fileManager = FileManager.default
        
        let stringy = try? String(contentsOfFile: Bundle.main.path(forResource: "phrases", ofType: ".tsv")!)
        let phrases = stringy?.components(separatedBy: "\t").filter{$0 != "" && $0 != "\r\n"}
        
        
        do {
            let docsArray = try fileManager.contentsOfDirectory(atPath: docsPath!).filter({$0.hasSuffix(".MP4")||$0.hasSuffix(".MOV")})
            let gifArray = try fileManager.contentsOfDirectory(atPath: docsPath!).filter({$0.hasSuffix(".gif")})
            let soundsArray = try fileManager.contentsOfDirectory(atPath: docsPath!).filter({$0.hasSuffix(".mp3")})
            let imageArray = try fileManager.contentsOfDirectory(atPath: docsPath!).filter({$0.hasSuffix(".jpg") || $0.hasSuffix(".png")})
            
            let type = ["localVideo", "localVideo", "gif", "gif", "image", "text"].randomElement()
            
            switch type{
                case "localVideo":
                    let content = docsArray.randomElement()!
                    let vid = Feed(id: feeds.count, url: nil, path: savedContent(filename: content), text: nil, gif: nil, sound: nil, image: nil, originalFilename: content)
                    
                    self.feeds.append(vid)
                case "text":
                    let content = phrases?.randomElement() ?? "Happy Day!"
                    let vid = Feed(id: feeds.count, url: nil, path: savedContent(filename: ["bac1.mp4", "bac2.mov","background3.mp4", "bac4.mp4", "bac3.mp4"].randomElement()!), text: content, gif: nil, sound: nil, image: nil, originalFilename: content)
                    self.feeds.append(vid)
                case "gif":
                    let content = gifArray.randomElement()!
                    let vid = Feed(id: feeds.count, url: nil, path: nil, text: nil, gif: content, sound: soundsArray.randomElement(), image: nil, originalFilename: content)
                    self.feeds.append(vid)
                case "image":
                    let content = imageArray.randomElement()
                    let vid = Feed(id: feeds.count, url: nil, path: nil, text: nil, gif: nil, sound: nil, image: content, originalFilename: content!)
                    self.feeds.append(vid)
                default: break // add a placeholder here
            }
        }
        catch{
            print("Local video loading failed")
        }
    }
    
    func loadGifsFromCloud()-> [Gif]{
        let pred = NSPredicate(value: true)
        let query = CKQuery(recordType: "Establishment", predicate:  pred)
        
        let operation = CKQueryOperation(query: query)
        
        var loadedFeed = [Feed]()
        var whatIGot = [Gif]()
        
        operation.recordFetchedBlock = {
            record in
            let gif = Gif()
            
            gif.id = 0
            gif.recordID = record.recordID
            gif.category = record["category"]
            
            if let asset = record["gif"] as? CKAsset{
                gif.gif = asset.fileURL
            }
            
            whatIGot.append(gif)
           // let feed = Feed(id: 0, url: gif.gif, path: gif.gif, text: nil, gif: nil, sound: nil, image: nil, originalFilename: nil)
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
        
        
        
        return whatIGot
    }
    /// update this func
    func updateFeed( index : Int, increasing : Bool) -> [Feed]{
        
        var itemToAddToEndOfLoop = feeds[index]
        itemToAddToEndOfLoop.id = feeds.count - 1
        feeds.append(itemToAddToEndOfLoop)
        
        return feeds
    }
    
    func freshMeat(folderReference: String, suffix: [String]) -> [Feed]{
        
        //TODO:  point to icloud
        
        
        
        var list = [Feed]()
        var listOfFiles = [URL]()
        let storageReference = Storage.storage().reference()
        
        // Create a reference to the file you want to download
        let starsRef = storageReference.child("/masterFluffyList")
        print(starsRef)
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        starsRef.getData(maxSize: 1 * 1024 * 1024 * 1024) { data, error in
            if let error = error {
                print("Getting Master Fluffy List data FAILED \(error.localizedDescription)")
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
        
        let listOfFilesWithThisFormat = listOfRemoteFiles[folderReference]
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
        
        let listOfFilenames = listOfFiles.map{$0.absoluteString}.filter{suffix.contains(String($0.suffix(4)))}.map{$0.dropLast(4)}
        
        for i in 1 ... 10{
            let iStoredFiles = listOfFilenames.filter{String($0.last!) == String(i)}.map{$0.dropLast()}.map{$0.last!}
            print(i)
            print("iStoredFiles")
            print(iStoredFiles)
            print(suffix)
            
            switch iStoredFiles{
                case [] :
                    
                    list.append( loadFeedItemFromBundle(suffix: suffix.first ?? "") )
                    let localSavePath = documentsURL.appendingPathComponent("0" + String(i) + saveSuffix)
                    
                    var originalFilename = listOfFilesWithThisFormat?.randomElement()!
                    
                    if originalFilename?.suffix(4) == ".jpg"{
                        originalFilename = String((originalFilename?.dropLast(4))!)
                        originalFilename = originalFilename! + ".jpeg"
                    }
                    
                    
                    let storageReference = imageDownloadURLReference.child( originalFilename! )
                    
                    DispatchQueue.main.async {
                        // Download to the local filesystem
                        let downloadTask = storageReference.write(toFile: localSavePath) { url, error in
                            if let error = error {
                                // Uh-oh, an error occurred!
                                print("Bart has left the building \(String(error.localizedDescription))")
                                
                                
                                
                                
                            } else {
                                print("click to see Bart" + String(folderReference))
                                //  list.append(self.AddToFeed(folderReference: folderReference, prefix:  "0" + String(i)))
                            }
                        }
                    }
                    
                    
                    let localSavePath2 = documentsURL.appendingPathComponent("1" + String(i) + saveSuffix)
                    
                    let storageReference2 = imageDownloadURLReference.child((listOfFilesWithThisFormat?.randomElement())! )
                    
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
                    
                    let storageReference = imageDownloadURLReference.child((listOfFilesWithThisFormat?.randomElement())! )
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
                    print("2 file found - going to reference it to feed and download another cache")
                    let localSavePath = documentsURL.appendingPathComponent("2" + String(i) + saveSuffix)
                    
                    var location = (listOfFilesWithThisFormat?.randomElement())!
                    
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
                    
                    /// delete 0
                    do{
                        try fileManager.removeItem(at: documentsURL.appendingPathComponent("0" + String(i) + saveSuffix))
                    }
                    catch{
                        print(error.localizedDescription)
                }
                
                case  ["2", "1"], ["1", "2"]:
                    print("2 file found - going to reference it to feed and download another cache")
                    let localSavePath = documentsURL.appendingPathComponent("0" + String(i) + saveSuffix)
                    
                    var location = (listOfFilesWithThisFormat?.randomElement())!
                    
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
                    list.append(AddToFeed(folderReference: folderReference, prefix:  "2" + String(i)))
                    
                    /// delete 0
                    do{
                        try fileManager.removeItem(at: documentsURL.appendingPathComponent("1" + String(i) + saveSuffix))
                    }
                    catch{
                        print(error.localizedDescription)
                }
                
                case  ["0", "2"], ["2", "0"]:
                    print("2 file found - going to reference it to feed and download another cache")
                    let localSavePath = documentsURL.appendingPathComponent("1" + String(i) + saveSuffix)
                    
                    var location = (listOfFilesWithThisFormat?.randomElement())!
                    
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
                    list.append(AddToFeed(folderReference: folderReference, prefix:  "0" + String(i)))
                    
                    /// delete 0
                    do{
                        try fileManager.removeItem(at: documentsURL.appendingPathComponent("2" + String(i) + saveSuffix))
                    }
                    catch{
                        print(error.localizedDescription)
                }
                
                case ["0", "1", "2"], ["1", "0", "2"] , ["1", "2", "0"] , ["0", "2", "1"] , ["2", "1", "0"] , ["2", "0", "1"]:
                    list.append(AddToFeed(folderReference: folderReference, prefix:  "1" + String(i)))
                    
                    /// delete 0
                    do{
                        try fileManager.removeItem(at: documentsURL.appendingPathComponent("2" + String(i) + saveSuffix))
                    }
                    catch{
                        print(error.localizedDescription)
                }
                
                default: print("Confused.com")
            }
        }
        return list
    }
    
    func AddToFeed( folderReference: String, prefix: String ) -> Feed{
        switch folderReference{
            case "centralGifs":
                let soundsArray = try? fileManager.contentsOfDirectory(atPath: String(docsPathSound!)).filter({$0.hasSuffix(".mp3")})
                return Feed(id: 0, url: nil, path: nil, text: nil, gif: prefix + ".gif", sound: soundsArray?.randomElement(), image: nil, originalFilename: prefix + ".gif")
            case "centralImages": return Feed(id: 0, url: nil, path: nil, text: nil, gif: nil, sound: nil, image: prefix + ".jpg", originalFilename: prefix + ".jpeg")
            case "centralVideos": return Feed(id: 0, url: nil, path: savedContent(filename: prefix + ".MP4"), text: nil, gif: nil, sound: nil, image: nil, originalFilename: prefix + ".MP4")
            default: return Feed(id: 0, url: nil, path: nil, text: nil, gif: nil, sound: nil, image: nil, originalFilename: "This is an empty post no one should ever see")
        }
    }
    
    func loadFeedItemFromBundle(suffix: String) -> Feed{
        
        var docsPath = Bundle.main.path(forResource: "vid1", ofType: ".MOV")
        docsPath = String((docsPath?.dropLast(8))!)
        let fileManager = FileManager.default
        
        let stringy = try? String(contentsOfFile: Bundle.main.path(forResource: "phrases", ofType: ".tsv")!)
        let phrases = stringy?.components(separatedBy: "\t").filter{$0 != "" && $0 != "\r\n"}
        
        do {
            /// remake with an enum
            switch suffix{
                case ".gif", ".GIF":
                    let gifArray = try fileManager.contentsOfDirectory(atPath: docsPath!).filter({$0.hasSuffix(".gif")})
                    let soundsArray = try fileManager.contentsOfDirectory(atPath: docsPath!).filter({$0.hasSuffix(".mp3")})
                    let content = gifArray.randomElement()!
                    return Feed(id: 0, url: nil, path: nil, text: nil, gif: content, sound: soundsArray.randomElement(), image: nil, originalFilename: content)
                case ".jpg", ".png":
                    let imageArray = try fileManager.contentsOfDirectory(atPath: docsPath!).filter({$0.hasSuffix(".jpg") || $0.hasSuffix(".png")})
                    let content = imageArray.randomElement()
                    return Feed(id: 0, url: nil, path: nil, text: nil, gif: nil, sound: nil, image: content, originalFilename: content!)
                case ".MP4", ".MOV":
                    let docsArray = try fileManager.contentsOfDirectory(atPath: docsPath!).filter({$0.hasSuffix(".MP4")||$0.hasSuffix(".MOV")})
                    let content = docsArray.randomElement()!
                    return Feed(id: 0, url: nil, path: savedContent(filename: content), text: nil, gif: nil, sound: nil, image: nil, originalFilename: content)
                default:
                    let content = phrases!.randomElement()
                    return Feed(id: 0, url: nil, path: savedContent(filename: ["bac1.mp4", "bac2.mov","background3.mp4", "bac4.mp4", "bac3.mp4"].randomElement()!), text: content, gif: nil, sound: nil, image: nil, originalFilename: content!)
            }
        }
        catch{
            print("Local video loading failed")
        }
        let content = phrases!.randomElement()
        return Feed(id: 0, url: nil, path: savedContent(filename: ["bac1.mp4", "bac2.mov","background3.mp4", "bac4.mp4", "bac3.mp4"].randomElement()!), text: content, gif: nil, sound: nil, image: nil, originalFilename: content!)
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
        
        let stringy = try? String(contentsOfFile: Bundle.main.path(forResource: "phrases", ofType: ".tsv")!)
        let phrases = stringy?.components(separatedBy: "\t").filter{$0 != "" && $0 != "\r\n"}
        
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
            
            //  let onboarding = Feed(id: 0, url: nil, path: savedContent(filename: "onboardingBackground.mov") , text: "Swipe Left To Have Some Fun!", gif: nil, sound: nil, image: nil, originalFilename: "Swipe left to have some fun")
            //   list.append(onboarding)
            
            for i in 1...30{
                /// later include remote video and sti;; images
                
                
                let type = ["localVideo", "localVideo", "gif", "gif", "image", "text"].randomElement()
                //let type = "gif"
                switch type{
                    case "localVideo":
                        let content = docsArray.randomElement()!
                        let vid = Feed(id: i, url: nil, path: savedContent(filename: content), text: nil, gif: nil, sound: nil, image: nil, originalFilename: content)
                        list.append(vid)
                    case "text":
                        let content = phrases!.randomElement()
                        let vid = Feed(id: i, url: nil, path: savedContent(filename: ["bac1.mp4", "bac2.mov","background3.mp4", "bac4.mp4", "bac3.mp4"].randomElement()!), text: content, gif: nil, sound: nil, image: nil, originalFilename: content!)
                        list.append(vid)
                    case "gif":
                        let content = gifArray.randomElement()!
                        let vid = Feed(id: i, url: nil, path: nil, text: nil, gif: content, sound: soundsArray.randomElement(), image: nil, originalFilename: content)
                        list.append(vid)
                    case "image":
                        let content = imageArray.randomElement()!
                        let vid = Feed(id: i, url: nil, path: nil, text: nil, gif: nil, sound: nil, image: content, originalFilename: content)
                        list.append(vid)
                    default: break // add a placeholder here
                }
                
            }
            //     print(list)
        }
        catch{
            print("Local video loading failed")
        }
        
        return list
    }
}


