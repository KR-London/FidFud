//
//  signInViewController.swift
//  FudFid
//
//  Created by Kate Roberts on 24/05/2020.
//  Copyright © 2020 SaLT for my Squid. All rights reserved.
//

import UIKit
import FirebaseAuth

class signInViewController: UIViewController {
    
    
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBAction func signIn(_ sender: UIButton) {
        
        guard let userEmail = emailAddress.text, !userEmail.isEmpty else {
            self.showMessage(messageToDisplay: "I need your email address to find your account")
            return;
        }
        
        guard let userPassword = password.text, !userPassword.isEmpty else {
            self.showMessage(messageToDisplay: "I need your password to be sure that it's you")
            return;
        }
        
        Auth.auth().signIn(withEmail: userEmail, password: userPassword){
            (user, error) in
            
            if let error = error{
                print(error.localizedDescription)
                self.showMessage(messageToDisplay: error.localizedDescription)
                return
            }
            
            if user != nil
            {
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                       // let newViewController = storyBoard.instantiateViewController(withIdentifier: "addContent") as! AddViewController
                
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "superWhizzyVideoEditor") as! superWhizzyVideoEditorViewController
                        self.present(newViewController, animated: true, completion: nil)
            }
        }

    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    public func showMessage(messageToDisplay : String){
        let alertController = UIAlertController(title: "Ooops!", message: messageToDisplay, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default){
            (action:UIAlertAction!) in
            print("OKButton Tapped")
        }
    
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion: nil)
    }

}
