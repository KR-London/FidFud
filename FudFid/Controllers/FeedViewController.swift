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
    fileprivate var feed: Feed!
    fileprivate var isPlaying: Bool!
    var Label = UILabel()
    let synthesizer = AVSpeechSynthesizer()
    var utterance = AVSpeechUtterance()
    var gifView = UIImageView()
    var soundtrack = AVAudioPlayer()
    

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
//        
//        myLikeButton = {
//        let button = myLikeButton()
//        button.heightAnchor.constraint(equalToConstant: 100).isActive = true
//         button.widthAnchor.constraint(equalToConstant: 100).isActive = true
//        //button.addTarget(self, action: #selector(eatNowSegue), for: .touchUpInside)
//        return button
//    }()

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
        //stack.spacing = 10
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
    
  

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeFeed()
        
            if feed.gif == nil{
                    if feed.image == nil {
                        gifView.isHidden = true
                    }
               }
               else{
                    gifView.isHidden  = false
                    gifView = UIImageView(frame: self.view.frame)
                    gifView.contentMode = .scaleAspectFit
                    gifView.image = UIImage.gifImageWithName(name: String(feed.gif!.dropLast(4)) ?? "")
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
                if feed.image == nil{
                        if feed.gif == nil {
                            gifView.isHidden = true
                        }
                     }
                     else{
                            gifView.isHidden  = false
                          gifView = UIImageView(frame: self.view.frame)
                          gifView.contentMode = .scaleAspectFit
                            let imageName = feed.image?.components(separatedBy: ".")[0]
        
                    gifView.image = UIImage(named: feed.image ?? "")
                        ///gifView.contentMode = .scaleAspectFit
                          self.contentOverlayView?.addSubview(gifView)
                          view.bringSubviewToFront(gifView)
        }
        
        if feed.text == nil{
            Label.isHidden = true
        }
        else{
            Label = UILabel(frame: self.view.frame)
            Label.text = feed.text
            self.contentOverlayView?.addSubview(Label)
            Label.textAlignment = .center
            Label.font = UIFont(name: "TwCenMT-CondensedExtraBold", size: 70 )
            Label.lineBreakMode = .byWordWrapping
            Label.numberOfLines = 7
            Label.frame.inset(by: UIEdgeInsets(top: 15,left: 15,bottom: 15,right: 15))
            Label.textColor = [#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),#colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1),#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1),#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1),#colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1)].randomElement()
            view.bringSubviewToFront(Label)
          
        }
        
       
        
        showsPlaybackControls = false
        videoGravity = AVLayerVideoGravity.resizeAspectFill
        
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
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        if let say = Label.text
        {
           // if  isPlaying == true
           // {
                utterance = AVSpeechUtterance(string: say)
                utterance.pitchMultiplier = 2.5
                synthesizer.speak(utterance)
           // }
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
        
        let url = feed.url
        let input = feed.path
        guard let path = Bundle.main.path(forResource: input?.name, ofType:input?.format) else {
            debugPrint("video not found")
            return
        }
        player = AVPlayer(url: URL(fileURLWithPath: path))
        isPlaying ? play() : nil
 
    }
    
    @objc func likeTapped(_ sender: UIButton) {
        if sender.backgroundImage(for: .normal) == UIImage(systemName: "heart")
        {
            sender.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
            sender.tintColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
            feed.liked = true
            
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
