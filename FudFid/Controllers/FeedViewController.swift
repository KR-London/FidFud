//
//  FeedViewController.swift
//  StreamLabsAssignment
//
//  Created by Jude on 16/02/2019.
//  Copyright © 2019 streamlabs. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import AVFoundation

let phrases = [ "Every bite is a chance to be curious."
          ,"Every sniff is a chance to be curious."
           ,"Every lick is a chance to be curious."
           ,"Buffets: try before you commit."
           ,"Buffets: take tiny tastes of different foods."
            , "Every meal is a fresh start"
          ,"Stay curious!"
             ,"'Normal' eating is different for everyone.",
              "Canned fruits and veg are just as healthy as fresh."
]


class FeedViewController: AVPlayerViewController, StoryboardScene {
    
    static var sceneStoryboard = UIStoryboard(name: "Main", bundle: nil)
    var index: Int!
    var feed: Feed!
    fileprivate var isPlaying: Bool!
    var Label = UILabel()
    let synthesizer = AVSpeechSynthesizer()
    var utterance = AVSpeechUtterance()
    var gifView = UIImageView()
    var soundtrack = AVAudioPlayer()
    
    let defaults = UserDefaults.standard
    

    lazy var likeButton :        UIButton = {
            let button = UIButton()
            button.heightAnchor.constraint(equalToConstant: 100).isActive = true
            button.widthAnchor.constraint(equalToConstant: 100).isActive = true
            button.titleLabel!.text = "Like"
            ///button.setImage(UIImage(systemName: "heart"), for: .normal)
        
            
            
        //button.currentBackgroundImage.as
            button.tintColor = UIColor.green
            button.layer.cornerRadius = 50
            
            button.addTarget(self, action: #selector(likeTapped(_:)), for: .touchUpInside)
           /// button.layer.borderWidth = 5
            //button.layer.borderColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
            return button
        }()

    lazy var profilePicture : UIImageView = {
        let pic = UIImageView()
        //pic.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        pic.heightAnchor.constraint(equalToConstant: 100).isActive = true
        pic.widthAnchor.constraint(equalToConstant: 100).isActive = true
        pic.layer.cornerRadius = 50
        pic.layer.masksToBounds = true
        pic.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        pic.layer.borderWidth = 2
        pic.backgroundColor = .white
        return pic
    }()
    var commentButton = UIButton()
    
    var buttonStack : UIStackView = {
        let stack = UIStackView()
        stack.widthAnchor.constraint(equalToConstant: 150)
        stack.heightAnchor.constraint(equalToConstant: 200)
        stack.axis = .vertical
        stack.alignment = .trailing
        stack.contentMode = .scaleAspectFit
        stack.distribution = .fillProportionally
        return stack
    }()
    
    static func instantiate(feed: Feed, andIndex index: Int, isPlaying: Bool = false) -> UIViewController {
        let viewController = FeedViewController.instantiate()
        viewController.feed = feed
        viewController.index = index
        viewController.isPlaying = isPlaying
        
      //  let viewController = UIViewController()
        return viewController
    }
    
  

    fileprivate func kateExtractedFunc() {
        initializeFeed()
        
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        if feed.gif == nil{
            if feed.image == nil {
                gifView.isHidden = true
            }
            else{
                gifView.isHidden  = false
                gifView = UIImageView(frame: self.view.frame)
                gifView.contentMode = .scaleAspectFit
                //  let imageName = feed.image?.components(separatedBy: ".")[0]
                
                //  gifView.image = UIImage(named: feed.image ?? "")
                //gifView.image = UIImage(contentsOfFile: documentsURL.appendingPathComponent(String(feed.image ?? "")).absoluteString)
                ///gifView.contentMode = .scaleAspectFit
                
               if let imgData = try? Data.init(contentsOf: documentsURL.appendingPathComponent(String(feed.image ?? "")))
               {
                gifView.image = UIImage.init(data: imgData )!
                }
                
                self.contentOverlayView?.addSubview(gifView)
                view.bringSubviewToFront(gifView)
            }
        }
        else{
            gifView.isHidden  = false
            gifView = UIImageView(frame: self.view.frame)
            gifView.contentMode = .scaleAspectFit
            // gifView.image = UIImage.gifImageWithName(name: String(feed.gif!.dropLast(4)) ?? "")
            gifView.image = UIImage.gifImageWithURL(gifUrl: documentsURL.appendingPathComponent(String(feed.gif ?? "")).absoluteString)
            //gifImageWithURL(gifUrl: documentsURL.appendingPathComponent(String(feed.gif ?? "")))
            //  Name(name: docsPath + "/" +  String(feed.gif ?? ""))
            
            print("I'm trying to open " + (feed.gif ?? "bugger all"))
            self.contentOverlayView?.addSubview(gifView)
            view.bringSubviewToFront(gifView)
            
            if feed.sound != nil{
                let path = Bundle.main.path(forResource: feed.sound, ofType:nil)!
                let url = URL(fileURLWithPath: path)
                
                do {
                    soundtrack = try AVAudioPlayer(contentsOf: url)
                    //soundtrack.play()
                } catch {
                    // couldn't load file :(
                }
            }
        }

  
        
        if feed.text == nil{
            Label.isHidden = true
        }
        else{
            view.backgroundColor = [#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1),#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1),#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1),#colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1),#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)].randomElement()
            Label = UILabel(frame: self.view.frame)
            Label.text = feed.text
            self.contentOverlayView?.addSubview(Label)
            Label.textAlignment = .center
            Label.font = UIFont(name: "TwCenMT-CondensedExtraBold", size: 70 )
            Label.lineBreakMode = .byWordWrapping
            Label.numberOfLines = 7
            Label.frame.inset(by: UIEdgeInsets(top: 15,left: 15,bottom: 15,right: 15))
            Label.textColor = [#colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1), #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1),#colorLiteral(red: 0.1921568662, green: 0.007843137719, blue: 0.09019608051, alpha: 1),#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1),#colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1),#colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)].randomElement()
            view.bringSubviewToFront(Label)
            
        }
        
        
        
        showsPlaybackControls = false
        videoGravity = AVLayerVideoGravity.resizeAspectFill
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kateExtractedFunc()
        
        profilePicture.image = UIImage(named: ["carrot.png", "cheese.jpg", "peas.jpg"].randomElement()!)
        
      
        
        buttonStack.addArrangedSubview(profilePicture)
        buttonStack.addArrangedSubview(likeButton)
        
       // likeButton.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        ///buttonStack.alignment = .trailing
       // buttonStack.translatesAutoresizingMaskIntoConstraints = false
        self.contentOverlayView?.addSubview(buttonStack)
        
        let frame = self.view.frame
        
        buttonStack.frame = CGRect(x: frame.maxX - 150, y: frame.maxY - 300, width: 150, height: 200)
//        buttonStack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//        buttonStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//
//
       /// buttonStack.frame = CGRect(x: 0, y: 0, width: 100, height: 300)
        ///self.view.bringSubviewToFront(buttonStack)
            
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        player?.pause()
        synthesizer.pauseSpeaking(at: AVSpeechBoundary.word)
        soundtrack.stop()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        player?.play()
        synthesizer.continueSpeaking()
       print(feed.liked)
             if feed.liked == true{
                likeButton.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
             }
             else{
                likeButton.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
            }
        likeButton.tag = feed.id
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        if let say = Label.text
        {
           // if  isPlaying == true
           // {
                utterance = AVSpeechUtterance(string: say)
            utterance.pitchMultiplier = [Float(1), Float(1.1), Float(1.4), Float(1.5) ].randomElement() as! Float
            utterance.rate = [Float(0.5), Float(0.4),Float(0.6),Float(0.7)].randomElement() as! Float
            let language = [AVSpeechSynthesisVoice(language: "en-AU"),AVSpeechSynthesisVoice(language: "en-GB"),AVSpeechSynthesisVoice(language: "en-IE"),AVSpeechSynthesisVoice(language: "en-US"),AVSpeechSynthesisVoice(language: "en-IN"), AVSpeechSynthesisVoice(language: "en-ZA")]
            utterance.voice =  language.randomElement()!!
                synthesizer.speak(utterance)
        }
        
        if feed.sound != nil
        {
             soundtrack.play()
        }
    }
    
    
    
    func play() {
        player?.play()
    }
    
    func pause() {
        player?.pause()
    }
    
    
    fileprivate func initializeFeed() {
        
        // MARK: I need to bifurcate here to handle the different types of content
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        if let path = feed.path{
            
             let url = documentsURL.appendingPathComponent( String(((path.name)!)) + "." + String(((path.format)!)))
            
             player = AVPlayer(url: url)
            
        }
//        let input = feed.path
//        guard let path = Bundle.main.path(forResource: input?.name, ofType:input?.format) else {
//            debugPrint("video not found")
//            return
//        }
        
//        let input = feed.path
//        guard let path = documentsURL.path(
//
//            Bundle.main.path(forResource: input?.name, ofType:input?.format) else {
//            debugPrint("video not found")
//            return
//        }
        
        
//        player = AVPlayer(url: URL(fileURLWithPath: url))
        isPlaying ? play() : nil
 
    }
    
    
    @objc func likeTapped(_ sender: UIButton) {
        var liked = defaults.array(forKey: "Liked") as? [String]
        
        if sender.backgroundImage(for: .normal) == UIImage(systemName: "heart")
        {
            sender.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
            sender.tintColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
            feed.liked = true
            
            let ref = feed.gif ?? feed.image ?? feed.text ??  ""
            
            if let _ = liked {
                liked = liked! + [ref]
            }
            else{
                liked =  [ref]
            }
         
            defaults.set( liked , forKey: "Liked")
            
        }
        else
        {
            sender.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
            sender.tintColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
            feed.liked = false
        }
        print(feed)
}

}
