import Foundation
import UIKit
import AVKit
import AVFoundation
import Firebase
import JellyGif

class FeedViewController: AVPlayerViewController, StoryboardScene, UIPickerViewDataSource, UIPickerViewDelegate {
 
    static var sceneStoryboard = UIStoryboard(name: "Main", bundle: nil)
    var index: Int!
    var feed: Feed!
    fileprivate var isPlaying: Bool!
    var Label = UILabel()
    let synthesizer = AVSpeechSynthesizer()
    var utterance = AVSpeechUtterance()
    var gifView = JellyGifImageView()
    var soundtrack = AVAudioPlayer()
    var didPause = Bool()
    
    
  //  let userRef = Firestore.firestore().collection("users")
    
    let defaults = UserDefaults.standard
    
    //MARK: Picker view set up
    let reasons = ["Not for me", "Wrong", "Upsetting", "Too loud", "Seems rude", "Boring", "Pushy"]
    var reason = String()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return reasons.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return reasons[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        reason = reasons[row]
        self.view.endEditing(true)
    }

    //MARK: Lazy instantiation of elements
    lazy var likeButton :        UIButton = {
        
            let button = UIButton()
        
            button.heightAnchor.constraint(equalToConstant: 100).isActive = true
            button.widthAnchor.constraint(equalToConstant: 100).isActive = true
            button.titleLabel!.text = "Like"
            button.tintColor = UIColor.green
            button.layer.cornerRadius = 50
            
            button.addTarget(self, action: #selector(likeTapped(_:)), for: .touchUpInside)
        
            return button
        }()
    
    lazy var dislikeButton :        UIButton = {
        
        let button = UIButton()
        
        button.heightAnchor.constraint(equalToConstant: 100).isActive = true
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.titleLabel!.text = "Dislike"
        if #available(iOS 13.0, *) {
            button.setImage(UIImage(systemName: "hand.raised.slash"), for: .normal)
        } else {
            button.setTitle("X", for: .normal)
        }
        button.tintColor = UIColor.green
        button.layer.cornerRadius = 50
        
        button.addTarget(self, action: #selector(dislikeTapped(_:)), for: .touchUpInside)

        return button
    }()

    lazy var profilePicture : UIImageView = {
        
        let pic = UIImageView()
        
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
                gifView = JellyGifImageView(frame: self.view.frame)
                gifView.contentMode = .scaleAspectFit
                
               if let imgData = try? Data.init(contentsOf: documentsURL.appendingPathComponent(String(feed.image ?? "")))
               {
                    gifView.image = UIImage.init(data: imgData )!
                }
               else{
                    gifView.image = UIImage(named: String((feed.image?.split(separator: ".").first) ?? "") )
                }
                
                self.contentOverlayView?.addSubview(gifView)
                view.bringSubviewToFront(gifView)
            }
        }
        else{
            gifView.isHidden  = false
            gifView = JellyGifImageView(frame: self.view.frame)
            gifView.contentMode = .scaleAspectFit

           // gifView.image = UIImage.gifImageWithURL(gifUrl: documentsURL.appendingPathComponent(String(feed.gif ?? "")).absoluteString) ?? UIImage.gifImageWithName(name: feed.gif!) ?? UIImage.gifImageWithName(name: String((feed.gif?.dropLast(4))!) )
            gifView.startGif(with: .localPath(feed.gif!))
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
        
        didPause = false
        kateExtractedFunc()
        
        profilePicture.image = UIImage(named: ["carrot.png", "cheese.jpg"].randomElement()!)
        
        buttonStack.addArrangedSubview(profilePicture)
        buttonStack.addArrangedSubview(likeButton)
        buttonStack.addArrangedSubview(dislikeButton)
        
        if let liked = defaults.array(forKey: "Liked") as? [String]
        {
            
            //FIXME: feed.gif ??  to persisist likes
            if liked.contains(((feed.text ?? feed.image ?? "")!) )
            {
                feed.liked = true
            }
        }

        self.contentOverlayView?.addSubview(buttonStack)
        
        let frame = self.view.frame
        
        buttonStack.frame = CGRect(x: frame.maxX - 150, y: frame.maxY - 400, width: 150, height: 300)

        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        player?.pause()
        synthesizer.pauseSpeaking(at: AVSpeechBoundary.word)
        if #available(iOS 13.0, *) {
            soundtrack.stop()
        }
        else {
            // Fallback on earlier versions
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        player?.play()
        synthesizer.continueSpeaking()
 
        if #available(iOS 13.0, *) {
            if feed.liked == true{
                
                likeButton.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
                
            }
            else{
                likeButton.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
            }
            likeButton.tag = feed.id
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        // Reads out the label in a random Anglophone voice
        if let say = Label.text
        {
            utterance = AVSpeechUtterance(string: say)
            utterance.pitchMultiplier = [Float(1), Float(1.1), Float(1.4), Float(1.5) ].randomElement()!
            utterance.rate = [Float(0.5), Float(0.4),Float(0.6),Float(0.7)].randomElement()!
            let language = [AVSpeechSynthesisVoice(language: "en-AU"),AVSpeechSynthesisVoice(language: "en-GB"),AVSpeechSynthesisVoice(language: "en-IE"),AVSpeechSynthesisVoice(language: "en-US"),AVSpeechSynthesisVoice(language: "en-IN"), AVSpeechSynthesisVoice(language: "en-ZA")]
            utterance.voice =  language.randomElement()!!
            synthesizer.speak(utterance)
        }
        
        if feed.sound != nil
        {
            // soundtrack.play()
        }
    }
    
    func play() {
        player?.play()
    }
    
    func pause() {
        player?.pause()
    }
    
    
    fileprivate func initializeFeed() {

        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        var url: URL
        
        if let path = feed.path
        {
            if let location = Bundle.main.url(forResource: path.name, withExtension:path.format)
            {
                url = location
            }
            else
            {
                url = documentsURL.appendingPathComponent( String(((path.name)!)) + "." + String(((path.format)!)))
            }
            
            player = AVPlayer(url: url)
            NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem, queue: .main) { [weak self] _ in
                self?.player?.seek(to: CMTime.zero)
                self?.player?.play()
            }
            
        }
        isPlaying ? play() : nil
    }
    
    // Pauses video playback on tap
    //FIXME: pause gifs and voice
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        
        didPause = !didPause
        if didPause{
            pause()
        }
        else{
            play()
        }
    }
    
    // Notes a like
    // toggles the value in user defaults, and changes appearance of button to match.
    @objc func likeTapped(_ sender: UIButton) {
        var liked = defaults.array(forKey: "Liked") as? [String]
        
        if #available(iOS 13.0, *) {
            if sender.backgroundImage(for: .normal) == UIImage(systemName: "heart")
            {
                sender.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
                sender.tintColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
                feed.liked = true
                ///FIXME: Likes not persisiting(feed.gif as String)
                let ref =  feed.image ?? feed.text ??  ""
                
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
                
                //FIXME: feed.gif ?? to persisist likes 
                let ref = feed.image ?? feed.text ??  ""
                
                if let _ = liked {
                    liked = liked!.filter{ $0 != ref}
                }
                defaults.set( liked , forKey: "Liked")
            }
        } else {
            //FIXME: How to handle likes in iOS12
        }
        
        //TODO: How to persist likes
//        let dataToSave : [String: Any] = ["name": feed.originalFilename, "liked": feed.liked]
//        
//        let docRef = userRef.document(Auth.auth().currentUser?.email ?? "Anonymous" + String(Int.random(in: 1...1000))).collection("likes").document(feed.originalFilename)
//        
//        docRef.setData(dataToSave){
//            (error) in
//            if let error = error {
//                print("Crumbs!")
//                print( error.localizedDescription )
//            }
//            else{
//                print("Data has been saved")
//            }
//        }
    }
    
    
    // Notes that the user doesn't like a certain post
    // Gets some clarification why, and sends the data to Firestore
    @objc func dislikeTapped(_ sender: UIButton) {
        
        pause()
        
        let reasonPicker = UIPickerView()

        reasonPicker.dataSource = self
        reasonPicker.delegate = self

        let alert = UIAlertController(title: "Don't Want This?", message: "Can you tell me why to help me do better in future? \n\n\n\n\n\n\n\n\n\n\n\n", preferredStyle: .alert)
        alert.view.addSubview(reasonPicker)
        reasonPicker.frame = CGRect(x: 0, y: 40, width: 270, height: 200)
        
        let selectAction = UIAlertAction(title: "OK", style: .default, handler: saveDislike)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(selectAction.copy() as! UIAlertAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
        
    }
    
    func saveDislike(_ input: UIAlertAction){
        print("ME NO LIKE")
        defaults.set( [feed.originalFilename] , forKey: "disliked")

        //TODO: Likes

      //  let dataToSave : [String: Any] = ["name": feed.originalFilename, "reason": reason]

     //   let docRef = userRef.document(Auth.auth().currentUser?.email ?? "Anonymous" + String(Int.random(in: 1...1000))).collection("dislikes").document(feed.originalFilename)

//        docRef.setData(dataToSave){
//            (error) in
//            if let error = error {
//                print("Crumbs!")
//                print( error.localizedDescription )
//            }
//            else{
//                print("Data has been saved")
//            }
//        }
        
        // Create new Alert
        
        var dialogMessage = UIAlertController(title: "Thank you", message: "We have noted you don't like this, and it won't show up in future sessions. We will also personally review your feedback to try to do better for you in the future.", preferredStyle: .alert)
        
        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
        })
        
        //Add OK button to a dialog message
        dialogMessage.addAction(ok)
        // Present Alert to
        self.present(dialogMessage, animated: true, completion: nil)
    }
}
