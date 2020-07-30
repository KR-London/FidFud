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
    var whatIGot = [Gif]()
    
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
        // self.feeds.append(contentsOf: loadGifsFromCloud())
        
        var list = loadFeeed()
        
        if list.count < 10{
            list.append(contentsOf: initialiseHardCodedFeed())
        }
        
        self.feeds.append(contentsOf: list)
       // self.feeds.append(contentsOf: loadLocalImagesFeed())
        self.feeds.append(contentsOf: encouragingPhrases())
        self.feeds.shuffle()
        
        
        //  self.gifs.append(contentsOf: loadGifsFromCloud())
        
        let onboarding = Feed(id: 0, url: nil, path: nil , text: "Swipe Right To Have Some Fun!", gif: nil, sound: nil, image: nil, originalFilename: "onboarding")
        self.feeds = [onboarding] + self.feeds
        
        let endSecreen = Feed(id: 0, url: nil, path: savedContent(filename: "onboardingBackground.mov") , text: "Come back tomorrow for fresh Fud Fid!", gif: nil, sound: nil, image: nil, originalFilename: "endScreen")
        self.feeds.append(endSecreen)
        
        
        ///FIXME: Liked
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
        
        
        for i in 0 ... self.feeds.count-1{
            self.feeds[i].id = i
        }
        //
        //        if self.gifs.count > 0 {
        //            for i in 0 ... self.gifs.count-1{
        //                self.gifs[i].id = i
        //            }
        //        }
        //
        guard let initialFeed = self.feeds.first else {
            view.showMessage("No Availavle Video Feeds")
            return
        }
        
        //        guard let initialFeed = self.gifs.first else {
        //            view.showMessage("No Available Gif Feeds")
        //            return
        //        }
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
                //let vid = Feed(id: feeds.count, url: nil, path: nil, text: nil, gif: URL(content), sound: soundsArray.randomElement(), image: nil, originalFilename: content)
                //  self.feeds.append(vid)
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
    
    func loadGifsFromCloud(filenames: [String])-> Void{
        let pred = NSPredicate(value: true)
        let query = CKQuery(recordType: "Gifs", predicate:  pred)
        let userDefaults = UserDefaults.standard
        
        let operation = CKQueryOperation(query: query)
        var loadedFeed = [Feed]()
        
        /// check what files I already have saved
        var i = 0
        
        operation.recordFetchedBlock = {
            record in
            let gif = Gif()
            
            if i < filenames.count - 1
            {
                gif.id = 1
                gif.recordID = record.recordID
                gif.category = record["category"]
                
                if let asset = record["gif"] as? CKAsset{
                    gif.gif = asset.fileURL
                    
                    if let imageData = NSData(contentsOf: gif.gif)
                    {
                        
                        /// save in the next highest indexed position compared to what is there
                        let absFilename = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(filenames[i])
                        try? imageData.write(to: absFilename)
                        
                        var strings: [String:String] = userDefaults.object(forKey: "alreadyLoaded") as? [String:String] ?? [:]
                        
                        
                        // Add Key-Value Pair to Dictionary
                        strings[String(record.recordID.recordName)] = filenames[i]
                        
                        //   Write/Set Dictionary
                        userDefaults.set(strings, forKey: "alreadyLoaded")
                        
                        /// if I have three saved now delete one
                        
                        let image = UIImage(data: imageData as Data)
                        print(image)
                    }
                }
                i = i+1
            }
            else
            {
                return
            }
            self.whatIGot.append(gif)
        }
        
        operation.queryCompletionBlock = { [unowned self] (cursor, error) in
            DispatchQueue.main.async {
                if error == nil {
                    print(self.whatIGot.first?.category)
                } else {
                    //                    let ac = UIAlertController(title: "Fetch failed", message: "There was a problem fetching the list of gifs; please try again: \(error!.localizedDescription)", preferredStyle: .alert)
                    //                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    //                    self.present(ac, animated: true)
                    
                    print("There was a problem fetching the list of gifs; please try again: \(error!.localizedDescription)")
                }
            }
        }
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
    func updateFeed( index : Int, increasing : Bool) -> [Feed]{
        
        var itemToAddToEndOfLoop = feeds[index]
        itemToAddToEndOfLoop.id = feeds.count - 1
        feeds.append(itemToAddToEndOfLoop)
        
        return feeds
    }
    
    func loadFeeed() -> [Feed]{
        var list = [Feed]()
        var listOfFiles = [URL]()
        let userDefaults = UserDefaults.standard
        
        /// this is a dictionary stored in user defaults that has a list of the files on file, and the id they came with
        let alreadyLoaded = userDefaults.object(forKey: "alreadyLoaded") as? [ String : String]
        
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        print(documentsURL)
        /// first I want to check the list that I have made
        var iStoredFiles = alreadyLoaded?.compactMap{ $0.value as String}  ?? ["     "]
        iStoredFiles = iStoredFiles.compactMap{ String($0.dropLast(4) )}
        var filenamesToLoad = [String]()
        print("iStoredFiles")
        print(iStoredFiles)
        for i in 0 ... 9{
            
            /// filter iStored files for that one, and then drop the last diging
            let iFiles = iStoredFiles.filter({ String($0.last!) == String(i) }).compactMap{ $0.dropLast()}
            
            
            switch (iFiles.compactMap{ String($0.last!) })
            {
                // if I find one file, i want to download the next one
                case ["0"]:
                    let filename = "1" + String(i) + ".gif"
                    print("loading" + filename)
                    filenamesToLoad.append(filename)
                    
                    list.append(Feed(id: i+1, url: nil, path: nil, text: nil, gif: documentsURL.appendingPathComponent("0" + String(i) + ".gif"), sound: nil, image: nil, originalFilename: " "))
                
                case ["1"]:
                    let filename = "2" + String(i) + ".gif"
                    print("loading" + filename)
                    filenamesToLoad.append(filename)
                    
                    list.append(Feed(id: i+1, url: nil, path: nil, text: nil, gif: documentsURL.appendingPathComponent("1" + String(i) + ".gif"), sound: nil, image: nil, originalFilename: " "))
                
                case ["2"]:
                    let filename = "0" + String(i) + ".gif"
                    print("loading" + filename)
                    filenamesToLoad.append(filename)
                    
                    list.append(Feed(id: i+1, url: nil, path: nil, text: nil, gif: documentsURL.appendingPathComponent("2" + String(i) + ".gif"), sound: nil, image: nil, originalFilename: " "))
                
                // if I find two files, i want to download the next one & delete one
                case ["0", "1"], ["1", "0"] :
                    let filename = "2" + String(i) + ".gif"
                    print("loading" + filename)
                    filenamesToLoad.append(filename)
                    
                    list.append(Feed(id: i+1, url: nil, path: nil, text: nil, gif: documentsURL.appendingPathComponent("1" + String(i) + ".gif"), sound: nil, image: nil, originalFilename: " "))
                    
                    do{
                        try fileManager.removeItem(at: documentsURL.appendingPathComponent("0" + String(i) + ".gif"))
                        print(userDefaults)
                        var dict = userDefaults.object(forKey: "alreadyLoaded") as? [ String: String]
                        dict?.removeValue(forKey: "0" + String(i) + ".gif")
                        userDefaults.set(dict, forKey: "alreadyLoaded")
                        print("deleting  file name 0" + String(i))
                    }
                    catch{
                        print(error.localizedDescription)
                }
                
                case ["2", "1"], ["1", "2"] :
                    let filename = "0" + String(i) + ".gif"
                    print("loading" + filename)
                    filenamesToLoad.append(filename)
                    
                    list.append(Feed(id: i+1, url: nil, path: nil, text: nil, gif: documentsURL.appendingPathComponent("2" + String(i) + ".gif"), sound: nil, image: nil, originalFilename: " "))
                    
                    do{
                        try fileManager.removeItem(at: documentsURL.appendingPathComponent("1" + String(i) + ".gif"))
                        
                        print("deleting  file name 1" + String(i))
                    }
                    catch{
                        print(error.localizedDescription)
                }
                
                case ["0", "2"], ["2", "0"] :
                    let filename = "1" + String(i) + ".gif"
                    print("loading" + filename)
                    filenamesToLoad.append(filename)
                    
                    list.append(Feed(id: i+1, url: nil, path: nil, text: nil, gif: documentsURL.appendingPathComponent("0" + String(i) + ".gif"), sound: nil, image: nil, originalFilename: " "))
                    
                    do{
                        try fileManager.removeItem(at: documentsURL.appendingPathComponent("2" + String(i) + ".gif"))
                        print("deleting  file name 2" + String(i))
                    }
                    catch{
                        print(error.localizedDescription)
                }
                case ["0", "1"], ["1", "0"] :
                    let filename = "2" + String(i) + ".gif"
                    print("loading" + filename)
                    filenamesToLoad.append(filename)
                    
                    list.append(Feed(id: i+1, url: nil, path: nil, text: nil, gif: documentsURL.appendingPathComponent("1" + String(i) + ".gif"), sound: nil, image: nil, originalFilename: " "))
                    
                    do{
                        try fileManager.removeItem(at: documentsURL.appendingPathComponent("0" + String(i) + ".gif"))
                        print("deleting  file name 0" + String(i))
                    }
                    catch{
                        print(error.localizedDescription)
                }
                case ["2", "1"], ["1", "2"] :
                    let filename = "0" + String(i) + ".gif"
                    print("loading" + filename)
                    filenamesToLoad.append(filename)
                    
                    list.append(Feed(id: i+1, url: nil, path: nil, text: nil, gif: documentsURL.appendingPathComponent("2" + String(i) + ".gif"), sound: nil, image: nil, originalFilename: " "))
                    
                    do{
                        try fileManager.removeItem(at: documentsURL.appendingPathComponent("1" + String(i) + ".gif"))
                        print("deleting  file name 1" + String(i))
                    }
                    catch{
                        print(error.localizedDescription)
                }
                case ["0", "2"], ["2", "0"] :
                    let filename = "1" + String(i) + ".gif"
                    print("loading" + filename)
                    filenamesToLoad.append(filename)
                    
                    list.append(Feed(id: i+1, url: nil, path: nil, text: nil, gif: documentsURL.appendingPathComponent("0" + String(i) + ".gif"), sound: nil, image: nil, originalFilename: " "))
                    
                    do{
                        try fileManager.removeItem(at: documentsURL.appendingPathComponent("2" + String(i) + ".gif"))
                        print("deleting  file name 2" + String(i))
                    }
                    catch{
                        print(error.localizedDescription)
                }
                case  [] :
                    let filename = "0" + String(i) + ".gif"
                    print("loading" + filename)
                    filenamesToLoad.append(filename)
                    
                    list.append(Feed(id: i+1, url: nil, path: nil, text: nil, gif: documentsURL.appendingPathComponent("0" + String(i) + ".gif"), sound: nil, image: nil, originalFilename: " "))
                    
                    print("No files found. " )
                //  print("loading file name 1" + String(i))
                case ["0", "1", "2"], ["0", "2", "1"], [ "1", "2","0"], [ "2", "1","0"], [ "2", "0","1"] , [ "1", "0","2"]  :
                    
                    list.append(Feed(id: i+1, url: nil, path: nil, text: nil, gif: documentsURL.appendingPathComponent("1" + String(i) + ".gif"), sound: nil, image: nil, originalFilename: " "))
                    
                    do{
                        try fileManager.removeItem(at: documentsURL.appendingPathComponent("0" + String(i) + ".gif"))
                        print("deleting  file name 0" + String(i))
                    }
                    catch{
                        print(error.localizedDescription)
                }
                
                default:
                    print("Pattern not matched")
            }
            
        }
        loadGifsFromCloud(filenames: filenamesToLoad)
        return list
    }
    
    func AddToFeed( folderReference: String, prefix: String ) -> Feed{
        switch folderReference{
            case "centralGifs":
                let soundsArray = try? fileManager.contentsOfDirectory(atPath: String(docsPathSound!)).filter({$0.hasSuffix(".mp3")})
                return Feed(id: 0, url: nil, path: nil, text: nil, gif: URL(string: prefix + ".gif"), sound: soundsArray?.randomElement(), image: nil, originalFilename: prefix + ".gif")
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
                    return Feed(id: 0, url: nil, path: nil, text: nil, gif: URL(fileURLWithPath: content), sound: soundsArray.randomElement(), image: nil, originalFilename: content)
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
    
    /// This function loads in some of the content that the app ships with.Here for the first use, and also as a backup if the user doesn't have internet to refresh content.
    func initialiseHardCodedFeed() -> [Feed]{
        
        let stringy = try? String(contentsOfFile: Bundle.main.path(forResource: "phrases", ofType: ".tsv")!)
        let phrases = stringy?.components(separatedBy: "\t").filter{$0 != "" && $0 != "\r\n"}
        
        var docsPath = Bundle.main.path(forResource: "vid1", ofType: ".MOV")
        docsPath = String((docsPath?.dropLast(8))!)
        let fileManager = FileManager.default
        
        var list = [Feed]()
        do {
            let docsArray = try fileManager.contentsOfDirectory(atPath: docsPath!).filter({$0.hasSuffix(".MP4")||$0.hasSuffix(".MOV")})
            let gifArray = try fileManager.contentsOfDirectory(atPath: docsPath!).filter({$0.hasSuffix(".gif")})
            let soundsArray = try fileManager.contentsOfDirectory(atPath: docsPath!).filter({$0.hasSuffix(".mp3")})
            let imageArray = try fileManager.contentsOfDirectory(atPath: docsPath!).filter({$0.hasSuffix(".jpg") || $0.hasSuffix(".png")})
            
            for i in 1...30{
                /// later include remote video and sti;; images
                
                
                let type = ["gif", "gif", "image", "text"].randomElement()
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
                        let vid = Feed(id: i, url: nil, path: nil, text: nil, gif: URL(fileURLWithPath: content), sound: soundsArray.randomElement(), image: nil, originalFilename: content)
                        list.append(vid)
                    case "image":
                        let content = imageArray.randomElement()!
                        let vid = Feed(id: i, url: nil, path: nil, text: nil, gif: nil, sound: nil, image: content, originalFilename: content)
                        list.append(vid)
                    default: break // add a placeholder here
                }
            }
        }
        catch{
            print("Local video loading failed")
        }
        
        return list
    }
    
    func loadLocalImagesFeed() -> [Feed]{
        
        var docsPath = Bundle.main.path(forResource: "cheese", ofType: ".jpg")
        docsPath = String((docsPath?.dropLast(10))!)
        let fileManager = FileManager.default
        
        var list = [Feed]()
        do {

            let imageArray = try fileManager.contentsOfDirectory(atPath: docsPath!).filter({$0.hasSuffix(".jpeg")})
           print(imageArray)
            
            for i in 1...10{
                
                        let content = imageArray.randomElement()!
                        print(content)
                        let vid = Feed(id: i, url: nil, path: nil, text: nil, gif: nil, sound: nil, image: content, originalFilename: content)
                        list.append(vid)
            }
        }
        catch{
            print(error.localizedDescription)
        }
        
        return list
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(paths[0])
        return paths[0]
    }
    
    func saveFromCloudToLocal(folderReference: String, list: inout [Feed]) -> [Feed]{
        
        var listOfFiles = [URL]()
        
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        //let imageDownloadURLReference = storageReference.child(folderReference)
        let saveSuffix =  ".gif"
        let suffix =  ".gif"
        
        do {
            listOfFiles = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            // process files
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }
        
        let listOfFilenames = listOfFiles.map{$0.absoluteString}.filter{suffix.contains(String($0.suffix(4)))}.map{$0.dropLast(4)}
        
        var i = 0
        
        let pred = NSPredicate(value: true)
        let query = CKQuery(recordType: "Gifs", predicate:  pred)
        
        let operation = CKQueryOperation(query: query)
        //  var loadedFeed = [Feed]()
        
        operation.recordFetchedBlock = {
            record in
            let gif = Gif()
            
            
            gif.id = i
            gif.recordID = record.recordID
            gif.category = record["category"]
            
            if let asset = record["gif"] as? CKAsset{
                gif.gif = asset.fileURL
                
                if let imageData = NSData(contentsOf: gif.gif)
                {
                    /// save in the next highest indexed position compared to what is there
                    let filename = documentsURL.appendingPathComponent("0" + String(i) + saveSuffix)
                    try? imageData.write(to: filename)
                    
                    /// if I have three saved now delete one
                    i = i+1
                    let image = UIImage(data: imageData as Data)
                    print(image)
                }
            }
            
            self.whatIGot.append(gif)
        }
        
        operation.queryCompletionBlock = { [unowned self] (cursor, error) in
            DispatchQueue.main.async {
                if error == nil {
                    print(self.whatIGot.first?.category)
                } else {
                    //                    let ac = UIAlertController(title: "Fetch failed", message: "There was a problem fetching the list of gifs; please try again: \(error!.localizedDescription)", preferredStyle: .alert)
                    //                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    //                    self.present(ac, animated: true)
                    
                    print("There was a problem fetching the list of gifs; please try again: \(error!.localizedDescription)")
                }
            }
        }
        CKContainer.default().publicCloudDatabase.add(operation)
        
        //        for j in 0 .. i {
        //            list.append(self.AddToFeed(folderReference: "centralGifs", prefix: String(j)))
        //        }
        
        return list
    }
    
    
}


